Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:51455 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab2EZKGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 06:06:45 -0400
From: Soumik Das <soumik.das@stericsson.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Soumik Das <soumik.das@stericsson.com>,
	Prakhar Vig <prakhar.vig@stericsson.com>
Subject: [PATCH] mac80211: Add routine for retrieving qosnull frame
Date: Sat, 26 May 2012 15:36:21 +0530
Message-ID: <1338026781-25853-1-git-send-email-soumik.das@stericsson.com> (sfid-20120526_120727_706187_BD7EC17C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Soumik Das <soumik.das@stericsson.com>

Add routine for retrieving qos null template frame.
Driver may need that for uploading it in the device.

Signed-off-by: Soumik Das <soumik.das@stericsson.com>
Signed-off-by: Prakhar Vig <prakhar.vig@stericsson.com>
---
 include/net/mac80211.h |   16 ++++++++++++++++
 net/mac80211/tx.c      |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1937c7d..10a0529 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2876,6 +2876,22 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_qosnullfunc_get - retrieve a qos nullfunc template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Creates a QOS Nullfunc template which can, for example, be uploaded to
+ * hardware. The template must be updated after association so that correct
+ * BSSID and address is used.
+ *
+ * Note: Caller (or hardware) is responsible for setting the
+ * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
+ * The qos ctl field is set to zero by the function. Caller must
+ * fill up proper value.
+ */
+struct sk_buff *ieee80211_qosnullfunc_get(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif);
+/**
  * ieee80211_probereq_get - retrieve a Probe Request template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d67d36f..5e4b857 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2595,6 +2595,44 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_nullfunc_get);
 
+struct sk_buff *ieee80211_qosnullfunc_get(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct ieee80211_qos_hdr *nullfunc;
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
+		printk(KERN_DEBUG "%s: failed to allocate buffer for qos "
+		       "nullfunc template\n", sdata->name);
+		return NULL;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr_3addr *) skb_put(skb,
+							  sizeof(*nullfunc));
+	memset(nullfunc, 0, sizeof(*nullfunc));
+	nullfunc->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					      IEEE80211_STYPE_QOS_NULLFUNC |
+					      IEEE80211_FCTL_TODS);
+	memcpy(nullfunc->addr1, ifmgd->bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, ifmgd->bssid, ETH_ALEN);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_qosnullfunc_get);
+
 struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       const u8 *ssid, size_t ssid_len,
-- 
1.7.0.4

