Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60086 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaKPAj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 09/11] ath9k: Handle failure to send NoA
Date: Sun, 16 Nov 2014 06:11:08 +0530
Message-Id: <1416098470-14122-10-git-send-email-sujith@msujith.org> (sfid-20141116_014346_502825_F7D4AB90)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If for some reason a beacon with a new NoA is
not sent out, then reset the mgd_prepare_tx flag.
Not doing this will result in a situation where
a GO will send a new NoA when it shouldn't.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e86189f..ad9a12a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2503,10 +2503,17 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 		init_completion(&sc->go_beacon);
 
 		mutex_unlock(&sc->mutex);
+
 		if (wait_for_completion_timeout(&sc->go_beacon,
-						timeout) == 0)
+						timeout) == 0) {
 			ath_dbg(common, CHAN_CTX,
 				"Failed to send new NoA\n");
+
+			spin_lock_bh(&sc->chan_lock);
+			sc->sched.mgd_prepare_tx = false;
+			spin_unlock_bh(&sc->chan_lock);
+		}
+
 		mutex_lock(&sc->mutex);
 	}
 
-- 
2.1.3

