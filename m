Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:38906 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751464AbeCUKc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 06:32:57 -0400
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath: Remove unnecessary ath_bcast_mac and use eth_broadcast_addr
Date: Wed, 21 Mar 2018 03:32:52 -0700
Message-Id: <3ed8112986ba6f538cb45df6ea67e0c027a3dc12.1521628278.git.joe@perches.com> (sfid-20180321_113317_867891_BA916569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the static array and use the generic routine to set the
Ethernet broadcast address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath.h                | 2 --
 drivers/net/wireless/ath/ath5k/attach.c       | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/ath/ath9k/init.c         | 2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f3f2784f6ebd..7a364eca46d6 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -33,8 +33,6 @@
  */
 #define	ATH_KEYMAX	        128     /* max key cache size we handle */
 
-static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-
 struct ath_ani {
 	bool caldone;
 	unsigned int longcal_timer;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 233054bd6b52..12d3a6c92ba4 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -327,7 +327,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 	ath5k_hw_set_lladdr(ah, zero_mac);
 
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
+	eth_broadcast_addr(common->curbssid);
 	ath5k_hw_set_bssid(ah);
 	ath5k_hw_set_opmode(ah, ah->opmode);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index e89e5ef2c2a4..bf36bb2821b4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -591,7 +591,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
-	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
+	eth_broadcast_addr(common->bssidmask);
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e479fae5aab9..748becee3ecf 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -427,7 +427,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	timer_setup(&common->ani.timer, ath_ani_calibrate, 0);
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
-	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
+	eth_broadcast_addr(common->bssidmask);
 	sc->beacon.slottime = 9;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
-- 
2.15.0
