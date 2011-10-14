Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1JNPMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:12:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1REjR2-0001OZ-W4
	for linux-wireless@vger.kernel.org; Fri, 14 Oct 2011 17:12:33 +0200
Message-Id: <20111014151150.110056640@sipsolutions.net> (sfid-20111014_171237_047731_BFB88234)
Date: Fri, 14 Oct 2011 17:11:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 01/12] mac80211: reformat TX unauthorised check
References: <20111014151119.246288840@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reformat the check, the indentation is completely strange.
Also change the last part of the condition to make the
code shorter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
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


