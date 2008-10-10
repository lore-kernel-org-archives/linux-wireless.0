Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbYJJN1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 09:27:37 -0400
Subject: [PATCH] mac80211: provide sequence numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 13:21:59 +0200
Message-Id: <1223637719.17594.6.camel@johannes.berg> (sfid-20081010_152741_857511_EFCB70F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've come to think that not providing sequence numbers for
the normal STA mode case was a mistake, at least two drivers
now had to implement code they wouldn't otherwise need, and
I believe at76_usb and adm8211 might be broken.

This patch makes mac80211 assign a sequence number to all
those frames that need one except beacons. That means that
if a driver only implements modes that do not do beaconing
it need not worry about the sequence number.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54/p54.h       |    1 -
 drivers/net/wireless/p54/p54common.c |   18 +++++-------------
 drivers/net/wireless/rtl8187.h       |    1 -
 drivers/net/wireless/rtl8187_dev.c   |   18 ++++--------------
 net/mac80211/ieee80211_i.h           |    2 ++
 net/mac80211/tx.c                    |   10 ++++++++++
 6 files changed, 21 insertions(+), 29 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-10-10 13:06:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-10-10 13:07:32.000000000 +0200
@@ -438,6 +438,8 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
 	struct ieee80211_key *default_key;
 
+	u16 sequence_number;
+
 	/* BSS configuration for this interface. */
 	struct ieee80211_bss_conf bss_conf;
 
--- everything.orig/net/mac80211/tx.c	2008-10-10 13:06:06.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-10-10 13:09:22.000000000 +0200
@@ -602,8 +602,18 @@ ieee80211_tx_h_sequence(struct ieee80211
 	if (ieee80211_hdrlen(hdr->frame_control) < 24)
 		return TX_CONTINUE;
 
+	/*
+	 * Anything but QoS data that has a sequence number field
+	 * (is long enough) gets a sequence number from the global
+	 * counter.
+	 */
 	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+		/* driver should assign sequence number */
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+		/* for pure STA mode without beacons, we can do it */
+		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
+		tx->sdata->sequence_number += 0x10;
+		tx->sdata->sequence_number &= IEEE80211_SCTL_SEQ;
 		return TX_CONTINUE;
 	}
 
--- everything.orig/drivers/net/wireless/p54/p54.h	2008-10-10 13:10:14.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54.h	2008-10-10 13:10:16.000000000 +0200
@@ -67,7 +67,6 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
-	u16 seqno;
 	u16 rx_mtu;
 	u8 headroom;
 	u8 tailroom;
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-10-10 13:09:34.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-10-10 13:11:04.000000000 +0200
@@ -865,19 +865,6 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		txhdr->align[0] = padding;
 
-	/* FIXME: The sequence that follows is needed for this driver to
-	 * work with mac80211 since "mac80211: fix TX sequence numbers".
-	 * As with the temporary code in rt2x00, changes will be needed
-	 * to get proper sequence numbers on beacons. In addition, this
-	 * patch places the sequence number in the hardware state, which
-	 * limits us to a single virtual state.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
@@ -1391,6 +1378,11 @@ struct ieee80211_hw *p54_init_common(siz
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
+	/*
+	 * XXX: when this driver gets support for any mode that
+	 *	requires beacons (AP, MESH, IBSS) then it must
+	 *	implement IEEE80211_TX_CTL_ASSIGN_SEQ.
+	 */
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-10-10 13:11:45.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-10-10 13:14:07.000000000 +0200
@@ -238,20 +238,6 @@ static int rtl8187_tx(struct ieee80211_h
 			ep = epmap[skb_get_queue_mapping(skb)];
 	}
 
-	/* FIXME: The sequence that follows is needed for this driver to
-	 * work with mac80211 since "mac80211: fix TX sequence numbers".
-	 * As with the temporary code in rt2x00, changes will be needed
-	 * to get proper sequence numbers on beacons. In addition, this
-	 * patch places the sequence number in the hardware state, which
-	 * limits us to a single virtual state.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
-
 	info->driver_data[0] = dev;
 	info->driver_data[1] = urb;
 
@@ -1185,6 +1171,10 @@ static int __devinit rtl8187_probe(struc
 		dev->max_signal = 65;
 	}
 
+	/*
+	 * XXX: Once this driver supports anything that requires
+	 *	beacons it must implement IEEE80211_TX_CTL_ASSIGN_SEQ.
+	 */
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
--- everything.orig/drivers/net/wireless/rtl8187.h	2008-10-10 13:14:18.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187.h	2008-10-10 13:14:21.000000000 +0200
@@ -100,7 +100,6 @@ struct rtl8187_priv {
 	struct usb_device *udev;
 	u32 rx_conf;
 	u16 txpwr_base;
-	u16 seqno;
 	u8 asic_rev;
 	u8 is_rtl8187b;
 	enum {


