Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541AbXKJBU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 20:20:26 -0500
Subject: [RFC v2] b43: fix multi MAC address hardware crypto support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194605606.4793.94.camel@johannes.berg> (sfid-20071109_121118_199355_3D5C7183)
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605606.4793.94.camel@johannes.berg>
	 (sfid-20071109_121118_199355_3D5C7183)
Content-Type: text/plain
Date: Sat, 10 Nov 2007 02:21:47 +0100
Message-Id: <1194657707.7258.5.camel@johannes.berg> (sfid-20071110_012028_857753_9040D416)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once mac80211 will be able to have the same station associated
to different virtual interfaces (no matter whether as AP or as
station), we may get into trouble with the hardware encryption
offload RX path because we might have the same peer more than
once and hence the RX path doesn't know which key to use. For
this rare case, we disable the hardware RX path.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixes two NULL pointer dereferences and the mutex lock thing. No way to
actually test it until I patch mac80211 to support associating to the
same AP with two virtual interfaces...

 drivers/net/wireless/b43/b43.h  |    3 -
 drivers/net/wireless/b43/main.c |   81 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 3 deletions(-)

--- everything.orig/drivers/net/wireless/b43/main.c	2007-11-10 02:12:20.959959690 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-11-10 02:14:26.719963486 +0100
@@ -792,6 +792,8 @@ static int b43_key_write(struct b43_wlde
 {
 	int i;
 	int sta_keys_start;
+	static const u8 zero_mac[ETH_ALEN] = { 0 };
+	const u8 *orig_mac = mac_addr;
 
 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
@@ -806,6 +808,22 @@ static int b43_key_write(struct b43_wlde
 			sta_keys_start = 4;
 		else
 			sta_keys_start = 8;
+		/*
+		 * Check if we already have this MAC address. If so, we're
+		 * adding a key for the second station (the in-hardware mac
+		 * address for the first has already been cleared) and thus
+		 * may not write the address to the hardware.
+		 */
+		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+			if (!mac_addr)
+				break;
+			if (!dev->key[i].keyconf)
+				continue;
+			if (!compare_ether_addr(mac_addr, dev->key[i].mac)) {
+				mac_addr = zero_mac;
+				break;
+			}
+		}
 		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
 			if (!dev->key[i].keyconf) {
 				/* found empty */
@@ -828,6 +846,10 @@ static int b43_key_write(struct b43_wlde
 	}
 	keyconf->hw_key_idx = index;
 	dev->key[index].keyconf = keyconf;
+	if (orig_mac)
+		memcpy(dev->key[index].mac, orig_mac, ETH_ALEN);
+	else
+		memset(dev->key[index].mac, 0xFF, ETH_ALEN);
 
 	return 0;
 }
@@ -2894,8 +2916,13 @@ static int b43_op_set_key(struct ieee802
 		if (err)
 			goto out_unlock;
 
-		if (algorithm == B43_SEC_ALGO_WEP40 ||
-		    algorithm == B43_SEC_ALGO_WEP104) {
+		/*
+		 * The USE DEFAULT KEYS bit may never be set when we have
+		 * multiple interfaces.
+		 */
+		if ((wl->if_count < 2) &&
+		    (algorithm == B43_SEC_ALGO_WEP40 ||
+		     algorithm == B43_SEC_ALGO_WEP104)) {
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_USEDEFKEYS);
 		} else {
 			b43_hf_write(dev,
@@ -2924,6 +2951,55 @@ out_unlock:
 	return err;
 }
 
+static void b43_op_sta_notify(struct ieee80211_hw *hw, int if_id,
+			      enum sta_notify_cmd cmd, const u8 *addr)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+	unsigned long flags;
+	int sta_keys_start, i;
+	DECLARE_MAC_BUF(mbuf);
+
+	/*
+	 * NB: This function relies (for correctness) on the fact that
+	 *     sta_notify() is always called before set_key() for any
+	 *     given station.
+	 */
+
+	/*
+	 * For now, don't add back a STA to the RX key matching
+	 * when it is removed from the second virtual interface.
+	 */
+	if (cmd != STA_NOTIFY_ADD)
+		return;
+
+	/* can't lock mutex here */
+	spin_lock_irqsave(&wl->irq_lock, flags);
+
+	dev = wl->current_dev;
+
+	if (b43_new_kidx_api(dev))
+		sta_keys_start = 4;
+	else
+		sta_keys_start = 8;
+	for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+		if (!dev->key[i].keyconf)
+			continue;
+		if (compare_ether_addr(dev->key[i].mac, addr) == 0) {
+			/*
+			 * Found the same address as is being added,
+			 * so we cannot use hardware crypto for the RX
+			 * path any more.
+			 */
+			keymac_write(dev, i, NULL);
+			b43dbg(wl, "Removed %s from key matching.\n",
+			       print_mac(mbuf, addr));
+		}
+	}
+
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+}
+
 static void b43_op_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed, unsigned int *fflags,
 				    int mc_count, struct dev_addr_list *mc_list)
@@ -3694,6 +3770,7 @@ static const struct ieee80211_ops b43_hw
 	.config_interface	= b43_op_config_interface,
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,
+	.sta_notify		= b43_op_sta_notify,
 	.get_stats		= b43_op_get_stats,
 	.get_tx_stats		= b43_op_get_tx_stats,
 	.start			= b43_op_start,
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-11-09 22:54:31.489965385 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-11-10 02:14:26.719963486 +0100
@@ -582,10 +582,11 @@ struct b43_stats {
 
 struct b43_key {
 	/* If keyconf is NULL, this key is disabled.
-	 * keyconf is a cookie. Don't derefenrence it outside of the set_key
+	 * keyconf is a cookie. Don't dereference it outside of the set_key
 	 * path, because b43 doesn't own it. */
 	struct ieee80211_key_conf *keyconf;
 	u8 algorithm;
+	u8 mac[ETH_ALEN];
 };
 
 struct b43_wldev;


