Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2INHqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 03:46:43 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20562.57519.298444.874991@gargle.gargle.HOWL> (sfid-20120914_094647_283002_DF22EF01)
Date: Fri, 14 Sep 2012 13:15:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 7/8] ath9k: Add a module parameter to enable diversity for
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h           |  1 +
 drivers/net/wireless/ath/ath9k/antenna.c |  4 ++++
 drivers/net/wireless/ath/ath9k/init.c    | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 6169fbd..4521342 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -159,6 +159,7 @@ struct ath_common {
 
 	bool btcoex_enabled;
 	bool disable_ani;
+	bool antenna_diversity;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 8eb274f..664844c 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -776,6 +776,7 @@ div_comb_done:
 void ath_ant_comb_update(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_hw_antcomb_conf div_ant_conf;
 	u8 lna_conf;
 
@@ -790,4 +791,7 @@ void ath_ant_comb_update(struct ath_softc *sc)
 	div_ant_conf.alt_lna_conf = lna_conf;
 
 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
+
+	if (common->antenna_diversity)
+		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f3ce5ca..ce20831 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -46,6 +46,10 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
+static int ath9k_enable_diversity;
+module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
+MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -546,6 +550,14 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	common->disable_ani = false;
+
+	/*
+	 * Enable Antenna diversity only when BTCOEX is disabled
+	 * and the user manually requests the feature.
+	 */
+	if (!common->btcoex_enabled && ath9k_enable_diversity)
+		common->antenna_diversity = 1;
+
 	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->sc_serial_rw);
-- 
1.7.12

