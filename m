Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1ITQJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 12:09:59 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix disconnect event reporting
Date: Tue, 20 Sep 2011 21:39:59 +0530
Message-ID: <1316534999-26990-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110920_181002_784862_31880960)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver does not report disconnect event properly when in connecting state,
this leads to issues like not reporting the unavailablity of the
connected AP and failures in starting reconnection. Send a disconnect
command to target when a disconnect event is received with reason code
other than 3 (DISCONNECT_CMD - disconnect request from host) to make the
stop trying even after giving disconnect event. There will be one more
disconnect event for this disconnect command which will be notified to
cfg80211.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 3280ff1..8125e71 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -615,22 +615,11 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 		}
 	}
 
-	if (!test_bit(CONNECT_PEND, &ar->flag)) {
-		if (reason != DISCONNECT_CMD)
-			ath6kl_wmi_disconnect_cmd(ar->wmi);
-
-		return;
-	}
-
-	if (reason == NO_NETWORK_AVAIL) {
-		/* connect cmd failed */
+	if (reason != DISCONNECT_CMD) {
 		ath6kl_wmi_disconnect_cmd(ar->wmi);
 		return;
 	}
 
-	if (reason != DISCONNECT_CMD)
-		return;
-
 	clear_bit(CONNECT_PEND, &ar->flag);
 
 	if (ar->sme_state == SME_CONNECTING) {
-- 
1.7.0.4

