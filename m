Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab1JGME4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:04:56 -0400
Message-Id: <20111007120216.631884561@sipsolutions.net> (sfid-20111007_140459_317092_B4B58EDD)
Date: Fri, 07 Oct 2011 14:01:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211: optimise monitor xmit
References: <20111007120122.982757001@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the only way the interface can be a monitor
interface in ieee80211_xmit() is because the frame
came from ieee80211_monitor_start_xmit() we can
move all the code there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |  108 ++++++++++++++++++++++++------------------------------
 1 file changed, 49 insertions(+), 59 deletions(-)

--- a/net/mac80211/tx.c	2011-10-07 10:07:23.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 10:17:04.000000000 +0200
@@ -1539,55 +1539,11 @@ void ieee80211_xmit(struct ieee80211_sub
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *tmp_sdata;
 	int headroom;
 	bool may_encrypt;
 
 	rcu_read_lock();
 
-	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
-		int hdrlen;
-		u16 len_rthdr;
-
-		info->flags |= IEEE80211_TX_CTL_INJECTED |
-			       IEEE80211_TX_INTFL_HAS_RADIOTAP;
-
-		len_rthdr = ieee80211_get_radiotap_len(skb->data);
-		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
-		/* check the header is complete in the frame */
-		if (likely(skb->len >= len_rthdr + hdrlen)) {
-			/*
-			 * We process outgoing injected frames that have a
-			 * local address we handle as though they are our
-			 * own frames.
-			 * This code here isn't entirely correct, the local
-			 * MAC address is not necessarily enough to find
-			 * the interface to use; for that proper VLAN/WDS
-			 * support we will need a different mechanism.
-			 */
-
-			list_for_each_entry_rcu(tmp_sdata, &local->interfaces,
-						list) {
-				if (!ieee80211_sdata_running(tmp_sdata))
-					continue;
-				if (tmp_sdata->vif.type ==
-				    NL80211_IFTYPE_MONITOR ||
-				    tmp_sdata->vif.type ==
-				    NL80211_IFTYPE_AP_VLAN ||
-					tmp_sdata->vif.type ==
-				    NL80211_IFTYPE_WDS)
-					continue;
-				if (compare_ether_addr(tmp_sdata->vif.addr,
-						       hdr->addr2) == 0) {
-					sdata = tmp_sdata;
-					break;
-				}
-			}
-		}
-	}
-
 	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
 
 	headroom = local->tx_headroom;
@@ -1628,8 +1584,9 @@ netdev_tx_t ieee80211_monitor_start_xmit
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
 	u16 len_rthdr;
-	u8 *payload;
+	int hdrlen;
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1680,30 +1637,63 @@ netdev_tx_t ieee80211_monitor_start_xmit
 	skb_set_network_header(skb, len_rthdr);
 	skb_set_transport_header(skb, len_rthdr);
 
+	if (skb->len < len_rthdr + 2)
+		goto fail;
+
+	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (skb->len < len_rthdr + hdrlen)
+		goto fail;
+
 	/*
 	 * Initialize skb->protocol if the injected frame is a data frame
 	 * carrying a rfc1042 header
 	 */
-	if (skb->len > len_rthdr + 2) {
-		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-		if (ieee80211_is_data(hdr->frame_control) &&
-		    skb->len >= len_rthdr +
-				ieee80211_hdrlen(hdr->frame_control) +
-				sizeof(rfc1042_header) + 2) {
-			payload = (u8 *)hdr +
-				  ieee80211_hdrlen(hdr->frame_control);
-			if (compare_ether_addr(payload, rfc1042_header) == 0)
-				skb->protocol = cpu_to_be16((payload[6] << 8) |
-							    payload[7]);
-		}
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    skb->len >= len_rthdr + hdrlen + sizeof(rfc1042_header) + 2) {
+		u8 *payload = (u8 *)hdr + hdrlen;
+
+		if (compare_ether_addr(payload, rfc1042_header) == 0)
+			skb->protocol = cpu_to_be16((payload[6] << 8) |
+						    payload[7]);
 	}
 
 	memset(info, 0, sizeof(*info));
 
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+		      IEEE80211_TX_CTL_INJECTED |
+		      IEEE80211_TX_INTFL_HAS_RADIOTAP;
+
+	rcu_read_lock();
+
+	/*
+	 * We process outgoing injected frames that have a local address
+	 * we handle as though they are non-injected frames.
+	 * This code here isn't entirely correct, the local MAC address
+	 * isn't always enough to find the interface to use; for proper
+	 * VLAN/WDS support we will need a different mechanism (which
+	 * likely isn't going to be monitor interfaces).
+	 */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	list_for_each_entry_rcu(tmp_sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(tmp_sdata))
+			continue;
+		if (tmp_sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    tmp_sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    tmp_sdata->vif.type == NL80211_IFTYPE_WDS)
+			continue;
+		if (compare_ether_addr(tmp_sdata->vif.addr, hdr->addr2) == 0) {
+			sdata = tmp_sdata;
+			break;
+		}
+	}
 
 	/* pass the radiotap header up to xmit */
-	ieee80211_xmit(IEEE80211_DEV_TO_SUB_IF(dev), skb);
+	ieee80211_xmit(sdata, skb);
+	rcu_read_unlock();
+
 	return NETDEV_TX_OK;
 
 fail:


