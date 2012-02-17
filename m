Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64091 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2BQDOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 22:14:51 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath9k: avoid useless cast from (struct ath_rateset *) to (u8
 *) and back
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Date: Thu, 16 Feb 2012 22:14:45 -0500
Message-ID: <20120217031444.3951.33896.stgit@ae> (sfid-20120217_041455_014262_41C91A18)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a427a16..b8c6c38 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -567,10 +567,8 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 
 static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 				  const struct ath_rate_table *rate_table,
-				  u8 *mcs_set, u32 capflag)
+				  struct ath_rateset *rateset, u32 capflag)
 {
-	struct ath_rateset *rateset = (struct ath_rateset *)mcs_set;
-
 	u8 i, j, hi = 0;
 
 	/* Use intersection of working rates and valid rates */
@@ -1212,7 +1210,7 @@ static void ath_rc_init(struct ath_softc *sc,
 {
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
+	struct ath_rateset *ht_mcs = &ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	/* Initial rate table size. Will change depending
