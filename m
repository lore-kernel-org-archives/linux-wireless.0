Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cooperlighting-sw.cooperlighting.com ([216.130.131.68]:58337
	"EHLO cooperlighting-sw.cooperlighting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab3CRGCe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 02:02:34 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: Many 4 address mode stations
Date: Mon, 18 Mar 2013 13:51:59 +0800
Message-ID: <475A4E02EFF4724A9E58F55A56AC131607C46A1F@APEVS1.ap.ci.root> (sfid-20130318_070238_012272_5621B398)
From: "Wright, Brett" <Brett.Wright@cooperindustries.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

When we have 4 address mode stations connecting to an AP, mac80211
creates a separate virtual interface of type NL80211_IFTYPE_AP_VLAN at
the Access Point for each and every 4 address mode client that connects
to it. I guess the reason why this happens is so that each of these
interfaces is a separate port on a bridge with the AP interface, so that
the bridge can do the work of learning which devices (i.e. mac
addresses) are behind which remote station.

My problem is that we have a situation where many stations in 4 address
mode are connected to the AP. So, for example, I have 64 such stations
connected to a single AP. This means that there are 64 x
NL80211_IFTYPE_AP_VLAN interfaces created at the AP, and each added on a
separate port on a bridge that also has the AP interface.

To cut a long story short, the issue I have no is that any broadcast
traffic (or in fact any frames the bridge decides to flood) is copied to
each port on the bridge. So in the case of my example above with 64
remote stations, a single arp request is sent out as 65 separate
transmissions on the wireless network.

My problem is that this is terribly inefficient and slows the whole
wireless network down substantially for any such traffic. The
alternative is obviously not to create the NL80211_IFTYPE_AP_VLAN
interfaces for 4 address mode clients, but then the forwarding database
(or equivalent of) would then have to be managed by mac80211 much like
madwifi used to do. I can also think of some other solutions where the
NL80211_IFTYPE_AP_VLAN interfaces could still be used but would still
need to modify both mac80211 and possibly bridging also.

Has anyone thought about this issue or have any suggestions when lots of
4 address mode stations are used?

Thanks
Brett
