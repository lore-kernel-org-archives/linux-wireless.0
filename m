Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751066AbeBHLqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 06:46:53 -0500
From: Timothy Redaelli <tredaelli@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] ath9k: fix DFS detector synchronization
Date: Thu,  8 Feb 2018 12:46:47 +0100
Message-Id: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com> (sfid-20180208_124657_564101_67AB3A68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code currently syncronize the DFS region only if curchan != 0, but hostapd
launch DFS before the channel is set and so set_dfs_domain is never executed.

CC: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e479fae5aab9..b71b16715f6a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -257,6 +257,11 @@ static void ath9k_reg_notifier(struct wiphy *wiphy,
 
 	ath_reg_notifier_apply(wiphy, request, reg);
 
+	/* synchronize DFS detector if regulatory domain changed */
+	if (sc->dfs_detector != NULL)
+		sc->dfs_detector->set_dfs_domain(sc->dfs_detector,
+						 request->dfs_region);
+
 	/* Set tx power */
 	if (!ah->curchan)
 		return;
@@ -267,10 +272,6 @@ static void ath9k_reg_notifier(struct wiphy *wiphy,
 	ath9k_cmn_update_txpow(ah, sc->cur_chan->cur_txpower,
 			       sc->cur_chan->txpower,
 			       &sc->cur_chan->cur_txpower);
-	/* synchronize DFS detector if regulatory domain changed */
-	if (sc->dfs_detector != NULL)
-		sc->dfs_detector->set_dfs_domain(sc->dfs_detector,
-						 request->dfs_region);
 	ath9k_ps_restore(sc);
 }
 
-- 
2.14.3
