Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:36857 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AESQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:16:22 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 6EED18C4B9
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:21 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 5D0EF158A6F
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:20 +0200 (EET)
Subject: [PATCH v2 1/9] mac80211: add functions to create PS Poll and Nullfunc
	templates
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:16:19 +0200
Message-ID: <20100105181619.27418.34851.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Some hardware, for example wl1251 and wl1271, handle the transmission
of power save related frames in hardware, but the driver is responsible
for creating the templates. It's better to create the templates in mac80211,
that way all drivers can benefit from this.

Add two new functions, ieee80211_pspoll_get() and ieee80211_nullfunc_get()
which drivers need to call to get the frame. Drivers are also responsible
for updating the templates after each association.

Also new struct ieee80211_hdr_3addr is added to ieee80211.h to make it
easy to calculate length of the Nullfunc frame.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/ieee80211.h |    9 +++++
 include/net/mac80211.h    |   30 +++++++++++++++++
 net/mac80211/tx.c         |   78 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aeea282..602c069 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -130,6 +130,15 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+struct ieee80211_hdr_3addr {
+	__le16 frame_control;
+	__le16 duration_id;
+	u8 addr1[6];
+	u8 addr2[6];
+	u8 addr3[6];
+	__le16 seq_ctrl;
+} __attribute__ ((packed));
+
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
  * @fc: frame control bytes in little-endian byteorder
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f073a2a..eda45c3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1874,6 +1874,36 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 }
 
 /**
+ * ieee80211_pspoll_get - retrieve a PS Poll template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Creates a PS Poll a template which can, for example, uploaded to
+ * hardware. The template must be updated after association so that correct
+ * AID, BSSID and MAC address is used.
+ *
+ * Note: Caller (or hardware) is responsible for setting the
+ * &IEEE80211_FCTL_PM bit.
+ */
+struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif);
+
+/**
+ * ieee80211_nullfunc_get - retrieve a nullfunc template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Creates a Nullfunc template which can, for example, uploaded to
+ * hardware. The template must be updated after association so that correct
+ * BSSID and address is used.
+ *
+ * Note: Caller (or hardware) is responsible for setting the
+ * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
+ */
+struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif);
+
+/**
  * ieee80211_rts_get - RTS frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7bba49d..bb8819d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2190,6 +2190,84 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_beacon_get_tim);
 
+struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_pspoll *pspoll;
+	struct ieee80211_local *local;
+	struct sk_buff *skb;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+		return NULL;
+
+	sdata = vif_to_sdata(vif);
+	ifmgd = &sdata->u.mgd;
+	local = sdata->local;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for "
+		       "pspoll template\n", sdata->name);
+		return NULL;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	pspoll = (struct ieee80211_pspoll *) skb_put(skb, sizeof(*pspoll));
+	memset(pspoll, 0, sizeof(*pspoll));
+	pspoll->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					    IEEE80211_STYPE_PSPOLL);
+	pspoll->aid = cpu_to_le16(ifmgd->aid);
+
+	/* aid in PS-Poll has its two MSBs each set to 1 */
+	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
+
+	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
+	memcpy(pspoll->ta, vif->addr, ETH_ALEN);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_pspoll_get);
+
+struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
+{
+	struct ieee80211_hdr_3addr *nullfunc;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_local *local;
+	struct sk_buff *skb;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+		return NULL;
+
+	sdata = vif_to_sdata(vif);
+	ifmgd = &sdata->u.mgd;
+	local = sdata->local;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*nullfunc));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
+		       "template\n", sdata->name);
+		return NULL;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr_3addr *) skb_put(skb,
+							  sizeof(*nullfunc));
+	memset(nullfunc, 0, sizeof(*nullfunc));
+	nullfunc->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					      IEEE80211_STYPE_NULLFUNC |
+					      IEEE80211_FCTL_TODS);
+	memcpy(nullfunc->addr1, ifmgd->bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, ifmgd->bssid, ETH_ALEN);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_nullfunc_get);
+
 void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_info *frame_txctl,

