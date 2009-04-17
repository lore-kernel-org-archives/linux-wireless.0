Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54234 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbZDQL5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 07:57:32 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54 problem with PS
Date: Fri, 17 Apr 2009 13:56:58 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
References: <1239823495.20927.1.camel@johannes.local> <200904162157.20576.chunkeey@web.de> <1239913104.26575.25.camel@johannes.local>
In-Reply-To: <1239913104.26575.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K6G6JdLjVCYEiUa"
Message-Id: <200904171356.58336.chunkeey@web.de> (sfid-20090417_135736_024791_EE50B564)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_K6G6JdLjVCYEiUa
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 16 April 2009 22:18:24 Johannes Berg wrote:
> 
> > Well, I guess I figured out what's wrong: the hw spec.
> > So this patch might work on PCI & USB, but could break SPI devices.
> 
> Heh.
> 
> > Johannes, can you please test the attached patch?
> > 

updated version.

--Boundary-00=_K6G6JdLjVCYEiUa
Content-Type: text/x-patch;
  charset="UTF-8";
  name="p54ps-3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54ps-3.diff"

diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 7fda1a9..1e999aa 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -181,6 +181,8 @@ struct p54_common {
 	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
 	u16 aid;
+	bool allow_ps_filtering;
+	unsigned long beacon_timeout_guard;
 	struct sk_buff *cached_beacon;
 
 	/* cryptographic engine information */
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 716c8a0..2c98904 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -739,6 +739,61 @@ static int p54_rssi_to_dbm(struct ieee80211_hw *dev, int rssi)
 			 priv->rssical_db[band].add) / 4;
 }
 
+static u8 *p54_find_ie_elem(u8 elem, u8 *ie, u8 *end)
+{
+	while (ie < end) {
+		if (ie + 2 + ie[1] > end)
+			return NULL;
+
+		if (ie[0] == elem)
+			return ie;
+
+		ie += 2 + ie[1];
+	}
+
+	return NULL;
+}
+
+static int p54_set_ps(struct ieee80211_hw *dev);
+
+static void p54_rx_ps_workaround(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_common *priv = dev->priv;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	struct ieee80211_tim_ie *tim;
+	u8 *pos, *end, *ie;
+
+	if (skb->len <= sizeof(mgmt))
+		return ;
+
+	if (!ieee80211_is_beacon(mgmt->frame_control))
+		return ;
+
+	if (compare_ether_addr(priv->bssid, mgmt->bssid))
+		return ;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = skb->data + skb->len;
+	ie = p54_find_ie_elem(WLAN_EID_TIM, pos, end);
+	if (!ie)
+		return ;
+
+	tim = (void *) &ie[2];
+	if (ieee80211_check_tim(tim, ie[1], priv->aid)) {
+		/*
+		 * disable powersave management, as long as
+		 * our TIM is set in the beacon
+		 * else we would miss PS-POLL frames
+		 */
+
+		priv->allow_ps_filtering = false;
+		p54_set_ps(dev);
+	} else {
+		priv->allow_ps_filtering = true;
+		p54_set_ps(dev);
+	}
+}
+
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -794,6 +846,10 @@ static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
 
+	/* workaround for checksumming bug */
+	if (unlikely(dev->conf.flags & IEEE80211_CONF_PS))
+		p54_rx_ps_workaround(dev, skb);
+
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
 	queue_delayed_work(dev->workqueue, &priv->work,
@@ -1076,7 +1132,11 @@ static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
 			wiphy_name(dev->wiphy), freq);
 		break;
 	case P54_TRAP_NO_BEACON:
-		if (priv->vif)
+		if (time_before(priv->beacon_timeout_guard, jiffies))
+			printk(KERN_INFO "Fake beacon loss\n");
+
+		if (time_after(priv->beacon_timeout_guard, jiffies) &&
+		    priv->vif)
 			ieee80211_beacon_loss(priv->vif);
 		break;
 	case P54_TRAP_SCAN:
@@ -1959,10 +2019,14 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 	u16 mode;
 	int i;
 
-	if (dev->conf.flags & IEEE80211_CONF_PS)
+	if (dev->conf.flags & IEEE80211_CONF_PS &&
+	    priv->allow_ps_filtering) {
 		mode = P54_PSM | P54_PSM_BEACON_TIMEOUT | P54_PSM_DTIM |
 		       P54_PSM_CHECKSUM | P54_PSM_MCBC;
-	else
+
+		priv->beacon_timeout_guard = jiffies + usecs_to_jiffies(
+			ieee80211_tu_to_usec(priv->hw->conf.beacon_int));
+	} else
 		mode = P54_PSM_CAM;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm),
@@ -1981,8 +2045,8 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 
 	psm->beacon_rssi_skip_max = 200;
 	psm->rssi_delta_threshold = 0;
-	psm->nr = 10;
-	psm->exclude[0] = 0;
+	psm->nr = 1;
+	psm->exclude[0] = WLAN_EID_TIM;
 
 	priv->tx(dev, skb);
 
@@ -1998,42 +2062,38 @@ static int p54_beacon_tim(struct sk_buff *skb)
 	 */
 
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
-	u8 *pos, *end;
+	u8 *pos, *end, *tim_ie, *next;
+	u8 dtim_period, dtim_len;
 
 	if (skb->len <= sizeof(mgmt))
 		return -EINVAL;
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = skb->data + skb->len;
-	while (pos < end) {
-		if (pos + 2 + pos[1] > end)
-			return -EINVAL;
+	tim_ie = p54_find_ie_elem(WLAN_EID_TIM, pos, end);
+	if (!tim_ie)
+		return 0;
 
-		if (pos[0] == WLAN_EID_TIM) {
-			u8 dtim_len = pos[1];
-			u8 dtim_period = pos[3];
-			u8 *next = pos + 2 + dtim_len;
+	if (tim_ie[1] < 3)
+		return -EINVAL;
 
-			if (dtim_len < 3)
-				return -EINVAL;
+	dtim_len = tim_ie[1];
+	dtim_period = tim_ie[3];
+	next = pos + 2 + dtim_len;
 
-			memmove(pos, next, end - next);
+	memmove(pos, next, end - next);
 
-			if (dtim_len > 3)
-				skb_trim(skb, skb->len - (dtim_len - 3));
+	if (dtim_len > 3)
+		skb_trim(skb, skb->len - (dtim_len - 3));
 
-			pos = end - (dtim_len + 2);
+	pos = end - (dtim_len + 2);
 
-			/* add the dummy at the end */
-			pos[0] = WLAN_EID_TIM;
-			pos[1] = 3;
-			pos[2] = 0;
-			pos[3] = dtim_period;
-			pos[4] = 0;
-			return 0;
-		}
-		pos += 2 + pos[1];
-	}
+	/* add the dummy at the end */
+	pos[0] = WLAN_EID_TIM;
+	pos[1] = 3;
+	pos[2] = 0;
+	pos[3] = dtim_period;
+	pos[4] = 0;
 	return 0;
 }
 
@@ -2093,6 +2153,8 @@ static int p54_start(struct ieee80211_hw *dev)
 
 	queue_delayed_work(dev->workqueue, &priv->work, 0);
 
+	priv->allow_ps_filtering = true;
+	priv->beacon_timeout_guard = jiffies;
 	priv->softled_state = 0;
 	err = p54_set_leds(dev);
 

--Boundary-00=_K6G6JdLjVCYEiUa--
