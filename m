Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2310 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2DPKmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:42:38 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Subramania Sharma Thandaveswaran <sharmat@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Fix bug in bg scan configuration in schedule scan
Date: Mon, 16 Apr 2012 16:09:57 +0530
Message-ID: <1334572797-6561-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120416_124240_697381_EA0C3DB2)
In-Reply-To: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com>
References: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Subramania Sharma Thandaveswaran <sharmat@qca.qualcomm.com>

Background scan interval should not be modified while starting
schedule scanning, use the currently configured one instead.

Signed-off-by: Subramania Sharma <sharmat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2088133..a5f4fd9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3121,7 +3121,7 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 
 	ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
 				  interval, interval,
-				  10, 0, 0, 0, 3, 0, 0, 0);
+				  vif->bg_scan_period, 0, 0, 0, 3, 0, 0, 0);
 
 	if (request->n_ssids && request->ssids[0].ssid_len) {
 		for (i = 0; i < request->n_ssids; i++) {
-- 
1.7.1

