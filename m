Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbZJ1JEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 05:04:04 -0400
Subject: [PATCH] mac80211: remove RX_FLAG_RADIOTAP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 10:03:35 +0100
Message-ID: <1256720615.4237.107.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While there may be a case for a driver adding its
own bits of radiotap information, none currently
does. Also, drivers would have to copy the code
to generate the radiotap bits that now mac80211
generates. If some driver in the future needs to
add some driver-specific information I'd expect
that to be in a radiotap vendor namespace and we
can add a different way of passing such data up
and having mac80211 include it.

Additionally, rename IEEE80211_CONF_RADIOTAP to
IEEE80211_CONF_MONITOR since it's still used by
b43(legacy) to obtain per-frame timestamps.

The purpose of this patch is to simplify the RX
code in mac80211 to make it easier to add paged
skb support.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c       |    2 +-
 drivers/net/wireless/b43legacy/main.c |    2 +-
 include/net/mac80211.h                |   15 +++++++--------
 net/mac80211/iface.c                  |    8 ++++----
 net/mac80211/rx.c                     |   33 ++++++++++++---------------------
 5 files changed, 25 insertions(+), 35 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-10-28 09:43:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-10-28 09:43:30.000000000 +0100
@@ -3573,7 +3573,7 @@ static int b43_op_config(struct ieee8021
 	if (conf->channel->hw_value != phy->channel)
 		b43_switch_channel(dev, conf->channel->hw_value);
 
-	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-10-28 09:43:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-10-28 09:43:35.000000000 +0100
@@ -2677,7 +2677,7 @@ static int b43legacy_op_dev_config(struc
 	if (conf->channel->hw_value != phy->channel)
 		b43legacy_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
-	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
--- wireless-testing.orig/include/net/mac80211.h	2009-10-28 09:41:17.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-10-28 09:44:19.000000000 +0100
@@ -494,7 +494,6 @@ ieee80211_tx_info_clear_status(struct ie
  * @RX_FLAG_MMIC_ERROR: Michael MIC error was reported on this frame.
  *	Use together with %RX_FLAG_MMIC_STRIPPED.
  * @RX_FLAG_DECRYPTED: This frame was decrypted in hardware.
- * @RX_FLAG_RADIOTAP: This frame starts with a radiotap header.
  * @RX_FLAG_MMIC_STRIPPED: the Michael MIC is stripped off this frame,
  *	verification has been done by the hardware.
  * @RX_FLAG_IV_STRIPPED: The IV/ICV are stripped from this frame.
@@ -515,7 +514,6 @@ ieee80211_tx_info_clear_status(struct ie
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
 	RX_FLAG_DECRYPTED	= 1<<1,
-	RX_FLAG_RADIOTAP	= 1<<2,
 	RX_FLAG_MMIC_STRIPPED	= 1<<3,
 	RX_FLAG_IV_STRIPPED	= 1<<4,
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
@@ -565,7 +563,9 @@ struct ieee80211_rx_status {
  *
  * Flags to define PHY configuration options
  *
- * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
+ * @IEEE80211_CONF_MONITOR: there's a monitor interface present -- use this
+ *	to determine for example whether to calculate timestamps for packets
+ *	or not, do not use instead of filter flags!
  * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only)
  * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
@@ -574,7 +574,7 @@ struct ieee80211_rx_status {
  *	it can also be unset in that case when monitor interfaces are active.
  */
 enum ieee80211_conf_flags {
-	IEEE80211_CONF_RADIOTAP		= (1<<0),
+	IEEE80211_CONF_MONITOR		= (1<<0),
 	IEEE80211_CONF_PS		= (1<<1),
 	IEEE80211_CONF_IDLE		= (1<<2),
 };
@@ -584,7 +584,7 @@ enum ieee80211_conf_flags {
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
- * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
+ * @IEEE80211_CONF_CHANGE_MONITOR: the monitor flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
@@ -593,7 +593,7 @@ enum ieee80211_conf_flags {
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
-	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
+	IEEE80211_CONF_CHANGE_MONITOR		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
 	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
@@ -1661,8 +1661,7 @@ void ieee80211_restart_hw(struct ieee802
  * ieee80211_rx - receive frame
  *
  * Use this function to hand received frames to mac80211. The receive
- * buffer in @skb must start with an IEEE 802.11 header or a radiotap
- * header if %RX_FLAG_RADIOTAP is set in the @status flags.
+ * buffer in @skb must start with an IEEE 802.11 header.
  *
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls to
--- wireless-testing.orig/net/mac80211/iface.c	2009-10-28 09:42:16.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-10-28 09:42:26.000000000 +0100
@@ -214,8 +214,8 @@ static int ieee80211_open(struct net_dev
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
 		if (local->monitors == 1) {
-			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-			hw_reconf_flags |= IEEE80211_CONF_CHANGE_RADIOTAP;
+			local->hw.conf.flags |= IEEE80211_CONF_MONITOR;
+			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 		}
 
 		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
@@ -435,8 +435,8 @@ static int ieee80211_stop(struct net_dev
 
 		local->monitors--;
 		if (local->monitors == 0) {
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
-			hw_reconf_flags |= IEEE80211_CONF_CHANGE_RADIOTAP;
+			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
+			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 		}
 
 		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
--- wireless-testing.orig/net/mac80211/rx.c	2009-10-28 09:44:36.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-10-28 09:46:28.000000000 +0100
@@ -39,11 +39,8 @@ static u8 ieee80211_sta_manage_reorder_b
  * only useful for monitoring.
  */
 static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
-					   struct sk_buff *skb,
-					   int rtap_len)
+					   struct sk_buff *skb)
 {
-	skb_pull(skb, rtap_len);
-
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
 		if (likely(skb->len > FCS_LEN))
 			skb_trim(skb, skb->len - FCS_LEN);
@@ -59,15 +56,14 @@ static struct sk_buff *remove_monitor_in
 }
 
 static inline int should_drop_frame(struct sk_buff *skb,
-				    int present_fcs_len,
-				    int radiotap_len)
+				    int present_fcs_len)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		return 1;
-	if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
+	if (unlikely(skb->len < 16 + present_fcs_len))
 		return 1;
 	if (ieee80211_is_ctl(hdr->frame_control) &&
 	    !ieee80211_is_pspoll(hdr->frame_control) &&
@@ -225,7 +221,6 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
-	int rtap_len = 0;
 
 	/*
 	 * First, we may need to make a copy of the skb because
@@ -235,25 +230,23 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	 * We don't need to, of course, if we aren't going to return
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
-	if (status->flag & RX_FLAG_RADIOTAP)
-		rtap_len = ieee80211_get_radiotap_len(origskb->data);
-	else
-		/* room for the radiotap header based on driver features */
-		needed_headroom = ieee80211_rx_radiotap_len(local, status);
+
+	/* room for the radiotap header based on driver features */
+	needed_headroom = ieee80211_rx_radiotap_len(local, status);
 
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
 	if (!local->monitors) {
-		if (should_drop_frame(origskb, present_fcs_len, rtap_len)) {
+		if (should_drop_frame(origskb, present_fcs_len)) {
 			dev_kfree_skb(origskb);
 			return NULL;
 		}
 
-		return remove_monitor_info(local, origskb, rtap_len);
+		return remove_monitor_info(local, origskb);
 	}
 
-	if (should_drop_frame(origskb, present_fcs_len, rtap_len)) {
+	if (should_drop_frame(origskb, present_fcs_len)) {
 		/* only need to expand headroom if necessary */
 		skb = origskb;
 		origskb = NULL;
@@ -277,16 +270,14 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		 */
 		skb = skb_copy_expand(origskb, needed_headroom, 0, GFP_ATOMIC);
 
-		origskb = remove_monitor_info(local, origskb, rtap_len);
+		origskb = remove_monitor_info(local, origskb);
 
 		if (!skb)
 			return origskb;
 	}
 
-	/* if necessary, prepend radiotap information */
-	if (!(status->flag & RX_FLAG_RADIOTAP))
-		ieee80211_add_rx_radiotap_header(local, skb, rate,
-						 needed_headroom);
+	/* prepend radiotap information */
+	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom);
 
 	skb_reset_mac_header(skb);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;


