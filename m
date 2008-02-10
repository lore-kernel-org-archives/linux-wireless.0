Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53747 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYBJPL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:11:57 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 01/12] Use net/mac80211.h instead of net/ieee80211.h
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 16:59:56 +0200
Message-ID: <20080210145956.17592.240.stgit@tikku> (sfid-20080210_151204_022194_E012817A)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Roskin <proski@gnu.org>

Rename symbols as required.  Use IEEE80211_MAX_FRAG_THRESHOLD as the
maximal packet size, which takes slightly more memory, but should be
safer.

Copy some frame definitions from net/ieee80211.h to at76_usb.h.  It's
done temporarily until mac80211 conversion is complete.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   43 ++++++++++-----------
 drivers/net/wireless/at76_usb.h |   79 +++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 31 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index b95718a..1f841bb 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -36,7 +36,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <linux/firmware.h>
 #include <linux/leds.h>
-#include <net/ieee80211.h>
+#include <net/mac80211.h>
 
 #include "at76_usb.h"
 
@@ -1713,12 +1713,12 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 
 	/* write TLV data elements */
 
-	ie->id = MFIE_TYPE_SSID;
+	ie->id = WLAN_EID_SSID;
 	ie->len = bss->ssid_len;
 	memcpy(ie->data, bss->ssid, bss->ssid_len);
 	next_ie(&ie);
 
-	ie->id = MFIE_TYPE_RATES;
+	ie->id = WLAN_EID_SUPP_RATES;
 	ie->len = sizeof(hw_rates);
 	memcpy(ie->data, hw_rates, sizeof(hw_rates));
 	next_ie(&ie);		/* ie points behind the supp_rates field */
@@ -2076,10 +2076,10 @@ static int at76_iw_handler_get_range(struct net_device *netdev,
 	range->num_bitrates = 4;
 
 	range->min_rts = 0;
-	range->max_rts = MAX_RTS_THRESHOLD;
+	range->max_rts = IEEE80211_MAX_RTS_THRESHOLD;
 
 	range->min_frag = MIN_FRAG_THRESHOLD;
-	range->max_frag = MAX_FRAG_THRESHOLD;
+	range->max_frag = IEEE80211_MAX_FRAG_THRESHOLD;
 
 	range->pmp_flags = IW_POWER_PERIOD;
 	range->pmt_flags = IW_POWER_ON;
@@ -2558,9 +2558,9 @@ static int at76_iw_handler_set_rts(struct net_device *netdev,
 		 netdev->name, rts->value, (rts->disabled) ? "true" : "false");
 
 	if (rts->disabled)
-		rthr = MAX_RTS_THRESHOLD;
+		rthr = IEEE80211_MAX_RTS_THRESHOLD;
 
-	if ((rthr < 0) || (rthr > MAX_RTS_THRESHOLD))
+	if ((rthr < 0) || (rthr > IEEE80211_MAX_RTS_THRESHOLD))
 		ret = -EINVAL;
 	else
 		priv->rts_threshold = rthr;
@@ -2575,7 +2575,7 @@ static int at76_iw_handler_get_rts(struct net_device *netdev,
 	struct at76_priv *priv = netdev_priv(netdev);
 
 	rts->value = priv->rts_threshold;
-	rts->disabled = (rts->value >= MAX_RTS_THRESHOLD);
+	rts->disabled = (rts->value >= IEEE80211_MAX_RTS_THRESHOLD);
 	rts->fixed = 1;
 
 	at76_dbg(DBG_IOCTL, "%s: SIOCGIWRTS - value %d disabled %s",
@@ -2597,9 +2597,10 @@ static int at76_iw_handler_set_frag(struct net_device *netdev,
 		 (frag->disabled) ? "true" : "false");
 
 	if (frag->disabled)
-		fthr = MAX_FRAG_THRESHOLD;
+		fthr = IEEE80211_MAX_FRAG_THRESHOLD;
 
-	if ((fthr < MIN_FRAG_THRESHOLD) || (fthr > MAX_FRAG_THRESHOLD))
+	if ((fthr < MIN_FRAG_THRESHOLD)
+	    || (fthr > IEEE80211_MAX_FRAG_THRESHOLD))
 		ret = -EINVAL;
 	else
 		priv->frag_threshold = fthr & ~0x1;	/* get an even value */
@@ -2614,7 +2615,7 @@ static int at76_iw_handler_get_frag(struct net_device *netdev,
 	struct at76_priv *priv = netdev_priv(netdev);
 
 	frag->value = priv->frag_threshold;
-	frag->disabled = (frag->value >= MAX_FRAG_THRESHOLD);
+	frag->disabled = (frag->value >= IEEE80211_MAX_FRAG_THRESHOLD);
 	frag->fixed = 1;
 
 	at76_dbg(DBG_IOCTL, "%s: SIOCGIWFRAG - value %d, disabled %s",
@@ -2705,7 +2706,7 @@ static int at76_iw_handler_set_encode(struct net_device *netdev,
 		if (len > WEP_LARGE_KEY_LEN)
 			len = WEP_LARGE_KEY_LEN;
 
-		memset(priv->wep_keys[index], 0, WEP_KEY_LEN);
+		memset(priv->wep_keys[index], 0, sizeof(priv->wep_keys[index]));
 		memcpy(priv->wep_keys[index], extra, len);
 		priv->wep_keys_len[index] = (len <= WEP_SMALL_KEY_LEN) ?
 		    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;
@@ -3940,7 +3941,8 @@ static int at76_startup_device(struct at76_priv *priv)
 	ccfg->ssid_len = priv->essid_size;
 
 	ccfg->wep_default_key_id = priv->wep_key_id;
-	memcpy(ccfg->wep_default_key_value, priv->wep_keys, 4 * WEP_KEY_LEN);
+	memcpy(ccfg->wep_default_key_value, priv->wep_keys,
+	       sizeof(priv->wep_keys));
 
 	ccfg->short_preamble = priv->preamble_type;
 	ccfg->beacon_period = cpu_to_le16(priv->beacon_period);
@@ -4369,7 +4371,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 	 * usually arrive in consecutively, but there have been some
 	 * reports of some of the useful information fields arriving in a
 	 * different order).
-	 * It does not support any more IE types although MFIE_TYPE_TIM may
+	 * It does not support any more IE types although WLAN_EID_TIM may
 	 * be supported (on my AP at least).
 	 * The bdata->data array is about 1500 bytes long but only ~36 of those
 	 * bytes are useful, hence the have_ssid etc optimizations. */
@@ -4380,7 +4382,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 
 		switch (ie->id) {
 
-		case MFIE_TYPE_SSID:
+		case WLAN_EID_SSID:
 			if (have_ssid)
 				break;
 
@@ -4403,7 +4405,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 			have_ssid = 1;
 			break;
 
-		case MFIE_TYPE_RATES:
+		case WLAN_EID_SUPP_RATES:
 			if (have_rates)
 				break;
 
@@ -4416,7 +4418,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 				 hex2str(ie->data, ie->len));
 			break;
 
-		case MFIE_TYPE_DS_SET:
+		case WLAN_EID_DS_PARAMS:
 			if (have_channel)
 				break;
 
@@ -4426,9 +4428,6 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 				 priv->netdev->name, match->channel);
 			break;
 
-		case MFIE_TYPE_CF_SET:
-		case MFIE_TYPE_TIM:
-		case MFIE_TYPE_IBSS_SET:
 		default:
 			at76_dbg(DBG_RX_BEACON, "%s: beacon IE id %d len %d %s",
 				 priv->netdev->name, ie->id, ie->len,
@@ -4648,7 +4647,7 @@ static struct sk_buff *at76_check_for_rx_frags(struct at76_priv *priv)
 
 	/* Length including the IEEE802.11 header, but without the trailing
 	 * FCS and without the Atmel Rx header */
-	int length = le16_to_cpu(buf->wlength) - IEEE80211_FCS_LEN;
+	int length = le16_to_cpu(buf->wlength) - FCS_LEN;
 
 	/* where does the data payload start in skb->data ? */
 	u8 *data = i802_11_hdr->payload;
@@ -4901,7 +4900,7 @@ static void at76_rx_monitor_mode(struct at76_priv *priv)
 	struct sk_buff *skb = priv->rx_skb;
 	struct net_device_stats *stats = &priv->stats;
 
-	if (length < IEEE80211_FCS_LEN) {
+	if (length < FCS_LEN) {
 		/* buffer contains no data */
 		at76_dbg(DBG_MONITOR_MODE,
 			 "%s: MONITOR MODE: rx skb without data",
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index b20be9d..9329d5d 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -147,6 +147,7 @@ union at76_hwcfg {
 
 #define WEP_SMALL_KEY_LEN	(40 / 8)
 #define WEP_LARGE_KEY_LEN	(104 / 8)
+#define WEP_KEYS		(4)
 
 struct at76_card_config {
 	u8 exclude_unencrypted;
@@ -161,7 +162,7 @@ struct at76_card_config {
 	u8 privacy_invoked;
 	u8 wep_default_key_id;	/* 0..3 */
 	u8 current_ssid[32];
-	u8 wep_default_key_value[4][WEP_KEY_LEN];
+	u8 wep_default_key_value[4][WEP_LARGE_KEY_LEN];
 	u8 ssid_len;
 	u8 short_preamble;
 	__le16 beacon_period;
@@ -186,7 +187,7 @@ struct at76_rx_buffer {
 	u8 link_quality;
 	u8 noise_level;
 	__le32 rx_time;
-	u8 packet[IEEE80211_FRAME_LEN + IEEE80211_FCS_LEN];
+	u8 packet[IEEE80211_MAX_FRAG_THRESHOLD];
 } __attribute__((packed));
 
 /* Length of Atmel-specific Tx header before 802.11 frame */
@@ -197,7 +198,7 @@ struct at76_tx_buffer {
 	u8 tx_rate;
 	u8 padding;
 	u8 reserved[4];
-	u8 packet[IEEE80211_FRAME_LEN + IEEE80211_FCS_LEN];
+	u8 packet[IEEE80211_MAX_FRAG_THRESHOLD];
 } __attribute__((packed));
 
 /* defines for scan_type below */
@@ -317,7 +318,7 @@ struct mib_mac_wep {
 	u8 exclude_unencrypted;
 	__le32 wep_icv_error_count;
 	__le32 wep_excluded_count;
-	u8 wep_default_keyvalue[WEP_KEYS][WEP_KEY_LEN];
+	u8 wep_default_keyvalue[WEP_KEYS][WEP_LARGE_KEY_LEN];
 	u8 encryption_level;	/* 1 for 40bit, 2 for 104bit encryption */
 } __attribute__((packed));
 
@@ -471,9 +472,8 @@ struct at76_priv {
 	/* the WEP stuff */
 	int wep_enabled;	/* 1 if WEP is enabled */
 	int wep_key_id;		/* key id to be used */
-	u8 wep_keys[WEP_KEYS][WEP_KEY_LEN];	/* the four WEP keys,
-						   5 or 13 bytes are used */
-	u8 wep_keys_len[WEP_KEYS];	/* the length of the above keys */
+	u8 wep_keys[WEP_KEYS][WEP_LARGE_KEY_LEN];	/* WEP keys */
+	u8 wep_keys_len[WEP_KEYS];	/* length of WEP keys */
 
 	int channel;
 	int iw_mode;
@@ -611,9 +611,70 @@ struct at76_rx_radiotap {
 #define DEF_SCAN_MIN_TIME	10
 #define DEF_SCAN_MAX_TIME	120
 
-#define MAX_RTS_THRESHOLD	(MAX_FRAG_THRESHOLD + 1)
-
 /* the max padding size for tx in bytes (see calc_padding) */
 #define MAX_PADDING_SIZE	53
 
+#define MIN_FRAG_THRESHOLD 256
+
+struct ieee80211_info_element {
+	u8 id;
+	u8 len;
+	u8 data[0];
+} __attribute__((packed));
+
+struct ieee80211_hdr_3addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 payload[0];
+} __attribute__((packed));
+
+struct ieee80211_auth {
+	struct ieee80211_hdr_3addr header;
+	__le16 algorithm;
+	__le16 transaction;
+	__le16 status;
+	/* challenge */
+	struct ieee80211_info_element info_element[0];
+} __attribute__((packed));
+
+struct ieee80211_assoc_request {
+	struct ieee80211_hdr_3addr header;
+	__le16 capability;
+	__le16 listen_interval;
+	/* SSID, supported rates, RSN */
+	struct ieee80211_info_element info_element[0];
+} __attribute__((packed));
+
+struct ieee80211_assoc_response {
+	struct ieee80211_hdr_3addr header;
+	__le16 capability;
+	__le16 status;
+	__le16 aid;
+	/* supported rates */
+	struct ieee80211_info_element info_element[0];
+} __attribute__((packed));
+
+struct ieee80211_disassoc {
+	struct ieee80211_hdr_3addr header;
+	__le16 reason;
+} __attribute__((packed));
+
+struct ieee80211_probe_response {
+	struct ieee80211_hdr_3addr header;
+	u32 time_stamp[2];
+	__le16 beacon_interval;
+	__le16 capability;
+	/* SSID, supported rates, FH params, DS params,
+	 * CF params, IBSS params, TIM (if beacon), RSN */
+	struct ieee80211_info_element info_element[0];
+} __attribute__((packed));
+
+#define ieee80211_beacon ieee80211_probe_response
+
+#define IEEE80211_3ADDR_LEN sizeof(struct ieee80211_hdr_3addr)
+
 #endif				/* _AT76_USB_H */

