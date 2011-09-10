Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51115 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab1IJJ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 05:56:56 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath6kl: Don't give disconnect command in disconnect event handler
Date: Sat, 10 Sep 2011 15:26:36 +0530
Message-ID: <1315648597-17999-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110910_115659_438776_0CD58B91)
In-Reply-To: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks bogus to give disconnect command from the disconnect
event handler.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 17bb8e2..0ad458b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -623,22 +623,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
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
-		ath6kl_wmi_disconnect_cmd(ar->wmi);
-		return;
-	}
-
-	if (reason != DISCONNECT_CMD)
-		return;
-
 	clear_bit(CONNECT_PEND, &ar->flag);
 
 	if (ar->sme_state == SME_CONNECTING) {
-- 
1.7.0.4

