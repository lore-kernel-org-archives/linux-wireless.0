Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2K2MRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:17:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: remove probe response temporary buffer allocation
Date: Thu, 29 Nov 2012 13:17:36 +0100
Message-Id: <1354191456-29577-3-git-send-email-johannes@sipsolutions.net> (sfid-20121129_131724_561255_2181E152)
In-Reply-To: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net>
References: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of allocating a temporary buffer to build IEs
build them right into the SKB.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  7 ++++++-
 drivers/net/wireless/ti/wl1251/main.c |  4 +++-
 drivers/net/wireless/ti/wlcore/cmd.c  |  4 +++-
 include/net/mac80211.h                |  5 ++---
 net/mac80211/tx.c                     |  9 ++-------
 net/mac80211/util.c                   | 26 +++++++++-----------------
 6 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2aa8a1a..8a61dbd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1347,9 +1347,14 @@ static void hw_scan_work(struct work_struct *work)
 						       hwsim->hw_scan_vif,
 						       req->ssids[i].ssid,
 						       req->ssids[i].ssid_len,
-						       req->ie, req->ie_len);
+						       req->ie_len);
 			if (!probe)
 				continue;
+
+			if (req->ie_len)
+				memcpy(skb_put(probe, req->ie_len), req->ie,
+				       req->ie_len);
+
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 441cbcc..f47e8b0 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -896,11 +896,13 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
-				     req->ie, req->ie_len);
+				     req->ie_len);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto out;
 	}
+	if (req->ie_len)
+		memcpy(skb_put(skb, req->ie_len), req->ie, req->ie_len);
 
 	ret = wl1251_cmd_template_set(wl, CMD_PROBE_REQ, skb->data,
 				      skb->len);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index eaef3f4..27f83f7 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1038,11 +1038,13 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	u16 template_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 
 	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
-				     ie, ie_len);
+				     ie_len);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto out;
 	}
+	if (ie_len)
+		memcpy(skb_put(skb, ie_len), ie, ie_len);
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e806f1d..0472d80 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3144,8 +3144,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @ssid: SSID buffer
  * @ssid_len: length of SSID
- * @ie: buffer containing all IEs except SSID for the template
- * @ie_len: length of the IE buffer
+ * @tailroom: tailroom to reserve at end of SKB for IEs
  *
  * Creates a Probe Request template which can, for example, be uploaded to
  * hardware.
@@ -3153,7 +3152,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       const u8 *ssid, size_t ssid_len,
-				       const u8 *ie, size_t ie_len);
+				       size_t tailroom);
 
 /**
  * ieee80211_rts_get - RTS frame generation function
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d8ef341..ba1ac9d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2620,7 +2620,7 @@ EXPORT_SYMBOL(ieee80211_nullfunc_get);
 struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       const u8 *ssid, size_t ssid_len,
-				       const u8 *ie, size_t ie_len)
+				       size_t tailroom)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local;
@@ -2634,7 +2634,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 	ie_ssid_len = 2 + ssid_len;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*hdr) +
-			    ie_ssid_len + ie_len);
+			    ie_ssid_len + tailroom);
 	if (!skb)
 		return NULL;
 
@@ -2655,11 +2655,6 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 		memcpy(pos, ssid, ssid_len);
 	pos += ssid_len;
 
-	if (ie) {
-		pos = skb_put(skb, ie_len);
-		memcpy(pos, ie, ie_len);
-	}
-
 	return skb;
 }
 EXPORT_SYMBOL(ieee80211_probereq_get);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 602fc44..14dc0da 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1246,14 +1246,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	size_t buf_len;
-	u8 *buf;
 	u8 chan_no;
-
-	/* FIXME: come up with a proper value */
-	buf = kmalloc(200 + ie_len, GFP_KERNEL);
-	if (!buf)
-		return NULL;
+	int ies_len;
 
 	/*
 	 * Do not send DS Channel parameter for directed probe requests
@@ -1265,15 +1259,16 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	else
 		chan_no = ieee80211_frequency_to_channel(chan->center_freq);
 
-	buf_len = ieee80211_build_preq_ies(local, buf, 200 + ie_len,
-					   ie, ie_len, chan->band,
-					   ratemask, chan_no);
-
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
-				     ssid, ssid_len,
-				     buf, buf_len);
+				     ssid, ssid_len, 100 + ie_len);
 	if (!skb)
-		goto out;
+		return NULL;
+
+	ies_len = ieee80211_build_preq_ies(local, skb_tail_pointer(skb),
+					   skb_tailroom(skb),
+					   ie, ie_len, chan->band,
+					   ratemask, chan_no);
+	skb_put(skb, ies_len);
 
 	if (dst) {
 		mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -1283,9 +1278,6 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
- out:
-	kfree(buf);
-
 	return skb;
 }
 
-- 
1.8.0

