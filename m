Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52259 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0ACVRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 16:17:09 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 453AEEF417
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:57 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 337DC158A6E
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:56 +0200 (EET)
Subject: [PATCH 5/9] mac80211: use Probe Request template when sending a
	direct scan
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 03 Jan 2010 23:07:55 +0200
Message-ID: <20100103210755.29287.4242.stgit@tikku>
In-Reply-To: <20100103210552.29287.20384.stgit@tikku>
References: <20100103210552.29287.20384.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

As mac80211 now has a separate function for creating Probe Request templates,
better to use it when sending direct Probe Requests to an AP. Only the
bssid needs to be updated in the template before sending it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/util.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e38858..9713dcb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -989,37 +989,29 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200 +
-			    ie_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "request\n", sdata->name);
+	size_t buf_len;
+	u8 *buf;
+
+	/* FIXME: come up with a proper value */
+	buf = kmalloc(200 + ie_len, GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_DEBUG "%s: failed to allocate temporary IE "
+		       "buffer\n", sdata->name);
 		return;
 	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_PROBE_REQ);
-	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
+					   local->hw.conf.channel->band);
+
+	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
+				     ssid, ssid_len,
+				     buf, buf_len);
+
 	if (dst) {
+		mgmt = (struct ieee80211_mgmt *) skb->data;
 		memcpy(mgmt->da, dst, ETH_ALEN);
 		memcpy(mgmt->bssid, dst, ETH_ALEN);
-	} else {
-		memset(mgmt->da, 0xff, ETH_ALEN);
-		memset(mgmt->bssid, 0xff, ETH_ALEN);
 	}
-	pos = skb_put(skb, 2 + ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ssid_len;
-	memcpy(pos, ssid, ssid_len);
-	pos += ssid_len;
-
-	skb_put(skb, ieee80211_build_preq_ies(local, pos, ie, ie_len,
-					      local->hw.conf.channel->band));
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);

