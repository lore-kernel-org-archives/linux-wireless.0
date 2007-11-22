Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXKVM4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:56:35 -0500
Subject: [RFC] mac80211: clean up 802.1X PAE receive handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 11:37:27 +0100
Message-Id: <1195727847.6323.73.camel@johannes.berg> (sfid-20071122_125657_847333_28C4C526)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Stephen, bridging is involved here, please help]

This cleans up the 802.1X PAE and EAPOL handling. After this patch
 * EAPOL frames addressed to us or the EAPOL group address are
   always accepted regardless of whether they are encrypted or not
 * other frames from a station are dropped if PAE is enabled and
   the station is not authorized
 * unencrypted frames (except the EAPOL frames above) are dropped if
   drop_unencrypted is enabled

This applies on top of Ron's "mac80211: restructuring data Rx handlers"
patch from Wed, 21 Nov 2007 10:46:59 +0200. I'll respin when he does.

I read some of 802.1X-2004 and 802.11-2007 to make sure I got the
semantics right. I finally understood the difference between the "eapol"
and "ieee802_1x" settings and got rid of the "eapol" setting :)

The "crosstalk" restriction of not bridging ethertype EAPOL frames
(incorrectly quoted in 802.11-2007 as being 802.1X-2004 C.1.1, it really
is C.3.3, could this be fixed?) is not addressed by this patch. It will
have to be added to the bridging code. The first point, however, limits
crosstalk to stations that have established an authorized port. Since we
abuse the same network interface to provide both the authorized and
unauthorized port I think this restriction makes sense.

Currently, an 802.1X implementation for wired networks would probably be
implemented by adding/removing ports to the (vlan) bridge as necessary.
I have not figured out how hostapd with the wired driver works yet
though. In any case, that would have the same crosstalk problem from
authorized ports until the bridging code implements the suggested
dropping of EAPOL ethertype frames.

I'll look into the bridging code to see what I can do about this, if I
can implement it there the checks here are no longer necessary.

This is the most consistent implementation I can come up with. It allows
to control the virtual port properly. Mind you, the problem I mentioned
in the other mail wrt. never setting drop_unencrypted sort of defeats
the whole thing.

Not-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c  |   27 ++++++++----------------
 net/mac80211/ieee80211_i.h     |   22 ++++++++------------
 net/mac80211/ieee80211_iface.c |    1 
 net/mac80211/rx.c              |   45 +++++++++++++++++++++++++----------------
 net/mac80211/tx.c              |    5 +---
 5 files changed, 48 insertions(+), 52 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2007-11-22 00:03:21.265882650 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-11-22 11:32:06.748682617 +0100
@@ -303,11 +303,11 @@ struct ieee80211_sub_if_data {
 	unsigned int flags;
 
 	int drop_unencrypted;
-	int eapol; /* 0 = process EAPOL frames as normal data frames,
-		    * 1 = send EAPOL frames through wlan#ap to hostapd
-		    *     (default) */
-	int ieee802_1x; /* IEEE 802.1X PAE - drop packet to/from unauthorized
-			 * port */
+	/*
+	 * IEEE 802.1X Port access control in effect,
+	 * drop packets to/from unauthorized port
+	 */
+	int ieee802_1x_pac;
 
 	u16 sequence;
 
@@ -336,8 +336,7 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *state;
 			struct dentry *bssid;
 			struct dentry *prev_bssid;
@@ -356,8 +355,7 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *num_sta_ps;
 			struct dentry *dtim_period;
 			struct dentry *dtim_count;
@@ -371,15 +369,13 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *peer;
 		} wds;
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 		} vlan;
 		struct {
 			struct dentry *mode;
--- everything.orig/net/mac80211/rx.c	2007-11-22 00:03:21.265882650 +0100
+++ everything/net/mac80211/rx.c	2007-11-22 11:34:59.788680881 +0100
@@ -957,18 +957,10 @@ ieee80211_rx_h_remove_qos_control(struct
 }
 
 static int
-ieee80211_drop_802_1x_pae(struct ieee80211_txrx_data *rx, int hdrlen)
+ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
 {
-	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb, hdrlen) &&
-	    rx->sdata->type != IEEE80211_IF_TYPE_STA &&
-	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return 0;
-
-	if (unlikely(rx->sdata->ieee802_1x &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)) &&
-		     !ieee80211_is_eapol(rx->skb, hdrlen))) {
+	if (unlikely(rx->sdata->ieee802_1x_pac &&
+		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)))) {
 #ifdef CONFIG_MAC80211_DEBUG
 		printk(KERN_DEBUG "%s: dropped frame "
 		       "(unauthorized port)\n", rx->dev->name);
@@ -980,7 +972,7 @@ ieee80211_drop_802_1x_pae(struct ieee802
 }
 
 static int
-ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx, int hdrlen)
+ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx)
 {
 	/*
 	 * Pass through unencrypted frames if the hardware has
@@ -993,9 +985,7 @@ ieee80211_drop_unencrypted(struct ieee80
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     rx->sdata->drop_unencrypted &&
-		     (!rx->sdata->eapol ||
-		      !ieee80211_is_eapol(rx->skb, hdrlen)))) {
+		     rx->sdata->drop_unencrypted)) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
 			       "encryption\n", rx->dev->name);
@@ -1133,6 +1123,28 @@ ieee80211_data_to_8023(struct ieee80211_
 	return 0;
 }
 
+static bool ieee80211_frame_allowed(struct ieee80211_txrx_data *rx)
+{
+	static const u8 pae_group_addr[ETH_ALEN]
+		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
+	struct ethhdr *ehdr = (struct ethhdr *)rx->skb->data;
+
+	/*
+	 * We always allow EAPOL frames that are addressed to us or the
+	 * PAE group address. Such frames will not be bridged.
+	 */
+	if (ieee80211_is_eapol(rx->skb, sizeof(struct ethhdr)) &&
+	    (compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0 ||
+	     compare_ether_addr(ehdr->h_dest, rx->dev->dev_addr) == 0))
+		return true;
+
+	if (ieee80211_802_1x_port_control(rx) ||
+	    ieee80211_drop_unencrypted(rx))
+		return false;
+
+	return true;
+}
+
 static ieee80211_txrx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
@@ -1151,8 +1163,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 	if (unlikely(err))
 		return TXRX_DROP;
 
-	if ((ieee80211_drop_802_1x_pae(rx, sizeof(struct ethhdr))) ||
-	    (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr))))
+	if (!ieee80211_frame_allowed(rx))
 		return TXRX_DROP;
 
 	skb = rx->skb;
--- everything.orig/net/mac80211/debugfs_netdev.c	2007-11-21 23:29:58.585858560 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2007-11-22 11:32:06.618682455 +0100
@@ -91,8 +91,7 @@ static const struct file_operations name
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
-IEEE80211_IF_FILE(eapol, eapol, DEC);
-IEEE80211_IF_FILE(ieee8021_x, ieee802_1x, DEC);
+IEEE80211_IF_FILE(ieee802_1x_pac, ieee802_1x_pac, DEC);
 
 /* STA/IBSS attributes */
 IEEE80211_IF_FILE(state, u.sta.state, DEC);
@@ -170,8 +169,7 @@ static void add_sta_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(eapol, sta);
-	DEBUGFS_ADD(ieee8021_x, sta);
+	DEBUGFS_ADD(ieee802_1x_pac, sta);
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
 	DEBUGFS_ADD(prev_bssid, sta);
@@ -192,8 +190,7 @@ static void add_ap_files(struct ieee8021
 {
 	DEBUGFS_ADD(channel_use, ap);
 	DEBUGFS_ADD(drop_unencrypted, ap);
-	DEBUGFS_ADD(eapol, ap);
-	DEBUGFS_ADD(ieee8021_x, ap);
+	DEBUGFS_ADD(ieee802_1x_pac, ap);
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_period, ap);
 	DEBUGFS_ADD(dtim_count, ap);
@@ -209,8 +206,7 @@ static void add_wds_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, wds);
 	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(eapol, wds);
-	DEBUGFS_ADD(ieee8021_x, wds);
+	DEBUGFS_ADD(ieee802_1x_pac, wds);
 	DEBUGFS_ADD(peer, wds);
 }
 
@@ -218,8 +214,7 @@ static void add_vlan_files(struct ieee80
 {
 	DEBUGFS_ADD(channel_use, vlan);
 	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(eapol, vlan);
-	DEBUGFS_ADD(ieee8021_x, vlan);
+	DEBUGFS_ADD(ieee802_1x_pac, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -263,8 +258,7 @@ static void del_sta_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, sta);
 	DEBUGFS_DEL(drop_unencrypted, sta);
-	DEBUGFS_DEL(eapol, sta);
-	DEBUGFS_DEL(ieee8021_x, sta);
+	DEBUGFS_DEL(ieee802_1x_pac, sta);
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
 	DEBUGFS_DEL(prev_bssid, sta);
@@ -285,8 +279,7 @@ static void del_ap_files(struct ieee8021
 {
 	DEBUGFS_DEL(channel_use, ap);
 	DEBUGFS_DEL(drop_unencrypted, ap);
-	DEBUGFS_DEL(eapol, ap);
-	DEBUGFS_DEL(ieee8021_x, ap);
+	DEBUGFS_DEL(ieee802_1x_pac, ap);
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_period, ap);
 	DEBUGFS_DEL(dtim_count, ap);
@@ -302,8 +295,7 @@ static void del_wds_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, wds);
 	DEBUGFS_DEL(drop_unencrypted, wds);
-	DEBUGFS_DEL(eapol, wds);
-	DEBUGFS_DEL(ieee8021_x, wds);
+	DEBUGFS_DEL(ieee802_1x_pac, wds);
 	DEBUGFS_DEL(peer, wds);
 }
 
@@ -311,8 +303,7 @@ static void del_vlan_files(struct ieee80
 {
 	DEBUGFS_DEL(channel_use, vlan);
 	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(eapol, vlan);
-	DEBUGFS_DEL(ieee8021_x, vlan);
+	DEBUGFS_DEL(ieee802_1x_pac, vlan);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-11-21 23:29:58.715859428 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-11-22 11:31:02.288685709 +0100
@@ -22,7 +22,6 @@ void ieee80211_if_sdata_init(struct ieee
 
 	/* Default values for sub-interface parameters */
 	sdata->drop_unencrypted = 0;
-	sdata->eapol = 1;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
 
--- everything.orig/net/mac80211/tx.c	2007-11-22 00:03:21.275867025 +0100
+++ everything/net/mac80211/tx.c	2007-11-22 11:32:07.188682128 +0100
@@ -261,7 +261,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 		return TXRX_CONTINUE;
 	}
 
-	if (unlikely(/* !injected && */ tx->sdata->ieee802_1x &&
+	if (unlikely(/* !injected && */ tx->sdata->ieee802_1x_pac &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		DECLARE_MAC_BUF(mac);
@@ -449,8 +449,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(tx->sdata->eapol &&
-		   ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc)))) {
+		 !ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
 	} else {


