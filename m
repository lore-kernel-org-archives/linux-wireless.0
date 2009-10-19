Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:52443 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZJSJVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 05:21:18 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: move association & scan-related away
Date: Mon, 19 Oct 2009 11:20:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910191120.54327.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another cfg80211-preparation patch: removes some code/definitions from
main.c and dev.h and put's it into assoc.c/.h, scan.c/.h.

No functional change.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -6,75 +6,10 @@
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
 
-#include <linux/netdevice.h>
-#include <linux/wireless.h>
-#include <linux/ethtool.h>
-#include <linux/debugfs.h>
+#include "scan.h"
+#include "assoc.h"
 
-#include "defs.h"
-#include "host.h"
 
-extern const struct ethtool_ops lbs_ethtool_ops;
-
-#define	MAX_BSSID_PER_CHANNEL		16
-
-#define NR_TX_QUEUE			3
-
-/* For the extended Scan */
-#define MAX_EXTENDED_SCAN_BSSID_LIST    MAX_BSSID_PER_CHANNEL * \
-						MRVDRV_MAX_CHANNEL_SIZE + 1
-
-#define	MAX_REGION_CHANNEL_NUM	2
-
-/** Chan-freq-TxPower mapping table*/
-struct chan_freq_power {
-	/** channel Number		*/
-	u16 channel;
-	/** frequency of this channel	*/
-	u32 freq;
-	/** Max allowed Tx power level	*/
-	u16 maxtxpower;
-	/** TRUE:channel unsupported;  FLASE:supported*/
-	u8 unsupported;
-};
-
-/** region-band mapping table*/
-struct region_channel {
-	/** TRUE if this entry is valid		     */
-	u8 valid;
-	/** region code for US, Japan ...	     */
-	u8 region;
-	/** band B/G/A, used for BAND_CONFIG cmd	     */
-	u8 band;
-	/** Actual No. of elements in the array below */
-	u8 nrcfp;
-	/** chan-freq-txpower mapping table*/
-	struct chan_freq_power *CFP;
-};
-
-struct lbs_802_11_security {
-	u8 WPAenabled;
-	u8 WPA2enabled;
-	u8 wep_enabled;
-	u8 auth_mode;
-	u32 key_mgmt;
-};
-
-/** Current Basic Service Set State Structure */
-struct current_bss_params {
-	/** bssid */
-	u8 bssid[ETH_ALEN];
-	/** ssid */
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-
-	/** band */
-	u8 band;
-	/** channel */
-	u8 channel;
-	/** zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-};
 
 /** sleep_params */
 struct sleep_params {
@@ -295,12 +230,6 @@
 	struct enc_key wpa_mcast_key;
 	struct enc_key wpa_unicast_key;
 
-/*
- * In theory, the IE is limited to the IE length, 255,
- * but in practice 64 bytes are enough.
- */
-#define MAX_WPA_IE_LEN 64
-
 	/** WPA Information Elements*/
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
@@ -334,84 +263,4 @@
 
 extern struct cmd_confirm_sleep confirm_sleep;
 
-/**
- *  @brief Structure used to store information for each beacon/probe response
- */
-struct bss_descriptor {
-	u8 bssid[ETH_ALEN];
-
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-
-	u16 capability;
-	u32 rssi;
-	u32 channel;
-	u16 beaconperiod;
-	__le16 atimwindow;
-
-	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
-	u8 mode;
-
-	/* zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-
-	unsigned long last_scanned;
-
-	union ieee_phy_param_set phy;
-	union ieee_ss_param_set ss;
-
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	size_t wpa_ie_len;
-	u8 rsn_ie[MAX_WPA_IE_LEN];
-	size_t rsn_ie_len;
-
-	u8 mesh;
-
-	struct list_head list;
-};
-
-/** Association request
- *
- * Encapsulates all the options that describe a specific assocation request
- * or configuration of the wireless card's radio, mode, and security settings.
- */
-struct assoc_request {
-#define ASSOC_FLAG_SSID			1
-#define ASSOC_FLAG_CHANNEL		2
-#define ASSOC_FLAG_BAND			3
-#define ASSOC_FLAG_MODE			4
-#define ASSOC_FLAG_BSSID		5
-#define ASSOC_FLAG_WEP_KEYS		6
-#define ASSOC_FLAG_WEP_TX_KEYIDX	7
-#define ASSOC_FLAG_WPA_MCAST_KEY	8
-#define ASSOC_FLAG_WPA_UCAST_KEY	9
-#define ASSOC_FLAG_SECINFO		10
-#define ASSOC_FLAG_WPA_IE		11
-	unsigned long flags;
-
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
-	u8 channel;
-	u8 band;
-	u8 mode;
-	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
-
-	/** WEP keys */
-	struct enc_key wep_keys[4];
-	u16 wep_tx_keyidx;
-
-	/** WPA keys */
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
-
-	struct lbs_802_11_security secinfo;
-
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-
-	/* BSS to associate with for infrastructure of Ad-Hoc join */
-	struct bss_descriptor bss;
-};
-
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -23,6 +23,13 @@
  */
 #define CAPINFO_MASK	(~(0xda00))
 
+/**
+ * 802.11b/g supported bitrates (in 500Kb/s units)
+ */
+u8 lbs_bg_rates[MAX_RATES] =
+    { 0x02, 0x04, 0x0b, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c,
+0x00, 0x00 };
+
 
 /**
  *  @brief This function finds common rates between rates and card rates.
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -3,7 +3,127 @@
 #ifndef _LBS_ASSOC_H_
 #define _LBS_ASSOC_H_
 
-#include "dev.h"
+
+#include "defs.h"
+#include "host.h"
+
+
+struct lbs_private;
+
+/*
+ * In theory, the IE is limited to the IE length, 255,
+ * but in practice 64 bytes are enough.
+ */
+#define MAX_WPA_IE_LEN 64
+
+
+
+struct lbs_802_11_security {
+	u8 WPAenabled;
+	u8 WPA2enabled;
+	u8 wep_enabled;
+	u8 auth_mode;
+	u32 key_mgmt;
+};
+
+/** Current Basic Service Set State Structure */
+struct current_bss_params {
+	/** bssid */
+	u8 bssid[ETH_ALEN];
+	/** ssid */
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 ssid_len;
+
+	/** band */
+	u8 band;
+	/** channel */
+	u8 channel;
+	/** zero-terminated array of supported data rates */
+	u8 rates[MAX_RATES + 1];
+};
+
+/**
+ *  @brief Structure used to store information for each beacon/probe response
+ */
+struct bss_descriptor {
+	u8 bssid[ETH_ALEN];
+
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 ssid_len;
+
+	u16 capability;
+	u32 rssi;
+	u32 channel;
+	u16 beaconperiod;
+	__le16 atimwindow;
+
+	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
+	u8 mode;
+
+	/* zero-terminated array of supported data rates */
+	u8 rates[MAX_RATES + 1];
+
+	unsigned long last_scanned;
+
+	union ieee_phy_param_set phy;
+	union ieee_ss_param_set ss;
+
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	size_t wpa_ie_len;
+	u8 rsn_ie[MAX_WPA_IE_LEN];
+	size_t rsn_ie_len;
+
+	u8 mesh;
+
+	struct list_head list;
+};
+
+/** Association request
+ *
+ * Encapsulates all the options that describe a specific assocation request
+ * or configuration of the wireless card's radio, mode, and security settings.
+ */
+struct assoc_request {
+#define ASSOC_FLAG_SSID			1
+#define ASSOC_FLAG_CHANNEL		2
+#define ASSOC_FLAG_BAND			3
+#define ASSOC_FLAG_MODE			4
+#define ASSOC_FLAG_BSSID		5
+#define ASSOC_FLAG_WEP_KEYS		6
+#define ASSOC_FLAG_WEP_TX_KEYIDX	7
+#define ASSOC_FLAG_WPA_MCAST_KEY	8
+#define ASSOC_FLAG_WPA_UCAST_KEY	9
+#define ASSOC_FLAG_SECINFO		10
+#define ASSOC_FLAG_WPA_IE		11
+	unsigned long flags;
+
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 ssid_len;
+	u8 channel;
+	u8 band;
+	u8 mode;
+	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
+
+	/** WEP keys */
+	struct enc_key wep_keys[4];
+	u16 wep_tx_keyidx;
+
+	/** WPA keys */
+	struct enc_key wpa_mcast_key;
+	struct enc_key wpa_unicast_key;
+
+	struct lbs_802_11_security secinfo;
+
+	/** WPA Information Elements*/
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	u8 wpa_ie_len;
+
+	/* BSS to associate with for infrastructure of Ad-Hoc join */
+	struct bss_descriptor bss;
+};
+
+
+extern u8 lbs_bg_rates[MAX_RATES];
 
 void lbs_association_worker(struct work_struct *work);
 struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -13,6 +13,7 @@
 #include "dev.h"
 #include "assoc.h"
 #include "wext.h"
+#include "scan.h"
 #include "cmd.h"
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -10,6 +10,9 @@
 
 #include "defs.h"
 
+
+extern const struct ethtool_ops lbs_ethtool_ops;
+
 /** Function Prototype Declaration */
 struct lbs_private;
 struct sk_buff;
@@ -33,7 +36,6 @@
 /** The proc fs interface */
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *dev);
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
@@ -49,8 +51,6 @@
 void lbs_persist_config_remove(struct net_device *net);
 
 /* main.c */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region,
-	int *cfp_no);
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 void lbs_remove_card(struct lbs_private *priv);
 int lbs_start_card(struct lbs_private *priv);
--- linux-wl.orig/drivers/net/wireless/libertas/defs.h
+++ linux-wl/drivers/net/wireless/libertas/defs.h
@@ -322,7 +322,6 @@
 extern const char lbs_driver_version[];
 extern u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE];
 
-extern u8 lbs_bg_rates[MAX_RATES];
 
 /** ENUM definition*/
 /** SNRNF_TYPE */
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -45,119 +45,6 @@
 struct cmd_confirm_sleep confirm_sleep;
 
 
-#define LBS_TX_PWR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_US_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_JP_DEFAULT		16	/*50mW */
-#define LBS_TX_PWR_FR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_EMEA_DEFAULT	20	/*100mW */
-
-/* Format { channel, frequency (MHz), maxtxpower } */
-/* band: 'B/G', region: USA FCC/Canada IC */
-static struct chan_freq_power channel_freq_power_US_BG[] = {
-	{1, 2412, LBS_TX_PWR_US_DEFAULT},
-	{2, 2417, LBS_TX_PWR_US_DEFAULT},
-	{3, 2422, LBS_TX_PWR_US_DEFAULT},
-	{4, 2427, LBS_TX_PWR_US_DEFAULT},
-	{5, 2432, LBS_TX_PWR_US_DEFAULT},
-	{6, 2437, LBS_TX_PWR_US_DEFAULT},
-	{7, 2442, LBS_TX_PWR_US_DEFAULT},
-	{8, 2447, LBS_TX_PWR_US_DEFAULT},
-	{9, 2452, LBS_TX_PWR_US_DEFAULT},
-	{10, 2457, LBS_TX_PWR_US_DEFAULT},
-	{11, 2462, LBS_TX_PWR_US_DEFAULT}
-};
-
-/* band: 'B/G', region: Europe ETSI */
-static struct chan_freq_power channel_freq_power_EU_BG[] = {
-	{1, 2412, LBS_TX_PWR_EMEA_DEFAULT},
-	{2, 2417, LBS_TX_PWR_EMEA_DEFAULT},
-	{3, 2422, LBS_TX_PWR_EMEA_DEFAULT},
-	{4, 2427, LBS_TX_PWR_EMEA_DEFAULT},
-	{5, 2432, LBS_TX_PWR_EMEA_DEFAULT},
-	{6, 2437, LBS_TX_PWR_EMEA_DEFAULT},
-	{7, 2442, LBS_TX_PWR_EMEA_DEFAULT},
-	{8, 2447, LBS_TX_PWR_EMEA_DEFAULT},
-	{9, 2452, LBS_TX_PWR_EMEA_DEFAULT},
-	{10, 2457, LBS_TX_PWR_EMEA_DEFAULT},
-	{11, 2462, LBS_TX_PWR_EMEA_DEFAULT},
-	{12, 2467, LBS_TX_PWR_EMEA_DEFAULT},
-	{13, 2472, LBS_TX_PWR_EMEA_DEFAULT}
-};
-
-/* band: 'B/G', region: Spain */
-static struct chan_freq_power channel_freq_power_SPN_BG[] = {
-	{10, 2457, LBS_TX_PWR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_DEFAULT}
-};
-
-/* band: 'B/G', region: France */
-static struct chan_freq_power channel_freq_power_FR_BG[] = {
-	{10, 2457, LBS_TX_PWR_FR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_FR_DEFAULT},
-	{12, 2467, LBS_TX_PWR_FR_DEFAULT},
-	{13, 2472, LBS_TX_PWR_FR_DEFAULT}
-};
-
-/* band: 'B/G', region: Japan */
-static struct chan_freq_power channel_freq_power_JPN_BG[] = {
-	{1, 2412, LBS_TX_PWR_JP_DEFAULT},
-	{2, 2417, LBS_TX_PWR_JP_DEFAULT},
-	{3, 2422, LBS_TX_PWR_JP_DEFAULT},
-	{4, 2427, LBS_TX_PWR_JP_DEFAULT},
-	{5, 2432, LBS_TX_PWR_JP_DEFAULT},
-	{6, 2437, LBS_TX_PWR_JP_DEFAULT},
-	{7, 2442, LBS_TX_PWR_JP_DEFAULT},
-	{8, 2447, LBS_TX_PWR_JP_DEFAULT},
-	{9, 2452, LBS_TX_PWR_JP_DEFAULT},
-	{10, 2457, LBS_TX_PWR_JP_DEFAULT},
-	{11, 2462, LBS_TX_PWR_JP_DEFAULT},
-	{12, 2467, LBS_TX_PWR_JP_DEFAULT},
-	{13, 2472, LBS_TX_PWR_JP_DEFAULT},
-	{14, 2484, LBS_TX_PWR_JP_DEFAULT}
-};
-
-/**
- * the structure for channel, frequency and power
- */
-struct region_cfp_table {
-	u8 region;
-	struct chan_freq_power *cfp_BG;
-	int cfp_no_BG;
-};
-
-/**
- * the structure for the mapping between region and CFP
- */
-static struct region_cfp_table region_cfp_table[] = {
-	{0x10,			/*US FCC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x20,			/*CANADA IC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x30, /*EU*/ channel_freq_power_EU_BG,
-	 ARRAY_SIZE(channel_freq_power_EU_BG),
-	 }
-	,
-	{0x31, /*SPAIN*/ channel_freq_power_SPN_BG,
-	 ARRAY_SIZE(channel_freq_power_SPN_BG),
-	 }
-	,
-	{0x32, /*FRANCE*/ channel_freq_power_FR_BG,
-	 ARRAY_SIZE(channel_freq_power_FR_BG),
-	 }
-	,
-	{0x40, /*JAPAN*/ channel_freq_power_JPN_BG,
-	 ARRAY_SIZE(channel_freq_power_JPN_BG),
-	 }
-	,
-/*Add new region here */
-};
-
 /**
  * the table to keep region code
  */
@@ -165,13 +52,6 @@
     { 0x10, 0x20, 0x30, 0x31, 0x32, 0x40 };
 
 /**
- * 802.11b/g supported bitrates (in 500Kb/s units)
- */
-u8 lbs_bg_rates[MAX_RATES] =
-    { 0x02, 0x04, 0x0b, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c,
-0x00, 0x00 };
-
-/**
  * FW rate table.  FW refers to rates by their index in this table, not by the
  * rate value itself.  Values of 0x00 are
  * reserved positions.
@@ -1617,68 +1497,6 @@
 	lbs_deb_leave(LBS_DEB_MESH);
 }
 
-/**
- *  @brief This function finds the CFP in
- *  region_cfp_table based on region and band parameter.
- *
- *  @param region  The region code
- *  @param band	   The band
- *  @param cfp_no  A pointer to CFP number
- *  @return 	   A pointer to CFP
- */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region, int *cfp_no)
-{
-	int i, end;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	end = ARRAY_SIZE(region_cfp_table);
-
-	for (i = 0; i < end ; i++) {
-		lbs_deb_main("region_cfp_table[i].region=%d\n",
-			region_cfp_table[i].region);
-		if (region_cfp_table[i].region == region) {
-			*cfp_no = region_cfp_table[i].cfp_no_BG;
-			lbs_deb_leave(LBS_DEB_MAIN);
-			return region_cfp_table[i].cfp_BG;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret NULL");
-	return NULL;
-}
-
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
-{
-	int ret = 0;
-	int i = 0;
-
-	struct chan_freq_power *cfp;
-	int cfp_no;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	memset(priv->region_channel, 0, sizeof(priv->region_channel));
-
-	cfp = lbs_get_region_cfp_table(region, &cfp_no);
-	if (cfp != NULL) {
-		priv->region_channel[i].nrcfp = cfp_no;
-		priv->region_channel[i].CFP = cfp;
-	} else {
-		lbs_deb_main("wrong region code %#x in band B/G\n",
-		       region);
-		ret = -1;
-		goto out;
-	}
-	priv->region_channel[i].valid = 1;
-	priv->region_channel[i].region = region;
-	priv->region_channel[i].band = band;
-	i++;
-out:
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-	return ret;
-}
-
 void lbs_queue_event(struct lbs_private *priv, u32 event)
 {
 	unsigned long flags;
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -15,6 +15,7 @@
 #include "decl.h"
 #include "dev.h"
 #include "scan.h"
+#include "assoc.h"
 #include "cmd.h"
 
 //! Approximate amount of data needed to pass a scan result back to iwlist
@@ -121,6 +122,189 @@
 
 
 
+/*********************************************************************/
+/*                                                                   */
+/* Region channel support                                            */
+/*                                                                   */
+/*********************************************************************/
+
+#define LBS_TX_PWR_DEFAULT		20	/*100mW */
+#define LBS_TX_PWR_US_DEFAULT		20	/*100mW */
+#define LBS_TX_PWR_JP_DEFAULT		16	/*50mW */
+#define LBS_TX_PWR_FR_DEFAULT		20	/*100mW */
+#define LBS_TX_PWR_EMEA_DEFAULT	20	/*100mW */
+
+/* Format { channel, frequency (MHz), maxtxpower } */
+/* band: 'B/G', region: USA FCC/Canada IC */
+static struct chan_freq_power channel_freq_power_US_BG[] = {
+	{1, 2412, LBS_TX_PWR_US_DEFAULT},
+	{2, 2417, LBS_TX_PWR_US_DEFAULT},
+	{3, 2422, LBS_TX_PWR_US_DEFAULT},
+	{4, 2427, LBS_TX_PWR_US_DEFAULT},
+	{5, 2432, LBS_TX_PWR_US_DEFAULT},
+	{6, 2437, LBS_TX_PWR_US_DEFAULT},
+	{7, 2442, LBS_TX_PWR_US_DEFAULT},
+	{8, 2447, LBS_TX_PWR_US_DEFAULT},
+	{9, 2452, LBS_TX_PWR_US_DEFAULT},
+	{10, 2457, LBS_TX_PWR_US_DEFAULT},
+	{11, 2462, LBS_TX_PWR_US_DEFAULT}
+};
+
+/* band: 'B/G', region: Europe ETSI */
+static struct chan_freq_power channel_freq_power_EU_BG[] = {
+	{1, 2412, LBS_TX_PWR_EMEA_DEFAULT},
+	{2, 2417, LBS_TX_PWR_EMEA_DEFAULT},
+	{3, 2422, LBS_TX_PWR_EMEA_DEFAULT},
+	{4, 2427, LBS_TX_PWR_EMEA_DEFAULT},
+	{5, 2432, LBS_TX_PWR_EMEA_DEFAULT},
+	{6, 2437, LBS_TX_PWR_EMEA_DEFAULT},
+	{7, 2442, LBS_TX_PWR_EMEA_DEFAULT},
+	{8, 2447, LBS_TX_PWR_EMEA_DEFAULT},
+	{9, 2452, LBS_TX_PWR_EMEA_DEFAULT},
+	{10, 2457, LBS_TX_PWR_EMEA_DEFAULT},
+	{11, 2462, LBS_TX_PWR_EMEA_DEFAULT},
+	{12, 2467, LBS_TX_PWR_EMEA_DEFAULT},
+	{13, 2472, LBS_TX_PWR_EMEA_DEFAULT}
+};
+
+/* band: 'B/G', region: Spain */
+static struct chan_freq_power channel_freq_power_SPN_BG[] = {
+	{10, 2457, LBS_TX_PWR_DEFAULT},
+	{11, 2462, LBS_TX_PWR_DEFAULT}
+};
+
+/* band: 'B/G', region: France */
+static struct chan_freq_power channel_freq_power_FR_BG[] = {
+	{10, 2457, LBS_TX_PWR_FR_DEFAULT},
+	{11, 2462, LBS_TX_PWR_FR_DEFAULT},
+	{12, 2467, LBS_TX_PWR_FR_DEFAULT},
+	{13, 2472, LBS_TX_PWR_FR_DEFAULT}
+};
+
+/* band: 'B/G', region: Japan */
+static struct chan_freq_power channel_freq_power_JPN_BG[] = {
+	{1, 2412, LBS_TX_PWR_JP_DEFAULT},
+	{2, 2417, LBS_TX_PWR_JP_DEFAULT},
+	{3, 2422, LBS_TX_PWR_JP_DEFAULT},
+	{4, 2427, LBS_TX_PWR_JP_DEFAULT},
+	{5, 2432, LBS_TX_PWR_JP_DEFAULT},
+	{6, 2437, LBS_TX_PWR_JP_DEFAULT},
+	{7, 2442, LBS_TX_PWR_JP_DEFAULT},
+	{8, 2447, LBS_TX_PWR_JP_DEFAULT},
+	{9, 2452, LBS_TX_PWR_JP_DEFAULT},
+	{10, 2457, LBS_TX_PWR_JP_DEFAULT},
+	{11, 2462, LBS_TX_PWR_JP_DEFAULT},
+	{12, 2467, LBS_TX_PWR_JP_DEFAULT},
+	{13, 2472, LBS_TX_PWR_JP_DEFAULT},
+	{14, 2484, LBS_TX_PWR_JP_DEFAULT}
+};
+
+/**
+ * the structure for channel, frequency and power
+ */
+struct region_cfp_table {
+	u8 region;
+	struct chan_freq_power *cfp_BG;
+	int cfp_no_BG;
+};
+
+/**
+ * the structure for the mapping between region and CFP
+ */
+static struct region_cfp_table region_cfp_table[] = {
+	{0x10,			/*US FCC */
+	 channel_freq_power_US_BG,
+	 ARRAY_SIZE(channel_freq_power_US_BG),
+	 }
+	,
+	{0x20,			/*CANADA IC */
+	 channel_freq_power_US_BG,
+	 ARRAY_SIZE(channel_freq_power_US_BG),
+	 }
+	,
+	{0x30, /*EU*/ channel_freq_power_EU_BG,
+	 ARRAY_SIZE(channel_freq_power_EU_BG),
+	 }
+	,
+	{0x31, /*SPAIN*/ channel_freq_power_SPN_BG,
+	 ARRAY_SIZE(channel_freq_power_SPN_BG),
+	 }
+	,
+	{0x32, /*FRANCE*/ channel_freq_power_FR_BG,
+	 ARRAY_SIZE(channel_freq_power_FR_BG),
+	 }
+	,
+	{0x40, /*JAPAN*/ channel_freq_power_JPN_BG,
+	 ARRAY_SIZE(channel_freq_power_JPN_BG),
+	 }
+	,
+/*Add new region here */
+};
+
+/**
+ *  @brief This function finds the CFP in
+ *  region_cfp_table based on region and band parameter.
+ *
+ *  @param region  The region code
+ *  @param band	   The band
+ *  @param cfp_no  A pointer to CFP number
+ *  @return 	   A pointer to CFP
+ */
+static struct chan_freq_power *lbs_get_region_cfp_table(u8 region, int *cfp_no)
+{
+	int i, end;
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+
+	end = ARRAY_SIZE(region_cfp_table);
+
+	for (i = 0; i < end ; i++) {
+		lbs_deb_main("region_cfp_table[i].region=%d\n",
+			region_cfp_table[i].region);
+		if (region_cfp_table[i].region == region) {
+			*cfp_no = region_cfp_table[i].cfp_no_BG;
+			lbs_deb_leave(LBS_DEB_MAIN);
+			return region_cfp_table[i].cfp_BG;
+		}
+	}
+
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret NULL");
+	return NULL;
+}
+
+int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
+{
+	int ret = 0;
+	int i = 0;
+
+	struct chan_freq_power *cfp;
+	int cfp_no;
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+
+	memset(priv->region_channel, 0, sizeof(priv->region_channel));
+
+	cfp = lbs_get_region_cfp_table(region, &cfp_no);
+	if (cfp != NULL) {
+		priv->region_channel[i].nrcfp = cfp_no;
+		priv->region_channel[i].CFP = cfp;
+	} else {
+		lbs_deb_main("wrong region code %#x in band B/G\n",
+		       region);
+		ret = -1;
+		goto out;
+	}
+	priv->region_channel[i].valid = 1;
+	priv->region_channel[i].region = region;
+	priv->region_channel[i].band = band;
+	i++;
+out:
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
+	return ret;
+}
+
+
+
 
 /*********************************************************************/
 /*                                                                   */
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h
+++ linux-wl/drivers/net/wireless/libertas/scan.h
@@ -9,8 +9,36 @@
 
 #include <net/iw_handler.h>
 
+struct lbs_private;
+
 #define MAX_NETWORK_COUNT 128
 
+/** Chan-freq-TxPower mapping table*/
+struct chan_freq_power {
+	/** channel Number		*/
+	u16 channel;
+	/** frequency of this channel	*/
+	u32 freq;
+	/** Max allowed Tx power level	*/
+	u16 maxtxpower;
+	/** TRUE:channel unsupported;  FLASE:supported*/
+	u8 unsupported;
+};
+
+/** region-band mapping table*/
+struct region_channel {
+	/** TRUE if this entry is valid		     */
+	u8 valid;
+	/** region code for US, Japan ...	     */
+	u8 region;
+	/** band B/G/A, used for BAND_CONFIG cmd	     */
+	u8 band;
+	/** Actual No. of elements in the array below */
+	u8 nrcfp;
+	/** chan-freq-txpower mapping table*/
+	struct chan_freq_power *CFP;
+};
+
 /**
  *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
  */
@@ -18,6 +46,8 @@
 
 int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
 
+int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
+
 int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
 				u8 ssid_len);
 

-- 
http://www.holgerschurig.de
