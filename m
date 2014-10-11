Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37416 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaJKETb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 00:19:31 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so2840570pab.4
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 21:19:30 -0700 (PDT)
Date: Sat, 11 Oct 2014 12:19:23 +0800
From: Matthew Tyler <matt.tyler@flashics.com>
To: jes.sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8732au: Fix coding style violations in ieee80211.h
Message-ID: <20141011041923.GA9075@ZeroX.Belkin> (sfid-20141011_061937_913656_A0AC1116)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Matthew Tyler <matt.tyler@flashics.com>
---
 drivers/staging/rtl8723au/include/ieee80211.h | 81 ++++++++++++++++++---------
 1 file changed, 54 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
index cb23cd0..0590025 100644
--- a/drivers/staging/rtl8723au/include/ieee80211.h
+++ b/drivers/staging/rtl8723au/include/ieee80211.h
@@ -57,8 +57,8 @@
 
 
 #define WPA_SELECTOR_LEN 4
-extern u8 RTW_WPA_OUI23A_TYPE[] ;
-extern u16 RTW_WPA_VERSION23A ;
+extern u8 RTW_WPA_OUI23A_TYPE[];
+extern u16 RTW_WPA_VERSION23A;
 extern u8 WPA_AUTH_KEY_MGMT_NONE23A[];
 extern u8 WPA_AUTH_KEY_MGMT_UNSPEC_802_1X23A[];
 extern u8 WPA_AUTH_KEY_MGMT_PSK_OVER_802_1X23A[];
@@ -94,8 +94,7 @@ enum ratr_table_mode {
 	RATR_INX_WIRELESS_AC_N = 8,
 };
 
-enum NETWORK_TYPE
-{
+enum NETWORK_TYPE {
 	WIRELESS_INVALID = 0,
 	/* Sub-Element */
 	/*  tx: cck only , rx: cck only, hw: cck */
@@ -127,22 +126,34 @@ enum NETWORK_TYPE
 				WIRELESS_11_24N | WIRELESS_11_5N,
 };
 
-#define SUPPORTED_24G_NETTYPE_MSK (WIRELESS_11B | WIRELESS_11G | WIRELESS_11_24N)
+#define SUPPORTED_24G_NETTYPE_MSK \
+	(WIRELESS_11B | WIRELESS_11G | WIRELESS_11_24N)
+
 #define SUPPORTED_5G_NETTYPE_MSK (WIRELESS_11A | WIRELESS_11_5N)
 
-#define IsSupported24G(NetType) (NetType & SUPPORTED_24G_NETTYPE_MSK ? true : false)
-#define IsSupported5G(NetType) (NetType & SUPPORTED_5G_NETTYPE_MSK ? true : false)
+#define IsSupported24G(NetType) \
+	(NetType & SUPPORTED_24G_NETTYPE_MSK ? true : false)
+
+#define IsSupported5G(NetType) \
+	(NetType & SUPPORTED_5G_NETTYPE_MSK ? true : false)
 
 #define IsEnableHWCCK(NetType) IsSupported24G(NetType)
-#define IsEnableHWOFDM(NetType) (NetType & (WIRELESS_11G|WIRELESS_11_24N|SUPPORTED_5G_NETTYPE_MSK) ? true : false)
+
+#define IsEnableHWOFDM(NetType) \
+	(NetType & (WIRELESS_11G|WIRELESS_11_24N|SUPPORTED_5G_NETTYPE_MSK) \
+	? true : false)
 
 #define IsSupportedRxCCK(NetType) IsEnableHWCCK(NetType)
 #define IsSupportedRxOFDM(NetType) IsEnableHWOFDM(NetType)
 #define IsSupportedRxMCS(NetType) IsEnableHWOFDM(NetType)
 
 #define IsSupportedTxCCK(NetType) (NetType & (WIRELESS_11B) ? true : false)
-#define IsSupportedTxOFDM(NetType) (NetType & (WIRELESS_11G|WIRELESS_11A) ? true : false)
-#define IsSupportedTxMCS(NetType) (NetType & (WIRELESS_11_24N|WIRELESS_11_5N) ? true : false)
+
+#define IsSupportedTxOFDM(NetType) \
+	(NetType & (WIRELESS_11G|WIRELESS_11A) ? true : false)
+
+#define IsSupportedTxMCS(NetType) \
+	(NetType & (WIRELESS_11_24N|WIRELESS_11_5N) ? true : false)
 
 
 #define MIN_FRAG_THRESHOLD     256U
@@ -163,7 +174,7 @@ struct ieee80211_snap_hdr {
 	u8    ssap;   /* always 0xAA */
 	u8    ctrl;   /* always 0x03 */
 	u8    oui[P80211_OUI_LEN];    /* organizational universal id */
-} __attribute__ ((packed));
+} __packed;
 
 
 #define SNAP_SIZE sizeof(struct ieee80211_snap_hdr)
@@ -185,7 +196,7 @@ struct ieee80211_snap_hdr {
 #define IEEE80211_24GHZ_BAND     (1<<0)
 #define IEEE80211_52GHZ_BAND     (1<<1)
 
-#define IEEE80211_CCK_RATE_LEN			4
+#define IEEE80211_CCK_RATE_LEN		4
 #define IEEE80211_NUM_OFDM_RATESLEN	8
 
 
@@ -220,7 +231,7 @@ struct ieee80211_snap_hdr {
 #define IEEE80211_CCK_RATES_MASK	        0x0000000F
 #define IEEE80211_CCK_BASIC_RATES_MASK	(IEEE80211_CCK_RATE_1MB_MASK | \
 	IEEE80211_CCK_RATE_2MB_MASK)
-#define IEEE80211_CCK_DEFAULT_RATES_MASK	(IEEE80211_CCK_BASIC_RATES_MASK | \
+#define IEEE80211_CCK_DEFAULT_RATES_MASK (IEEE80211_CCK_BASIC_RATES_MASK | \
 	IEEE80211_CCK_RATE_5MB_MASK | \
 	IEEE80211_CCK_RATE_11MB_MASK)
 
@@ -228,7 +239,7 @@ struct ieee80211_snap_hdr {
 #define IEEE80211_OFDM_BASIC_RATES_MASK	(IEEE80211_OFDM_RATE_6MB_MASK | \
 	IEEE80211_OFDM_RATE_12MB_MASK | \
 	IEEE80211_OFDM_RATE_24MB_MASK)
-#define IEEE80211_OFDM_DEFAULT_RATES_MASK	(IEEE80211_OFDM_BASIC_RATES_MASK | \
+#define IEEE80211_OFDM_DEFAULT_RATES_MASK (IEEE80211_OFDM_BASIC_RATES_MASK | \
 	IEEE80211_OFDM_RATE_9MB_MASK  | \
 	IEEE80211_OFDM_RATE_18MB_MASK | \
 	IEEE80211_OFDM_RATE_36MB_MASK | \
@@ -266,7 +277,9 @@ join_res:
 */
 
 #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-#define MAC_ARG(x) ((u8*)(x))[0],((u8*)(x))[1],((u8*)(x))[2],((u8*)(x))[3],((u8*)(x))[4],((u8*)(x))[5]
+#define MAC_ARG(x) \
+	(((u8 *)(x))[0], ((u8 *)(x))[1], ((u8 *)(x))[2], \
+	 ((u8 *)(x))[3], ((u8 *)(x))[4], ((u8 *)(x))[5])
 
 #define MAXTID	16
 
@@ -312,7 +325,7 @@ struct rtw_ieee80211_channel {
 #define CHAN_ARG(channel) \
 	/*(channel)->band*/ \
 	/*, (channel)->center_freq*/ \
-	(channel)->hw_value \
+	((channel)->hw_value \
 	, (channel)->flags \
 	/*, (channel)->max_antenna_gain*/ \
 	/*, (channel)->max_power*/ \
@@ -321,31 +334,45 @@ struct rtw_ieee80211_channel {
 	/*, (channel)->orig_flags*/ \
 	/*, (channel)->orig_mag*/ \
 	/*, (channel)->orig_mpwr*/ \
+	)
 
 u8 *rtw_set_ie23a(u8 *pbuf, int index, uint len, const u8 *source, uint *frlen);
 
 u8 hal_ch_offset_to_secondary_ch_offset23a(u8 ch_offset);
-u8 *rtw_set_ie23a_ch_switch(u8 *buf, u32 *buf_len, u8 ch_switch_mode, u8 new_ch, u8 ch_switch_cnt);
-u8 *rtw_set_ie23a_secondary_ch_offset(u8 *buf, u32 *buf_len, u8 secondary_ch_offset);
 
-u8 *rtw_get_ie23a(u8*pbuf, int index, int *len, int limit);
-u8 *rtw_get_ie23a_ex(u8 *in_ie, uint in_len, u8 eid, u8 *oui, u8 oui_len, u8 *ie, uint *ielen);
-int rtw_ies_remove_ie23a(u8 *ies, uint *ies_len, uint offset, u8 eid, u8 *oui, u8 oui_len);
+u8 *rtw_set_ie23a_ch_switch(u8 *buf, u32 *buf_len,
+			u8 ch_switch_mode, u8 new_ch, u8 ch_switch_cnt);
+
+u8 *rtw_set_ie23a_secondary_ch_offset(u8 *buf,
+		u32 *buf_len, u8 secondary_ch_offset);
+
+u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit);
+
+u8 *rtw_get_ie23a_ex(u8 *in_ie,
+		uint in_len, u8 eid, u8 *oui, u8 oui_len, u8 *ie, uint *ielen);
+
+int rtw_ies_remove_ie23a(u8 *ies,
+		uint *ies_len, uint offset, u8 eid, u8 *oui, u8 oui_len);
 
 void rtw_set_supported_rate23a(u8 *SupportedRates, uint mode);
 
-int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x);
-int rtw_parse_wpa2_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x);
+int rtw_parse_wpa_ie23a(const u8 *wpa_ie, int wpa_ie_len,
+		int *group_cipher, int *pairwise_cipher, int *is_8021x);
 
-const u8 *rtw_get_wps_attr23a(const u8 *wps_ie, uint wps_ielen, u16 target_attr_id ,u8 *buf_attr, u32 *len_attr);
-const u8 *rtw_get_wps_attr_content23a(const u8 *wps_ie, uint wps_ielen, u16 target_attr_id ,u8 *buf_content);
+int rtw_parse_wpa2_ie23a(const u8 *wpa_ie, int wpa_ie_len,
+		int *group_cipher, int *pairwise_cipher, int *is_8021x);
 
-uint	rtw_get_rateset_len23a(u8	*rateset);
+const u8 *rtw_get_wps_attr23a(const u8 *wps_ie, uint wps_ielen,
+		u16 target_attr_id, u8 *buf_attr, u32 *len_attr);
+
+const u8 *rtw_get_wps_attr_content23a(const u8 *wps_ie,
+		uint wps_ielen, u16 target_attr_id, u8 *buf_content);
+
+uint rtw_get_rateset_len23a(u8 *rateset);
 
 struct registry_priv;
 int rtw_generate_ie23a(struct registry_priv *pregistrypriv);
 
-
 int rtw_get_bit_value_from_ieee_value23a(u8 val);
 
 int rtw_check_network_type23a(unsigned char *rate, int ratelen, int channel);
-- 
2.1.2

