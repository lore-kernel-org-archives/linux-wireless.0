Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:50265 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0AESQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:16:41 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 29D7D8C301
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:40 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 14101E51C4
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:39 +0200 (EET)
Subject: [PATCH v2 4/9] mac80211: create Probe Request template
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:16:38 +0200
Message-ID: <20100105181638.27418.12819.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Certain type of hardware, for example wl1251 and wl1271, need a template
for the Probe Request. Create a function ieee80211_probereq_get() which
creates the template and drivers send it to hardware.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/net/mac80211.h |   17 ++++++++++++++++
 net/mac80211/tx.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index eda45c3..6b4cd98 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1904,6 +1904,23 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_probereq_get - retrieve a Probe Request template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @ssid: SSID buffer
+ * @ssid_len: length of SSID
+ * @ie: buffer containing all IEs except SSID for the template
+ * @ie_len: length of the IE buffer
+ *
+ * Creates a Probe Request template which can, for example, be uploaded to
+ * hardware.
+ */
+struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       const u8 *ssid, size_t ssid_len,
+				       const u8 *ie, size_t ie_len);
+
+/**
  * ieee80211_rts_get - RTS frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bb8819d..361dbf6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2268,6 +2268,56 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_nullfunc_get);
 
+struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       const u8 *ssid, size_t ssid_len,
+				       const u8 *ie, size_t ie_len)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct ieee80211_hdr_3addr *hdr;
+	struct sk_buff *skb;
+	size_t ie_ssid_len;
+	u8 *pos;
+
+	sdata = vif_to_sdata(vif);
+	local = sdata->local;
+	ie_ssid_len = 2 + ssid_len;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*hdr) +
+			    ie_ssid_len + ie_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
+		       "request template\n", sdata->name);
+		return NULL;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	hdr = (struct ieee80211_hdr_3addr *) skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					 IEEE80211_STYPE_PROBE_REQ);
+	memset(hdr->addr1, 0xff, ETH_ALEN);
+	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
+	memset(hdr->addr3, 0xff, ETH_ALEN);
+
+	pos = skb_put(skb, ie_ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ssid_len;
+	if (ssid)
+		memcpy(pos, ssid, ssid_len);
+	pos += ssid_len;
+
+	if (ie) {
+		pos = skb_put(skb, ie_len);
+		memcpy(pos, ie, ie_len);
+	}
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_probereq_get);
+
 void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_info *frame_txctl,

