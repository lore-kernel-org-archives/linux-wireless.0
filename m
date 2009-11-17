Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZKQNqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 08:46:53 -0500
Subject: [RFC] mac80211: disallow bridging managed/adhoc interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 14:46:25 +0100
Message-ID: <1258465585.3682.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of people have tried to add a wireless interface
(in managed mode) to a bridge and then complained that it
doesn't work. It cannot work, however, because in 802.11
networks all packets need to be acknowledged and as such
need to be sent to the right address. Promiscuous doesn't
help here. The wireless address format used for these
links has only space for three addresses, the
 * transmitter, which must be equal to the sender (origin)
 * receiver (on the wireless medium), which is the AP in
   the case of managed mode
 * the recipient (destination), which is on the APs local
   network segment

In an IBSS, it is similar, but the receiver and recipient
must match and the third address is used as the BSSID.

To avoid such mistakes in the future, disallow adding a
wireless interface to a bridge.

Felix has recently added a four-address mode to the AP
and client side that can be used (after negotiating that
it is possible, which must happen out-of-band by setting
up both sides) for bridging, so allow that case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/if.h   |    1 +
 net/bridge/br_if.c   |    4 ++++
 net/mac80211/cfg.c   |    9 ++++++++-
 net/mac80211/iface.c |   17 +++++++++++++++--
 4 files changed, 28 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/linux/if.h	2009-11-17 14:18:36.000000000 +0100
+++ wireless-testing/include/linux/if.h	2009-11-17 14:19:04.000000000 +0100
@@ -70,6 +70,7 @@
 #define IFF_XMIT_DST_RELEASE 0x400	/* dev_hard_start_xmit() is allowed to
 					 * release skb->dst
 					 */
+#define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 
 #define IF_GET_IFACE	0x0001		/* for querying only */
 #define IF_GET_PROTO	0x0002
--- wireless-testing.orig/net/bridge/br_if.c	2009-11-17 14:19:17.000000000 +0100
+++ wireless-testing/net/bridge/br_if.c	2009-11-17 14:20:03.000000000 +0100
@@ -390,6 +390,10 @@ int br_add_if(struct net_bridge *br, str
 	if (dev->br_port != NULL)
 		return -EBUSY;
 
+	/* No bridging devices that dislike that (e.g. wireless) */
+	if (dev->priv_flags & IFF_DONT_BRIDGE)
+		return -EINVAL;
+
 	p = new_nbp(br, dev);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-17 14:21:24.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-17 14:37:13.000000000 +0100
@@ -106,8 +106,15 @@ static int ieee80211_change_iface(struct
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (params->use_4addr >= 0)
+	if (params->use_4addr >= 0) {
 		sdata->use_4addr = !!params->use_4addr;
+		sdata->dev->priv_flags &= ~IFF_DONT_BRIDGE;
+
+		if ((sdata->vif.type == NL80211_IFTYPE_STATION ||
+		     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
+		    !sdata->use_4addr)
+			sdata->dev->priv_flags |= IFF_DONT_BRIDGE;
+	}
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
 		return 0;
--- wireless-testing.orig/net/mac80211/iface.c	2009-11-17 14:20:19.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-11-17 14:33:25.000000000 +0100
@@ -769,6 +769,11 @@ int ieee80211_if_change_type(struct ieee
 			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
 	sdata->use_4addr = 0;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		sdata->dev->priv_flags |= IFF_DONT_BRIDGE;
+	else
+		sdata->dev->priv_flags &= ~IFF_DONT_BRIDGE;
 
 	return 0;
 }
@@ -843,8 +848,16 @@ int ieee80211_if_add(struct ieee80211_lo
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (params && params->use_4addr >= 0)
-		sdata->use_4addr = !!params->use_4addr;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		sdata->dev->priv_flags |= IFF_DONT_BRIDGE;
+	else
+		sdata->dev->priv_flags &= ~IFF_DONT_BRIDGE;
+
+	if (params && params->use_4addr > 0) {
+		sdata->use_4addr = true;
+		sdata->dev->priv_flags &= ~IFF_DONT_BRIDGE;
+	}
 
 	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);


