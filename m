Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1JLP20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 11:28:26 -0400
Subject: [PATCH] mac80211: reformat TX unauthorised check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 17:28:21 +0200
Message-ID: <1318433301.3933.42.camel@jlt3.sipsolutions.net> (sfid-20111012_172829_798922_6BF3EFEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reformat the check, the indentation is completely strange.
Also change the last part of the condition to make the
code shorter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Yes, it runs a bit over 80 cols but is easier to read than broken up.

 net/mac80211/tx.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/mac80211/tx.c	2011-10-12 17:11:32.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-12 17:27:00.000000000 +0200
@@ -1896,11 +1896,10 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
 	 */
-	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
-		unlikely(!is_multicast_ether_addr(hdr.addr1) && !authorized &&
-		      !(cpu_to_be16(ethertype) == sdata->control_port_protocol &&
-		       compare_ether_addr(sdata->vif.addr,
-					  skb->data + ETH_ALEN) == 0))) {
+	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
+		     !is_multicast_ether_addr(hdr.addr1) && !authorized &&
+		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
+		      compare_ether_addr(sdata->vif.addr, skb->data + ETH_ALEN)))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: dropped frame to %pM"


