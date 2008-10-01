Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50410 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYJACXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/5] wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts
Date: Tue, 30 Sep 2008 22:15:52 -0400
Message-Id: <1222827352-1978-6-git-send-email-linville@tuxdriver.com> (sfid-20081001_042409_257643_AC52728F)
In-Reply-To: <1222827352-1978-5-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-2-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-3-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-4-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-5-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is quite a lot of overlap in definitions between these headers...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/hostap/hostap_common.h |   13 ---
 drivers/net/wireless/ipw2200.c              |   24 +++---
 include/net/ieee80211.h                     |  112 +--------------------------
 include/net/lib80211.h                      |    4 +-
 net/ieee80211/ieee80211_rx.c                |    2 +-
 5 files changed, 18 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index b470c74..90b64b0 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -6,19 +6,6 @@
 
 /* IEEE 802.11 defines */
 
-/* Information Element IDs */
-#define WLAN_EID_SSID 0
-#define WLAN_EID_SUPP_RATES 1
-#define WLAN_EID_FH_PARAMS 2
-#define WLAN_EID_DS_PARAMS 3
-#define WLAN_EID_CF_PARAMS 4
-#define WLAN_EID_TIM 5
-#define WLAN_EID_IBSS_PARAMS 6
-#define WLAN_EID_CHALLENGE 16
-#define WLAN_EID_RSN 48
-#define WLAN_EID_GENERIC 221
-
-
 /* HFA384X Configuration RIDs */
 #define HFA384X_RID_CNFPORTTYPE 0xFC00
 #define HFA384X_RID_CNFOWNMACADDR 0xFC01
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 4e4d3e3..534f3b9 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -4450,7 +4450,7 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 
 #ifdef CONFIG_IPW2200_QOS
 #define IPW_GET_PACKET_STYPE(x) WLAN_FC_GET_STYPE( \
-			 le16_to_cpu(((struct ieee80211_hdr *)(x))->frame_ctl))
+			 le16_to_cpu(((struct ieee80211_hdr *)(x))->frame_control))
 					if ((priv->status & STATUS_AUTH) &&
 					    (IPW_GET_PACKET_STYPE(&notif->u.raw)
 					     == IEEE80211_STYPE_ASSOC_RESP)) {
@@ -7678,12 +7678,12 @@ static void ipw_rebuild_decrypted_skb(struct ipw_priv *priv,
 	u16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fc = le16_to_cpu(hdr->frame_control);
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
 		return;
 
 	fc &= ~IEEE80211_FCTL_PROTECTED;
-	hdr->frame_ctl = cpu_to_le16(fc);
+	hdr->frame_control = cpu_to_le16(fc);
 	switch (priv->ieee->sec.level) {
 	case SEC_LEVEL_3:
 		/* Remove CCMP HDR */
@@ -7995,17 +7995,17 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 	}
 
 	hdr = (void *)rxb->skb->data + IPW_RX_FRAME_SIZE;
-	if (ieee80211_is_management(le16_to_cpu(hdr->frame_ctl))) {
+	if (ieee80211_is_management(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_MGMT)
 			return;
 		if (filter & IPW_PROM_MGMT_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_ctl))) {
+	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_CTL)
 			return;
 		if (filter & IPW_PROM_CTL_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_ctl))) {
+	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_DATA)
 			return;
 		if (filter & IPW_PROM_DATA_HEADER_ONLY)
@@ -8023,7 +8023,7 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 	ipw_rt = (void *)skb->data;
 
 	if (hdr_only)
-		len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+		len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
 
 	memcpy(ipw_rt->payload, hdr, len);
 
@@ -8243,7 +8243,7 @@ static  int is_duplicate_packet(struct ipw_priv *priv,
 	/* Comment this line now since we observed the card receives
 	 * duplicate packets but the FCTL_RETRY bit is not set in the
 	 * IBSS mode with fragmentation enabled.
-	 BUG_ON(!(le16_to_cpu(header->frame_ctl) & IEEE80211_FCTL_RETRY)); */
+	 BUG_ON(!(le16_to_cpu(header->frame_control) & IEEE80211_FCTL_RETRY)); */
 	return 1;
 }
 
@@ -10407,17 +10407,17 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 
 	/* Filtering of fragment chains is done agains the first fragment */
 	hdr = (void *)txb->fragments[0]->data;
-	if (ieee80211_is_management(le16_to_cpu(hdr->frame_ctl))) {
+	if (ieee80211_is_management(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_MGMT)
 			return;
 		if (filter & IPW_PROM_MGMT_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_ctl))) {
+	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_CTL)
 			return;
 		if (filter & IPW_PROM_CTL_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_ctl))) {
+	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_DATA)
 			return;
 		if (filter & IPW_PROM_DATA_HEADER_ONLY)
@@ -10432,7 +10432,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 
 		if (hdr_only) {
 			hdr = (void *)src->data;
-			len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+			len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
 		} else
 			len = src->len;
 
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index 7b0a505..99bccd7 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -28,6 +28,7 @@
 #include <linux/if_ether.h>	/* ETH_ALEN */
 #include <linux/kernel.h>	/* ARRAY_SIZE */
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
 
 #define IEEE80211_VERSION "git-1.1.13"
 
@@ -214,94 +215,6 @@ struct ieee80211_snap_hdr {
 #define WLAN_GET_SEQ_FRAG(seq) ((seq) & IEEE80211_SCTL_FRAG)
 #define WLAN_GET_SEQ_SEQ(seq)  (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 
-/* Authentication algorithms */
-#define WLAN_AUTH_OPEN 0
-#define WLAN_AUTH_SHARED_KEY 1
-#define WLAN_AUTH_LEAP 2
-
-#define WLAN_AUTH_CHALLENGE_LEN 128
-
-#define WLAN_CAPABILITY_ESS (1<<0)
-#define WLAN_CAPABILITY_IBSS (1<<1)
-#define WLAN_CAPABILITY_CF_POLLABLE (1<<2)
-#define WLAN_CAPABILITY_CF_POLL_REQUEST (1<<3)
-#define WLAN_CAPABILITY_PRIVACY (1<<4)
-#define WLAN_CAPABILITY_SHORT_PREAMBLE (1<<5)
-#define WLAN_CAPABILITY_PBCC (1<<6)
-#define WLAN_CAPABILITY_CHANNEL_AGILITY (1<<7)
-#define WLAN_CAPABILITY_SPECTRUM_MGMT (1<<8)
-#define WLAN_CAPABILITY_QOS (1<<9)
-#define WLAN_CAPABILITY_SHORT_SLOT_TIME (1<<10)
-#define WLAN_CAPABILITY_DSSS_OFDM (1<<13)
-
-/* 802.11g ERP information element */
-#define WLAN_ERP_NON_ERP_PRESENT (1<<0)
-#define WLAN_ERP_USE_PROTECTION (1<<1)
-#define WLAN_ERP_BARKER_PREAMBLE (1<<2)
-
-/* Status codes */
-enum ieee80211_statuscode {
-	WLAN_STATUS_SUCCESS = 0,
-	WLAN_STATUS_UNSPECIFIED_FAILURE = 1,
-	WLAN_STATUS_CAPS_UNSUPPORTED = 10,
-	WLAN_STATUS_REASSOC_NO_ASSOC = 11,
-	WLAN_STATUS_ASSOC_DENIED_UNSPEC = 12,
-	WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG = 13,
-	WLAN_STATUS_UNKNOWN_AUTH_TRANSACTION = 14,
-	WLAN_STATUS_CHALLENGE_FAIL = 15,
-	WLAN_STATUS_AUTH_TIMEOUT = 16,
-	WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA = 17,
-	WLAN_STATUS_ASSOC_DENIED_RATES = 18,
-	/* 802.11b */
-	WLAN_STATUS_ASSOC_DENIED_NOSHORTPREAMBLE = 19,
-	WLAN_STATUS_ASSOC_DENIED_NOPBCC = 20,
-	WLAN_STATUS_ASSOC_DENIED_NOAGILITY = 21,
-	/* 802.11h */
-	WLAN_STATUS_ASSOC_DENIED_NOSPECTRUM = 22,
-	WLAN_STATUS_ASSOC_REJECTED_BAD_POWER = 23,
-	WLAN_STATUS_ASSOC_REJECTED_BAD_SUPP_CHAN = 24,
-	/* 802.11g */
-	WLAN_STATUS_ASSOC_DENIED_NOSHORTTIME = 25,
-	WLAN_STATUS_ASSOC_DENIED_NODSSSOFDM = 26,
-	/* 802.11i */
-	WLAN_STATUS_INVALID_IE = 40,
-	WLAN_STATUS_INVALID_GROUP_CIPHER = 41,
-	WLAN_STATUS_INVALID_PAIRWISE_CIPHER = 42,
-	WLAN_STATUS_INVALID_AKMP = 43,
-	WLAN_STATUS_UNSUPP_RSN_VERSION = 44,
-	WLAN_STATUS_INVALID_RSN_IE_CAP = 45,
-	WLAN_STATUS_CIPHER_SUITE_REJECTED = 46,
-};
-
-/* Reason codes */
-enum ieee80211_reasoncode {
-	WLAN_REASON_UNSPECIFIED = 1,
-	WLAN_REASON_PREV_AUTH_NOT_VALID = 2,
-	WLAN_REASON_DEAUTH_LEAVING = 3,
-	WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY = 4,
-	WLAN_REASON_DISASSOC_AP_BUSY = 5,
-	WLAN_REASON_CLASS2_FRAME_FROM_NONAUTH_STA = 6,
-	WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA = 7,
-	WLAN_REASON_DISASSOC_STA_HAS_LEFT = 8,
-	WLAN_REASON_STA_REQ_ASSOC_WITHOUT_AUTH = 9,
-	/* 802.11h */
-	WLAN_REASON_DISASSOC_BAD_POWER = 10,
-	WLAN_REASON_DISASSOC_BAD_SUPP_CHAN = 11,
-	/* 802.11i */
-	WLAN_REASON_INVALID_IE = 13,
-	WLAN_REASON_MIC_FAILURE = 14,
-	WLAN_REASON_4WAY_HANDSHAKE_TIMEOUT = 15,
-	WLAN_REASON_GROUP_KEY_HANDSHAKE_TIMEOUT = 16,
-	WLAN_REASON_IE_DIFFERENT = 17,
-	WLAN_REASON_INVALID_GROUP_CIPHER = 18,
-	WLAN_REASON_INVALID_PAIRWISE_CIPHER = 19,
-	WLAN_REASON_INVALID_AKMP = 20,
-	WLAN_REASON_UNSUPP_RSN_VERSION = 21,
-	WLAN_REASON_INVALID_RSN_IE_CAP = 22,
-	WLAN_REASON_IEEE8021X_FAILED = 23,
-	WLAN_REASON_CIPHER_SUITE_REJECTED = 24,
-};
-
 /* Action categories - 802.11h */
 enum ieee80211_actioncategories {
 	WLAN_ACTION_SPECTRUM_MGMT = 0,
@@ -530,15 +443,6 @@ enum ieee80211_mfie {
 	MFIE_TYPE_QOS_PARAMETER = 222,
 };
 
-/* Minimal header; can be used for passing 802.11 frames with sufficient
- * information to determine what type of underlying data type is actually
- * stored in the data. */
-struct ieee80211_hdr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 payload[0];
-} __attribute__ ((packed));
-
 struct ieee80211_hdr_1addr {
 	__le16 frame_ctl;
 	__le16 duration_id;
@@ -586,18 +490,6 @@ struct ieee80211_hdr_3addrqos {
 	__le16 qos_ctl;
 } __attribute__ ((packed));
 
-struct ieee80211_hdr_4addrqos {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctl;
-	u8 addr4[ETH_ALEN];
-	u8 payload[0];
-	__le16 qos_ctl;
-} __attribute__ ((packed));
-
 struct ieee80211_info_element {
 	u8 id;
 	u8 len;
@@ -1187,7 +1079,7 @@ static inline int ieee80211_get_hdrlen(u16 fc)
 
 static inline u8 *ieee80211_get_payload(struct ieee80211_hdr *hdr)
 {
-	switch (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl))) {
+	switch (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control))) {
 	case IEEE80211_1ADDR_LEN:
 		return ((struct ieee80211_hdr_1addr *)hdr)->payload;
 	case IEEE80211_2ADDR_LEN:
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index d5f4e60..e1558a1 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -8,9 +8,11 @@
 #ifndef LIB80211_H
 #define LIB80211_H
 
+#include <linux/ieee80211.h>
+
 /* print_ssid() is intended to be used in debug (and possibly error)
  * messages. It should never be used for passing ssid to user space. */
 const char *print_ssid(char *buf, const char *ssid, u8 ssid_len);
-#define DECLARE_SSID_BUF(var) char var[32 * 4 + 1]
+#define DECLARE_SSID_BUF(var) char var[IEEE80211_MAX_SSID_LEN * 4 + 1] __maybe_unused
 
 #endif /* LIB80211_H */
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index cf72ae4..b0bc39d 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -40,7 +40,7 @@ static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 					struct ieee80211_rx_stats *rx_stats)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u16 fc = le16_to_cpu(hdr->frame_ctl);
+	u16 fc = le16_to_cpu(hdr->frame_control);
 
 	skb->dev = ieee->dev;
 	skb_reset_mac_header(skb);
-- 
1.5.4.3

