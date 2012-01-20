Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37644 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2ATNiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:38:55 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 8/8] ath6kl: Wait for host sleep mode cmd processed event during WOW suspend
Date: Fri, 20 Jan 2012 19:05:44 +0530
Message-ID: <1327066544-23779-9-git-send-email-rmani@qca.qualcomm.com> (sfid-20120120_143859_119487_10F709C9)
In-Reply-To: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_wow_suspend() has to wait until get an
WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENT after sending
set host sleep mode command.

This wait creates perfect sync with the firmware before
the driver enter into wow suspend state.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 038d63b..2d40fd0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1976,11 +1976,25 @@ skip_arp:
 	if (ret)
 		return ret;
 
+	clear_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags);
+
 	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
 						 ATH6KL_HOST_MODE_ASLEEP);
 	if (ret)
 		return ret;
 
+	left = wait_event_interruptible_timeout(ar->event_wq,
+			test_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags),
+			WMI_TIMEOUT);
+	if (left == 0) {
+		ath6kl_warn("timeout, didn't get host sleep cmd processed event\n");
+		ret = -ETIMEDOUT;
+	} else if (left < 0) {
+		ath6kl_warn("error while waiting for host sleep cmd processed event %d\n",
+			    left);
+		ret = left;
+	}
+
 	if (ar->tx_pending[ar->ctrl_ep]) {
 		left = wait_event_interruptible_timeout(ar->event_wq,
 				ar->tx_pending[ar->ctrl_ep] == 0, WMI_TIMEOUT);
-- 
1.7.1

