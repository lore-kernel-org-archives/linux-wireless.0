Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44222 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0EaV0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 17:26:20 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OJCUz-0007D5-6r
	for linux-wireless@vger.kernel.org; Mon, 31 May 2010 23:26:17 +0200
Received: from 56-47.dial.nortenet.pt ([212.13.56.47])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 23:26:17 +0200
Received: from subscriptions by 56-47.dial.nortenet.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 23:26:17 +0200
To: linux-wireless@vger.kernel.org
From: doddel <subscriptions@stroomer.com>
Subject: mac80211 rx.c: in recent builds bridging between stations associated to an AP does not work
Date: Mon, 31 May 2010 21:26:08 +0000 (UTC)
Message-ID: <loom.20100531T230843-554@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bridging used to work between stations associated to one AP with a compilation
of a Nov 2009; now it doesn't.
(using RouterStation platform with three radios and ath9k drivers,
compat-wireless of May 24 2010; routing between the radios works fine;
communication between stations via one AP does not work).

The only change I could find in the code that is relevant for this has been part
of patch "cfg80211: introduce capability for 4addr mode", and possibly earlier
changes to this piece of code related to 4addr:

@@ -1245,7 +1248,8 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
        if ((sdata->vif.type == NL80211_IFTYPE_AP ||
             sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
            !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-           (rx->flags & IEEE80211_RX_RA_MATCH) && !rx->sdata->use_4addr) {
+           (rx->flags & IEEE80211_RX_RA_MATCH) &&
+           (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
                if (is_multicast_ether_addr(ehdr->h_dest)) {
                        /*
                         * send multicast frames both to higher layers in 

Once I force a station to do a SNAT action on its wireless, pretending that the
packets stem from another subnet than the actual subnet of the wireless, the
communication is reestablished if the AP and other station know how to route
answers back to this modified subnet.

Somehow in these tests above a false is produced where a true is needed in a
basic setup (legacy 11a, one AP with multiple stations).


