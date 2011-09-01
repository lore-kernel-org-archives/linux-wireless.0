Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2933 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/30] staging: brcm80211: removed static function
 declarations in antsel.c
Date: Thu, 1 Sep 2011 11:16:54 +0200
Message-ID: <1314868640-9425-5-git-send-email-rvossen@broadcom.com> (sfid-20110901_111818_341955_2D9AAB42)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/antsel.c |  214 +++++++++++++--------------
 1 files changed, 103 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 23e0453..9dfc2ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -49,15 +49,6 @@
 #define ANT_SELCFG_NUM_2x4	4
 #define ANT_SELCFG_DEF_2x4	0x02	/* default antenna configuration */
 
-/* static functions */
-static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
-				 struct brcms_antselcfg *antsel);
-static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id);
-static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg);
-static void brcms_c_antsel_init_cfg(struct antsel_info *asi,
-				struct brcms_antselcfg *antsel,
-				bool auto_sel);
-
 const u16 mimo_2x4_div_antselpat_tbl[] = {
 	0, 0, 0x9, 0xa,		/* ant0: 0 ant1: 2,3 */
 	0, 0, 0x5, 0x6,		/* ant0: 1 ant1: 2,3 */
@@ -82,6 +73,38 @@ const u8 mimo_2x3_div_antselid_tbl[16] = {
 	0, 0, 0, 0, 0, 0, 0, 0	/* pat to antselid */
 };
 
+/* boardlevel antenna selection: init antenna selection structure */
+static void
+brcms_c_antsel_init_cfg(struct antsel_info *asi, struct brcms_antselcfg *antsel,
+		    bool auto_sel)
+{
+	if (asi->antsel_type == ANTSEL_2x3) {
+		u8 antcfg_def = ANT_SELCFG_DEF_2x3 |
+		    ((asi->antsel_avail && auto_sel) ? ANT_SELCFG_AUTO : 0);
+		antsel->ant_config[ANT_SELCFG_TX_DEF] = antcfg_def;
+		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = antcfg_def;
+		antsel->ant_config[ANT_SELCFG_RX_DEF] = antcfg_def;
+		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = antcfg_def;
+		antsel->num_antcfg = ANT_SELCFG_NUM_2x3;
+
+	} else if (asi->antsel_type == ANTSEL_2x4) {
+
+		antsel->ant_config[ANT_SELCFG_TX_DEF] = ANT_SELCFG_DEF_2x4;
+		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = ANT_SELCFG_DEF_2x4;
+		antsel->ant_config[ANT_SELCFG_RX_DEF] = ANT_SELCFG_DEF_2x4;
+		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = ANT_SELCFG_DEF_2x4;
+		antsel->num_antcfg = ANT_SELCFG_NUM_2x4;
+
+	} else {		/* no antenna selection available */
+
+		antsel->ant_config[ANT_SELCFG_TX_DEF] = ANT_SELCFG_DEF_2x2;
+		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = ANT_SELCFG_DEF_2x2;
+		antsel->ant_config[ANT_SELCFG_RX_DEF] = ANT_SELCFG_DEF_2x2;
+		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = ANT_SELCFG_DEF_2x2;
+		antsel->num_antcfg = 0;
+	}
+}
+
 struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 {
 	struct antsel_info *asi;
@@ -150,6 +173,64 @@ void brcms_c_antsel_detach(struct antsel_info *asi)
 	kfree(asi);
 }
 
+/*
+ * boardlevel antenna selection:
+ *   convert ant_cfg to mimo_antsel (ucode interface)
+ */
+static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
+{
+	u8 idx = BRCMS_ANTIDX_11N(BRCMS_ANTSEL_11N(ant_cfg));
+	u16 mimo_antsel = 0;
+
+	if (asi->antsel_type == ANTSEL_2x4) {
+		/* 2x4 antenna diversity board, 4 cfgs: 0-2 0-3 1-2 1-3 */
+		mimo_antsel = (mimo_2x4_div_antselpat_tbl[idx] & 0xf);
+		return mimo_antsel;
+
+	} else if (asi->antsel_type == ANTSEL_2x3) {
+		/* 2x3 antenna selection, 3 cfgs: 0-1 0-2 2-1 */
+		mimo_antsel = (mimo_2x3_div_antselpat_tbl[idx] & 0xf);
+		return mimo_antsel;
+	}
+
+	return mimo_antsel;
+}
+
+/* boardlevel antenna selection: ucode interface control */
+static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
+				 struct brcms_antselcfg *antsel)
+{
+	struct brcms_c_info *wlc = asi->wlc;
+	u8 ant_cfg;
+	u16 mimo_antsel;
+
+	/* 1) Update TX antconfig for all frames that are not unicast data
+	 *    (aka default TX)
+	 */
+	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
+	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
+	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
+	/*
+	 * Update driver stats for currently selected
+	 * default tx/rx antenna config
+	 */
+	asi->antcfg_cur.ant_config[ANT_SELCFG_TX_DEF] = ant_cfg;
+
+	/* 2) Update RX antconfig for all frames that are not unicast data
+	 *    (aka default RX)
+	 */
+	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
+	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
+	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
+	/*
+	 * Update driver stats for currently selected
+	 * default tx/rx antenna config
+	 */
+	asi->antcfg_cur.ant_config[ANT_SELCFG_RX_DEF] = ant_cfg;
+
+	return 0;
+}
+
 void brcms_c_antsel_init(struct antsel_info *asi)
 {
 	if ((asi->antsel_type == ANTSEL_2x3) ||
@@ -157,36 +238,23 @@ void brcms_c_antsel_init(struct antsel_info *asi)
 		brcms_c_antsel_cfgupd(asi, &asi->antcfg_11n);
 }
 
-/* boardlevel antenna selection: init antenna selection structure */
-static void
-brcms_c_antsel_init_cfg(struct antsel_info *asi, struct brcms_antselcfg *antsel,
-		    bool auto_sel)
+/* boardlevel antenna selection: convert id to ant_cfg */
+static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id)
 {
-	if (asi->antsel_type == ANTSEL_2x3) {
-		u8 antcfg_def = ANT_SELCFG_DEF_2x3 |
-		    ((asi->antsel_avail && auto_sel) ? ANT_SELCFG_AUTO : 0);
-		antsel->ant_config[ANT_SELCFG_TX_DEF] = antcfg_def;
-		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = antcfg_def;
-		antsel->ant_config[ANT_SELCFG_RX_DEF] = antcfg_def;
-		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = antcfg_def;
-		antsel->num_antcfg = ANT_SELCFG_NUM_2x3;
-
-	} else if (asi->antsel_type == ANTSEL_2x4) {
-
-		antsel->ant_config[ANT_SELCFG_TX_DEF] = ANT_SELCFG_DEF_2x4;
-		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = ANT_SELCFG_DEF_2x4;
-		antsel->ant_config[ANT_SELCFG_RX_DEF] = ANT_SELCFG_DEF_2x4;
-		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = ANT_SELCFG_DEF_2x4;
-		antsel->num_antcfg = ANT_SELCFG_NUM_2x4;
+	u8 antcfg = ANT_SELCFG_DEF_2x2;
 
-	} else {		/* no antenna selection available */
+	if (asi->antsel_type == ANTSEL_2x4) {
+		/* 2x4 antenna diversity board, 4 cfgs: 0-2 0-3 1-2 1-3 */
+		antcfg = (((id & 0x2) << 3) | ((id & 0x1) + 2));
+		return antcfg;
 
-		antsel->ant_config[ANT_SELCFG_TX_DEF] = ANT_SELCFG_DEF_2x2;
-		antsel->ant_config[ANT_SELCFG_TX_UNICAST] = ANT_SELCFG_DEF_2x2;
-		antsel->ant_config[ANT_SELCFG_RX_DEF] = ANT_SELCFG_DEF_2x2;
-		antsel->ant_config[ANT_SELCFG_RX_UNICAST] = ANT_SELCFG_DEF_2x2;
-		antsel->num_antcfg = 0;
+	} else if (asi->antsel_type == ANTSEL_2x3) {
+		/* 2x3 antenna selection, 3 cfgs: 0-1 0-2 2-1 */
+		antcfg = (((id & 0x02) << 4) | ((id & 0x1) + 1));
+		return antcfg;
 	}
+
+	return antcfg;
 }
 
 void
@@ -240,79 +308,3 @@ u8 brcms_c_antsel_antsel2id(struct antsel_info *asi, u16 antsel)
 	return antselid;
 }
 
-/* boardlevel antenna selection: convert id to ant_cfg */
-static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id)
-{
-	u8 antcfg = ANT_SELCFG_DEF_2x2;
-
-	if (asi->antsel_type == ANTSEL_2x4) {
-		/* 2x4 antenna diversity board, 4 cfgs: 0-2 0-3 1-2 1-3 */
-		antcfg = (((id & 0x2) << 3) | ((id & 0x1) + 2));
-		return antcfg;
-
-	} else if (asi->antsel_type == ANTSEL_2x3) {
-		/* 2x3 antenna selection, 3 cfgs: 0-1 0-2 2-1 */
-		antcfg = (((id & 0x02) << 4) | ((id & 0x1) + 1));
-		return antcfg;
-	}
-
-	return antcfg;
-}
-
-/*
- * boardlevel antenna selection:
- *   convert ant_cfg to mimo_antsel (ucode interface)
- */
-static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
-{
-	u8 idx = BRCMS_ANTIDX_11N(BRCMS_ANTSEL_11N(ant_cfg));
-	u16 mimo_antsel = 0;
-
-	if (asi->antsel_type == ANTSEL_2x4) {
-		/* 2x4 antenna diversity board, 4 cfgs: 0-2 0-3 1-2 1-3 */
-		mimo_antsel = (mimo_2x4_div_antselpat_tbl[idx] & 0xf);
-		return mimo_antsel;
-
-	} else if (asi->antsel_type == ANTSEL_2x3) {
-		/* 2x3 antenna selection, 3 cfgs: 0-1 0-2 2-1 */
-		mimo_antsel = (mimo_2x3_div_antselpat_tbl[idx] & 0xf);
-		return mimo_antsel;
-	}
-
-	return mimo_antsel;
-}
-
-/* boardlevel antenna selection: ucode interface control */
-static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
-				 struct brcms_antselcfg *antsel)
-{
-	struct brcms_c_info *wlc = asi->wlc;
-	u8 ant_cfg;
-	u16 mimo_antsel;
-
-	/* 1) Update TX antconfig for all frames that are not unicast data
-	 *    (aka default TX)
-	 */
-	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
-	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
-	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
-	/*
-	 * Update driver stats for currently selected
-	 * default tx/rx antenna config
-	 */
-	asi->antcfg_cur.ant_config[ANT_SELCFG_TX_DEF] = ant_cfg;
-
-	/* 2) Update RX antconfig for all frames that are not unicast data
-	 *    (aka default RX)
-	 */
-	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
-	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
-	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
-	/*
-	 * Update driver stats for currently selected
-	 * default tx/rx antenna config
-	 */
-	asi->antcfg_cur.ant_config[ANT_SELCFG_RX_DEF] = ant_cfg;
-
-	return 0;
-}
-- 
1.7.4.1


