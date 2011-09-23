Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12866 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1IWF1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 01:27:46 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] ath6kl: Fix disconnect event reporting
Date: Fri, 23 Sep 2011 10:57:50 +0530
Message-ID: <1316755670-1795-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110923_072749_986246_783217B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver does not report disconnect event properly when in connecting state,
this leads to issues failures in starting reconnection. Send a disconnect
command to target when a disconnect event is received with reason code
other than 3 (DISCONNECT_CMD - disconnect request from host) to make the
frimware stop trying to connect even after giving disconnect event. There
will be one more disconnect event for this disconnect command with reason
code DISCONNECT_CMD which will be notified to cfg80211.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V2 -- Add commands in code and change in commit log

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c3540bb..c84f53d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -602,22 +602,20 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 		}
 	}
 
-	if (!test_bit(CONNECT_PEND, &ar->flag)) {
-		if (reason != DISCONNECT_CMD)
-			ath6kl_wmi_disconnect_cmd(ar->wmi);
-
-		return;
-	}
+	/*
+	 * Send a disconnect command to target when a disconnect event is
+	 * received with reason code other than 3 (DISCONNECT_CMD - disconnect
+	 * request from host) to make the firmware stop trying to connect even
+	 * after giving disconnect event. There will be one more disconnect
+	 * event for this disconnect command with reason code DISCONNECT_CMD
+	 * which will be notified to cfg80211.
+	 */
 
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

