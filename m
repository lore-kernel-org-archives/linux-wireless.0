Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1FVIHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 04:07:03 -0400
Subject: [PATCH] wireless: unify QoS control field definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 10:06:59 +0200
Message-ID: <1308730019.3883.12.camel@jlt3.sipsolutions.net> (sfid-20110622_100709_247114_4F8BF689)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move all that mac80211 has into the generic
ieee80211.h header file and use them. At the
same time move them from mask+shift to just
bits and rename them for consistent names.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/carl9170/rx.c  |    2 +-
 drivers/net/wireless/libertas_tf/main.c |    2 +-
 include/linux/ieee80211.h               |   18 +++++++++++++-----
 net/mac80211/rx.c                       |    2 +-
 net/mac80211/wme.c                      |    3 +--
 net/mac80211/wme.h                      |    5 -----
 6 files changed, 17 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/ath/carl9170/rx.c	2011-06-22 09:57:35.000000000 +0200
+++ b/drivers/net/wireless/ath/carl9170/rx.c	2011-06-22 09:57:41.000000000 +0200
@@ -472,7 +472,7 @@ static struct sk_buff *carl9170_rx_copy_
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		reserved += NET_IP_ALIGN;
 
-		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+		if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
 			reserved += NET_IP_ALIGN;
 	}
 
--- a/drivers/net/wireless/libertas_tf/main.c	2011-06-22 09:57:35.000000000 +0200
+++ b/drivers/net/wireless/libertas_tf/main.c	2011-06-22 09:57:46.000000000 +0200
@@ -584,7 +584,7 @@ int lbtf_rx(struct lbtf_private *priv, s
 	need_padding ^= ieee80211_has_a4(hdr->frame_control);
 	need_padding ^= ieee80211_is_data_qos(hdr->frame_control) &&
 			(*ieee80211_get_qos_ctl(hdr) &
-			 IEEE80211_QOS_CONTROL_A_MSDU_PRESENT);
+			 IEEE80211_QOS_CTL_A_MSDU_PRESENT);
 
 	if (need_padding) {
 		memmove(skb->data + 2, skb->data, skb->len);
--- a/include/linux/ieee80211.h	2011-06-22 09:48:22.000000000 +0200
+++ b/include/linux/ieee80211.h	2011-06-22 09:59:40.000000000 +0200
@@ -117,8 +117,19 @@
 #define IEEE80211_MAX_MESH_ID_LEN	32
 
 #define IEEE80211_QOS_CTL_LEN		2
-#define IEEE80211_QOS_CTL_TID_MASK	0x000F
-#define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
+/* 1d tag mask */
+#define IEEE80211_QOS_CTL_TAG1D_MASK		0x0007
+/* TID mask */
+#define IEEE80211_QOS_CTL_TID_MASK		0x000f
+/* EOSP */
+#define IEEE80211_QOS_CTL_EOSP			0x0010
+/* ACK policy */
+#define IEEE80211_QOS_CTL_ACK_POLICY_NORMAL	0x0000
+#define IEEE80211_QOS_CTL_ACK_POLICY_NOACK	0x0020
+#define IEEE80211_QOS_CTL_ACK_POLICY_NO_EXPL	0x0040
+#define IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK	0x0060
+/* A-MSDU 802.11n */
+#define IEEE80211_QOS_CTL_A_MSDU_PRESENT	0x0080
 
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
@@ -1423,9 +1434,6 @@ enum ieee80211_sa_query_action {
 };
 
 
-/* A-MSDU 802.11n */
-#define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
-
 /* cipher suite selectors */
 #define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
 #define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
--- a/net/mac80211/rx.c	2011-06-22 09:57:35.000000000 +0200
+++ b/net/mac80211/rx.c	2011-06-22 09:57:51.000000000 +0200
@@ -338,7 +338,7 @@ static void ieee80211_parse_qos(struct i
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		/* frame has qos control */
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+		if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
 			status->rx_flags |= IEEE80211_RX_AMSDU;
 	} else {
 		/*
--- a/net/mac80211/wme.h	2011-06-22 09:48:33.000000000 +0200
+++ b/net/mac80211/wme.h	2011-06-22 09:48:42.000000000 +0200
@@ -13,11 +13,6 @@
 #include <linux/netdevice.h>
 #include "ieee80211_i.h"
 
-#define QOS_CONTROL_ACK_POLICY_NORMAL 0
-#define QOS_CONTROL_ACK_POLICY_NOACK 1
-
-#define QOS_CONTROL_ACK_POLICY_SHIFT 5
-
 extern const int ieee802_1d_to_ac[8];
 
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/wme.c	2011-06-22 09:48:33.000000000 +0200
+++ b/net/mac80211/wme.c	2011-06-22 10:03:53.000000000 +0200
@@ -151,8 +151,7 @@ void ieee80211_set_qos_hdr(struct ieee80
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
 		if (unlikely(local->wifi_wme_noack_test))
-			ack_policy |= QOS_CONTROL_ACK_POLICY_NOACK <<
-					QOS_CONTROL_ACK_POLICY_SHIFT;
+			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		/* qos header is 2 bytes, second reserved */
 		*p++ = ack_policy | tid;
 		*p = 0;


