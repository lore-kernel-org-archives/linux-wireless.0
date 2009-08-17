Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56177 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZHQThj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 15:37:39 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFT/RFC] p54: fix broadcast buffering in AP mode
Date: Mon, 17 Aug 2009 21:24:14 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908172124.15399.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: fix PS-poll response race" somehow broke
broadcast buffering in a funny way.

During normal operation - stations are awake - the firmware refused
to transmit broadcast frames and reported P54_TX_PSM_CANCELLED.
But everything worked as soon as one station entered PSM.

The best explanation I could come up with is:
The stack sets IEEE80211_TX_CTL_SEND_AFTER_DTIM for outgoing
broadcast frames as soon as a station is marked as sleeping.
This flag triggers a path which will reroute these frames
into p54's "content after beacon" queue.

The most likely reason why this worked before is because mac80211
always sets IEEE80211_TX_CTL_CLEAR_PS_FILT flag for outgoing
broadcast frames. This once - before the PS-poll patch -
was used to signalize the firmware to overwrite the
ps canceling for this special frame.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index e7b9e9c..57a0ffd 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -283,7 +283,10 @@ int p54_sta_unlock(struct p54_common *priv, u8 *addr)
 		return -ENOMEM;
 
 	sta = (struct p54_sta_unlock *)skb_put(skb, sizeof(*sta));
-	memcpy(sta->addr, addr, ETH_ALEN);
+	if (addr)
+		memcpy(sta->addr, addr, ETH_ALEN);
+	else
+		memset(sta->addr, ~0, ETH_ALEN);
 	p54_tx(priv, skb);
 	return 0;
 }
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 77203e3..db415c2 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -38,20 +38,42 @@ static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta)
 {
 	struct p54_common *priv = dev->priv;
+	struct p54_sta_info *sta_info = (void *) sta->drv_priv;
+
 	switch (notify_cmd) {
 	case STA_NOTIFY_ADD:
 	case STA_NOTIFY_REMOVE:
+	case STA_NOTIFY_AWAKE:
 		/*
 		 * Notify the firmware that we don't want or we don't
 		 * need to buffer frames for this station anymore.
 		 */
 
 		p54_sta_unlock(priv, sta->addr);
+
+		if (sta_info->state & STA_DOZING) {
+			if (atomic_dec_and_test(&priv->num_sta_ps)) {
+				/*
+				 * The last station has woken up.
+				 *
+				 * Disable broadcast ps filter, which has
+				 * been secretly set by firmware.
+				 */
+
+				p54_sta_unlock(priv, NULL);
+			}
+		}
+
+		sta_info->state &= ~STA_DOZING;
 		break;
-	case STA_NOTIFY_AWAKE:
-		/* update the firmware's filter table */
-		p54_sta_unlock(priv, sta->addr);
+
+	case STA_NOTIFY_SLEEP:
+		if (!(sta_info->state & STA_DOZING))
+			atomic_inc(&priv->num_sta_ps);
+
+		sta_info->state |= STA_DOZING;
 		break;
+
 	default:
 		break;
 	}
@@ -185,6 +207,8 @@ static int p54_start(struct ieee80211_hw *dev)
 	priv->softled_state = 0;
 	err = p54_set_leds(priv);
 
+	atomic_set(&priv->num_sta_ps, 0);
+
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return err;
@@ -581,6 +605,8 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	 */
 	dev->wiphy->ps_default = false;
 
+	dev->sta_data_size = sizeof(struct p54_sta_info);
+
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);
 	init_completion(&priv->eeprom_comp);
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 1afc394..8cacb7a 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -228,6 +228,7 @@ struct p54_common {
 	/* statistics */
 	struct ieee80211_low_level_stats stats;
 	struct delayed_work work;
+	atomic_t num_sta_ps;
 
 	/* eeprom handling */
 	void *eeprom;
@@ -235,6 +236,14 @@ struct p54_common {
 	struct mutex eeprom_mutex;
 };
 
+enum p54_sta_state_t {
+	STA_DOZING	= BIT(0),
+};
+
+struct p54_sta_info {
+	enum p54_sta_state_t state;
+};
+
 /* interfaces for the drivers */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
 void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
---

Of course, instead of the big patch above we could restore the
original behavior with:

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 6fc0b61..b6dda2b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -623,6 +623,9 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
+	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+
 	*queue = skb_get_queue_mapping(skb) + P54_QUEUE_DATA;
 
 	switch (priv->mode) {
---

pools are open! Didn't have a chance to test them on real HW & setup.
Please report if these patches fix/break anything...

Regards,
   Chr
