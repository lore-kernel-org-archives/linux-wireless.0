Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967252AbeBNLPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 06:15:09 -0500
From: Timothy Redaelli <tredaelli@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH v2] ath9k: fix DFS detector synchronization
Date: Wed, 14 Feb 2018 12:14:14 +0100
Message-Id: <071245fb726f2842c9a30432b14633e5d665b1d4.1518605287.git.tredaelli@redhat.com> (sfid-20180214_121513_448026_6AC19344)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some userspace programs (e.g. hostapd) need to set the regulatory domain
before selecting the operating channel. Synchronize DFS detector regardless of
the value of ah->curchan, to avoid situations where wireless scan can't be done
on some 5GHz sub-bands, because dfs_region is constantly UNSET.

Acked-by: Felix Fietkau <nbd@nbd.name>
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
