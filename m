Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:31608 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYFESQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 14:16:24 -0400
Received: by py-out-1112.google.com with SMTP id p76so586052pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 11:16:21 -0700 (PDT)
Subject: Re: [RFC-PATCH] mac80211: add helpers for common frame_control
	testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0806050655m92bd361sbc048230c4bb9286@mail.gmail.com>
References: <1212633200.6340.52.camel@brick>
	 <b6c5339f0806050655m92bd361sbc048230c4bb9286@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:16:19 -0700
Message-Id: <1212689779.6340.56.camel@brick> (sfid-20080605_201628_335763_878D00B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] mac80211: const fixes and sign change in ieee80211_get_hdrlen_from_skb

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Incremental patch to my last, just looking for comments on the approach/helpers.
If the approach looks good to people I'll split it into a proper series:

 drivers/net/wireless/ath5k/base.c |    4 +-
 include/linux/ieee80211.h         |   16 +++++++-------
 include/net/mac80211.h            |    2 +-
 net/mac80211/main.c               |   17 ++++++---------
 net/mac80211/rx.c                 |    3 +-
 net/mac80211/util.c               |   41 +++++++++++++++++++++++++++++++-----
 net/mac80211/wme.c                |    2 +-
 7 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 85045af..1107ac5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1775,7 +1775,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
-	int hdrlen;
+	unsigned int hdrlen;
 	int pad;
 
 	spin_lock(&sc->rxbuflock);
@@ -2627,7 +2627,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ath5k_buf *bf;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned long flags;
-	int hdrlen;
+	unsigned int hdrlen;
 	int pad;
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5880b9f..dd379f9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -109,41 +109,41 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
-static inline int ieee80211_has_tods(struct ieee80211_hdr *hdr)
+static inline int ieee80211_has_tods(const struct ieee80211_hdr *hdr)
 {
 	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_TODS)) != 0;
 }
 
-static inline int ieee80211_has_fromds(struct ieee80211_hdr *hdr)
+static inline int ieee80211_has_fromds(const struct ieee80211_hdr *hdr)
 {
 	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FROMDS)) != 0;
 }
 
-static inline int ieee80211_has_a4(struct ieee80211_hdr *hdr)
+static inline int ieee80211_has_a4(const struct ieee80211_hdr *hdr)
 {
-	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_TODS);
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
 	return (hdr->frame_control & tmp) == tmp;
 }
 
-static inline int ieee80211_is_mgmt(struct ieee80211_hdr *hdr)
+static inline int ieee80211_is_mgmt(const struct ieee80211_hdr *hdr)
 {
 	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
 	       cpu_to_le16(IEEE80211_FTYPE_MGMT);
 }
 
-static inline int ieee80211_is_ctl(struct ieee80211_hdr *hdr)
+static inline int ieee80211_is_ctl(const struct ieee80211_hdr *hdr)
 {
 	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
 	       cpu_to_le16(IEEE80211_FTYPE_CTL);
 }
 
-static inline int ieee80211_is_data(struct ieee80211_hdr *hdr)
+static inline int ieee80211_is_data(const struct ieee80211_hdr *hdr)
 {
 	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
 	       cpu_to_le16(IEEE80211_FTYPE_DATA);
 }
 
-static inline int ieee80211_data_has_qos(struct ieee80211_hdr *hdr)
+static inline int ieee80211_data_has_qos(const struct ieee80211_hdr *hdr)
 {
 	/*
 	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1196de8..f9b391f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1535,7 +1535,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
  *
  * @skb: the frame
  */
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
 /**
  * ieee80211_get_hdrlen - get header length from frame control
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4b57de4..26b97c8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1252,8 +1252,9 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 				      struct ieee80211_key *key,
 				      struct sk_buff *skb)
 {
-	int hdrlen, iv_len, mic_len;
+	unsigned int hdrlen, iv_len, mic_len;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
 
 	info->flags &=	IEEE80211_TX_CTL_REQ_TX_STATUS |
 			IEEE80211_TX_CTL_DO_NOT_ENCRYPT |
@@ -1291,15 +1292,11 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 	}
 
 no_key:
-	{
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		u16 fc = le16_to_cpu(hdr->frame_control);
-		if ((fc & 0x8C) == 0x88) /* QoS Control Field */ {
-			fc &= ~IEEE80211_STYPE_QOS_DATA;
-			hdr->frame_control = cpu_to_le16(fc);
-			memmove(skb->data + 2, skb->data, hdrlen - 2);
-			skb_pull(skb, 2);
-		}
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (ieee80211_data_has_qos(hdr)) {
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+		memmove(skb->data + 2, skb->data, hdrlen - 2);
+		skb_pull(skb, 2);
 	}
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a3643fd..63f19cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1586,7 +1586,8 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
 					    struct ieee80211_rx_data *rx)
 {
-	int keyidx, hdrlen;
+	int keyidx;
+	unsigned int hdrlen;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6513bc2..c883d59 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -94,6 +94,36 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	return NULL;
 }
 
+static unsigned int ieee80211_hdrlen(const struct ieee80211_hdr *hdr)
+{
+	unsigned int hdrlen = 24;
+
+	if (ieee80211_is_data(hdr)) {
+		if (ieee80211_has_a4(hdr))
+			hdrlen = 30;
+
+		if (ieee80211_data_has_qos(hdr))
+			hdrlen += 2;
+	} else if (ieee80211_is_ctl(hdr)) {
+		/*
+		 * ACK and CTS are 10 bytes, all others 16. To see how
+		 * to get this condition consider
+		 *   subtype mask:   0b0000000011110000 (0x00F0)
+		 *   ACK subtype:    0b0000000011010000 (0x00D0)
+		 *   CTS subtype:    0b0000000011000000 (0x00C0)
+		 *   bits that matter:         ^^^      (0x00E0)
+		 *   value of those: 0b0000000011000000 (0x00C0)
+		 */
+		if ((hdr->frame_control & cpu_to_le16(0x00E0)) ==
+		    cpu_to_le16(0x00C0))
+			hdrlen = 10;
+		else
+			hdrlen = 16;
+	}
+
+	return hdrlen;
+}
+
 int ieee80211_get_hdrlen(u16 fc)
 {
 	int hdrlen = 24;
@@ -133,15 +163,14 @@ int ieee80211_get_hdrlen(u16 fc)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
-	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
-	int hdrlen;
+	unsigned int hdrlen;
 
-	if (unlikely(skb->len < 10))
+	if (skb->len < 10)
 		return 0;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
-	if (unlikely(hdrlen > skb->len))
+	hdrlen = ieee80211_hdrlen((const struct ieee80211_hdr *)skb->data);
+	if (hdrlen > skb->len)
 		return 0;
 	return hdrlen;
 }
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 14a9ff1..bfd7cbf 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -44,7 +44,7 @@ static inline unsigned classify_1d(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct iphdr *ip;
 	int dscp;
-	int offset;
+	unsigned int offset;
 
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct tcf_result res = { -1, 0 };
-- 
1.5.6.rc1.257.gba91d



