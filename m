Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:47691 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZGGRIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 13:08:12 -0400
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RESEND][PATCH] p54: re-enable power save feature
Cc: "John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@web.de>
Date: Tue, 7 Jul 2009 19:08:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907071908.07983.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch re-enables p54's power save features and adds a workaround
which temporarily alters the device's power state in order to allow
ps-polls to be sent and buffered data to be retrieved during psm.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 178efbc..9bff43d 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -584,7 +584,8 @@ int p54_set_ps(struct p54_common *priv)
 	unsigned int i;
 	u16 mode;
 
-	if (priv->hw->conf.flags & IEEE80211_CONF_PS)
+	if (priv->hw->conf.flags & IEEE80211_CONF_PS &&
+	    !priv->powersave_override)
 		mode = P54_PSM | P54_PSM_BEACON_TIMEOUT | P54_PSM_DTIM |
 		       P54_PSM_CHECKSUM | P54_PSM_MCBC;
 	else
@@ -606,8 +607,8 @@ int p54_set_ps(struct p54_common *priv)
 
 	psm->beacon_rssi_skip_max = 200;
 	psm->rssi_delta_threshold = 0;
-	psm->nr = 10;
-	psm->exclude[0] = 0;
+	psm->nr = 1;
+	psm->exclude[0] = WLAN_EID_TIM;
 
 	p54_tx(priv, skb);
 	return 0;
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index 0496cff..af35cfc 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -548,4 +548,7 @@ int p54_upload_key(struct p54_common *priv, u8 algo, int slot,
 int p54_download_eeprom(struct p54_common *priv, void *buf,
 			u16 offset, u16 len);
 
+/* utility */
+u8 *p54_find_ie(struct sk_buff *skb, u8 ie);
+
 #endif /* LMAC_H */
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index f9b4f6a..42abf34 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -65,51 +65,64 @@ static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
 	return p54_update_beacon_tim(priv, sta->aid, set);
 }
 
-static int p54_beacon_format_ie_tim(struct sk_buff *skb)
+u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
 {
-	/*
-	 * the good excuse for this mess is ... the firmware.
-	 * The dummy TIM MUST be at the end of the beacon frame,
-	 * because it'll be overwritten!
-	 */
-
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	u8 *pos, *end;
 
 	if (skb->len <= sizeof(mgmt))
-		return -EINVAL;
+		return NULL;
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = skb->data + skb->len;
 	while (pos < end) {
 		if (pos + 2 + pos[1] > end)
-			return -EINVAL;
+			return NULL;
 
-		if (pos[0] == WLAN_EID_TIM) {
-			u8 dtim_len = pos[1];
-			u8 dtim_period = pos[3];
-			u8 *next = pos + 2 + dtim_len;
+		if (pos[0] == ie)
+			return pos;
 
-			if (dtim_len < 3)
-				return -EINVAL;
+		pos += 2 + pos[1];
+	}
+	return NULL;
+}
 
-			memmove(pos, next, end - next);
+static int p54_beacon_format_ie_tim(struct sk_buff *skb)
+{
+	/*
+	 * the good excuse for this mess is ... the firmware.
+	 * The dummy TIM MUST be at the end of the beacon frame,
+	 * because it'll be overwritten!
+	 */
+	u8 *tim;
+	u8 dtim_len;
+	u8 dtim_period;
+	u8 *next;
 
-			if (dtim_len > 3)
-				skb_trim(skb, skb->len - (dtim_len - 3));
+	tim = p54_find_ie(skb, WLAN_EID_TIM);
+	if (!tim)
+		return 0;
 
-			pos = end - (dtim_len + 2);
+	dtim_len = tim[1];
+	dtim_period = tim[3];
+	next = tim + 2 + dtim_len;
 
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
+	if (dtim_len < 3)
+		return -EINVAL;
+
+	memmove(tim, next, skb_tail_pointer(skb) - next);
+
+	if (dtim_len > 3)
+		skb_trim(skb, skb->len - (dtim_len - 3));
+
+	tim = skb_tail_pointer(skb) - (dtim_len + 2);
+
+	/* add the dummy at the end */
+	tim[0] = WLAN_EID_TIM;
+	tim[1] = 3;
+	tim[2] = 0;
+	tim[3] = dtim_period;
+	tim[4] = 0;
 	return 0;
 }
 
@@ -384,6 +397,9 @@ static void p54_bss_info_changed(struct ieee80211_hw *dev,
 			priv->wakeup_timer = info->beacon_int *
 					     info->dtim_period * 5;
 			p54_setup_mac(priv);
+		} else {
+			priv->wakeup_timer = 500;
+			priv->aid = 0;
 		}
 	}
 
@@ -517,6 +533,9 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	skb_queue_head_init(&priv->tx_pending);
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
+		     IEEE80211_HW_SUPPORTS_PS |
+		     IEEE80211_HW_PS_NULLFUNC_STACK |
+		     IEEE80211_HW_BEACON_FILTER |
 		     IEEE80211_HW_NOISE_DBM;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 19d085c..6772ed5 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -208,6 +208,7 @@ struct p54_common {
 	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
 	u16 aid;
+	bool powersave_override;
 	__le32 beacon_req_id;
 
 	/* cryptographic engine information */
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 31fda17..ea074a6 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -285,6 +285,45 @@ static int p54_rssi_to_dbm(struct p54_common *priv, int rssi)
 			 priv->rssical_db[band].add) / 4;
 }
 
+/*
+ * Even if the firmware is capable of dealing with incoming traffic,
+ * while dozing, we have to prepared in case mac80211 uses PS-POLL
+ * to retrieve outstanding frames from our AP.
+ * (see comment in net/mac80211/mlme.c @ line 1993)
+ */
+static void p54_pspoll_workaround(struct p54_common *priv, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ieee80211_tim_ie *tim_ie;
+	u8 *tim;
+	u8 tim_len;
+	bool new_psm;
+
+	/* only beacons have a TIM IE */
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	if (!priv->aid)
+		return;
+
+	/* only consider beacons from the associated BSSID */
+	if (compare_ether_addr(hdr->addr3, priv->bssid))
+		return;
+
+	tim = p54_find_ie(skb, WLAN_EID_TIM);
+	if (!tim)
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	new_psm = ieee80211_check_tim(tim_ie, tim_len, priv->aid);
+	if (new_psm != priv->powersave_override) {
+		priv->powersave_override = new_psm;
+		p54_set_ps(priv);
+	}
+}
+
 static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 {
 	struct p54_rx_data *hdr = (struct p54_rx_data *) skb->data;
@@ -337,6 +376,9 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
+	if (unlikely(priv->hw->conf.flags & IEEE80211_CONF_PS))
+		p54_pspoll_workaround(priv, skb);
+
 	ieee80211_rx_irqsafe(priv->hw, skb);
 
 	queue_delayed_work(priv->hw->workqueue, &priv->work,
