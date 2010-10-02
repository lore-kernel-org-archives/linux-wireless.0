Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0JBJfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:23 -0400
Received: by wwj40 with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/20] rt2x00: Implement HT protection for rt2800
Date: Sat, 2 Oct 2010 11:28:34 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021127.36277.IvDoorn@gmail.com> <201010021128.03722.IvDoorn@gmail.com>
In-Reply-To: <201010021128.03722.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021128.35449.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Update the HT operation mode when mac80211 sends it to us and set
the different HT protection modes and rates accordingly. For now
only use CTS-to-self with OFDM 24M or CCK 11M when protection is
required.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c    |   99 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
 drivers/net/wireless/rt2x00/rt2x00config.c |    3 +
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2 +-
 4 files changed, 104 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 19534f2..4ecacea 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1169,6 +1169,102 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_intf);
 
+static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
+				    struct rt2x00lib_erp *erp)
+{
+	bool any_sta_nongf = !!(erp->ht_opmode &
+				IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+	u8 protection = erp->ht_opmode & IEEE80211_HT_OP_MODE_PROTECTION;
+	u8 mm20_mode, mm40_mode, gf20_mode, gf40_mode;
+	u16 mm20_rate, mm40_rate, gf20_rate, gf40_rate;
+	u32 reg;
+
+	/* default protection rate for HT20: OFDM 24M */
+	mm20_rate = gf20_rate = 0x4004;
+
+	/* default protection rate for HT40: duplicate OFDM 24M */
+	mm40_rate = gf40_rate = 0x4084;
+
+	switch (protection) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
+		/*
+		 * All STAs in this BSS are HT20/40 but there might be
+		 * STAs not supporting greenfield mode.
+		 * => Disable protection for HT transmissions.
+		 */
+		mm20_mode = mm40_mode = gf20_mode = gf40_mode = 0;
+
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		/*
+		 * All STAs in this BSS are HT20 or HT20/40 but there
+		 * might be STAs not supporting greenfield mode.
+		 * => Protect all HT40 transmissions.
+		 */
+		mm20_mode = gf20_mode = 0;
+		mm40_mode = gf40_mode = 2;
+
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+		/*
+		 * Nonmember protection:
+		 * According to 802.11n we _should_ protect all
+		 * HT transmissions (but we don't have to).
+		 *
+		 * But if cts_protection is enabled we _shall_ protect
+		 * all HT transmissions using a CCK rate.
+		 *
+		 * And if any station is non GF we _shall_ protect
+		 * GF transmissions.
+		 *
+		 * We decide to protect everything
+		 * -> fall through to mixed mode.
+		 */
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		/*
+		 * Legacy STAs are present
+		 * => Protect all HT transmissions.
+		 */
+		mm20_mode = mm40_mode = gf20_mode = gf40_mode = 2;
+
+		/*
+		 * If erp protection is needed we have to protect HT
+		 * transmissions with CCK 11M long preamble.
+		 */
+		if (erp->cts_protection) {
+			/* don't duplicate RTS/CTS in CCK mode */
+			mm20_rate = mm40_rate = 0x0003;
+			gf20_rate = gf40_rate = 0x0003;
+		}
+		break;
+	};
+
+	/* check for STAs not supporting greenfield mode */
+	if (any_sta_nongf)
+		gf20_mode = gf40_mode = 2;
+
+	/* Update HT protection config */
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, mm20_rate);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, mm20_mode);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, mm40_rate);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, mm40_mode);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, gf20_rate);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, gf20_mode);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, gf40_rate);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, gf40_mode);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+}
+
 void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
 		       u32 changed)
 {
@@ -1213,6 +1309,9 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
 				   erp->beacon_int * 16);
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 	}
+
+	if (changed & BSS_CHANGED_HT)
+		rt2800_config_ht_opmode(rt2x00dev, erp);
 }
 EXPORT_SYMBOL_GPL(rt2800_config_erp);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index bab10ad..75ac662 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -458,6 +458,7 @@ struct rt2x00lib_erp {
 	short eifs;
 
 	u16 beacon_int;
+	u16 ht_opmode;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 4c7ff76..54ffb5a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -103,6 +103,9 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
 
+	if (changed & BSS_CHANGED_HT)
+		erp.ht_opmode = bss_conf->ht_operation_mode;
+
 	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp, changed);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7862a84..c3c206a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -671,7 +671,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 */
 	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE |
 		       BSS_CHANGED_ERP_SLOT | BSS_CHANGED_BASIC_RATES |
-		       BSS_CHANGED_BEACON_INT))
+		       BSS_CHANGED_BEACON_INT | BSS_CHANGED_HT))
 		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf, changes);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
-- 
1.7.2.3

