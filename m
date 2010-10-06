Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54195 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab0JFSGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:30 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 01/03] wl1271: 11n Support, Add Definitions
Date: Wed,  6 Oct 2010 20:08:09 +0200
Message-Id: <1286388491-28752-3-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two acx commands: ht_capabilities & ht_information, 11n sta capabilities macro.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   90 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    4 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   13 ++++
 4 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 779b130..777c937 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -427,7 +427,7 @@ struct wl1271 {
 	/* Our association ID */
 	u16 aid;
 
-	/* currently configured rate set */
+	/* currently configured rate set: bits0-15 BG, bits 16-23 MCS */
 	u32 sta_rate_set;
 	u32 basic_rate_set;
 	u32 basic_rate;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index ebb341d..5cf5a0d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -964,6 +964,96 @@ struct wl1271_acx_rssi_snr_avg_weights {
 	u8 snr_data;
 };
 
+/* 11n command to the FW */
+/*	Name:	ACX_PEER_HT_CAP
+*	Desc:	Configure HT capabilities - declare the capabilities of the peer
+*		we are connected to.
+* Type:	Configuration
+* Access:	Write Only
+* Length:
+*/
+struct wl1271_acx_ht_capabilities {
+	struct acx_header header;
+
+	/*
+	* bit 0 - Allow HT Operation
+	* bit 1 - Allow Greenfield format in TX
+	* bit 2 - Allow Short GI in TX
+	* bit 3 - Allow L-SIG TXOP Protection in TX
+	* bit 4 - Allow HT Control fields in TX.
+	*	Note, driver will still leave space for HT control in packets
+	*	regardless of the value of this field. FW will be responsible to
+	*	drop the HT field from any frame when this Bit is set to 0.
+	* 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
+	*	Exact policy setting for this feature is TBD.
+	*	Note, this bit can only be set to 1 if bit 3 is set to 1.
+	*/
+	__le32 ht_capabilites;
+
+	/*
+	* Indicates to which peer these capabilities are relevant.
+	* Note, currently this value will be set to FFFFFFFFFFFF to indicate it
+	* is relevant for all peers since we only support HT in infrastructure
+	* mode. Later on this field will be relevant to IBSS/DLS operation
+	*/
+	u8  mac_address[ETH_ALEN];
+
+	/*
+	* This the maximum a-mpdu length supported by the AP. The FW may not
+	* exceed this length when sending A-MPDUs
+	*/
+	u8  ampdu_max_length;
+
+	/*
+	* This is the minimal spacing required when sending A-MPDUs to the AP
+	*/
+	u8 ampdu_min_spacing;
+} __packed;
+
+/*  HT Capabilites Fw Bit Mask Mapping */
+#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION			BIT(0)
+#define	WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT	BIT(1)
+#define	WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS	BIT(2)
+#define	WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION		BIT(3)
+#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_CONTROL_FIELDS		BIT(4)
+#define	WL1271_ACX_FW_CAP_BIT_MASK_RD_INITIATION		BIT(5)
+
+
+/* Name:	ACX_HT_BSS_OPERATION
+ * Desc:	Configure HT capabilities - AP rules for behavior in the BSS.
+ * Type:	Configuration
+ * Access:	Write Only
+ * Length:
+ */
+struct wl1271_acx_ht_information {
+	struct acx_header header;
+
+	u8 rifs_mode;	/* Values: 0 - RIFS not allowed, 1 - RIFS allowed */
+
+	u8 ht_protection;	/* Values: 0 - 3 like in spec */
+
+	/*
+	* Values: 0 - GF protection not required, 1 - GF protection required
+	*/
+	u8 gf_protection;
+
+	/*
+	* Values: 0 - TX Burst limit not required, 1 - TX Burst Limit required
+	*/
+	u8 ht_tx_burst_limit;
+
+	/*
+	* Values: 0 - Dual CTS protection not required,
+	*	  1 Dual CTS Protection required
+	* Note: When this value is set to 1 FW will protect all TXOP with RTS
+	* frame and will not use CTS-to-self regardless of the value of the
+	* ACX_CTS_PROTECTION information element
+	*/
+	u8 dual_cts_protection;
+
+	u8 padding[3];
+} __packed;
+
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 60c50d1..732e9aa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -91,6 +91,10 @@ enum {
 	CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
 };
 
+#define HW_RX_HIGHEST_RATE	65
+#define HW_BG_RATES_MASK	0xffff
+#define HW_HT_RATES_OFFSET	16
+
 enum {
 	CONF_SG_DISABLE = 0,
 	CONF_SG_PROTECTIVE,
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cb18f22..bef2c24 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2122,6 +2122,19 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
 	0                              /* CONF_HW_RXTX_RATE_1    */
 };
 
+/* 11n sta capabilities */
+#define WL12xx_HT_CAP { \
+	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20, \
+	.ht_supported = true, \
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K, \
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, \
+	.mcs = { \
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, }, \
+		.rx_highest = cpu_to_le16(HW_RX_HIGHEST_RATE), \
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED, \
+		}, \
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.channels = wl1271_channels,
-- 
1.6.0.4

