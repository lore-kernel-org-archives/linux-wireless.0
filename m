Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXLLRSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:18:18 -0500
Subject: [PATCH] mac80211: fix header ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 16:31:52 +0100
Message-Id: <1197473512.6558.96.camel@johannes.berg> (sfid-20071212_171820_772036_BC82965B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using recvfrom() on a SOCK_DGRAM packet socket, I noticed that the MAC
address passed back for wireless frames was always completely wrong. The
reason for this is that the header parse function assigned to our virtual
interfaces is a function parsing an 802.11 rather than 802.3 header. This
patch fixes it by keeping the default ethernet header operations assigned.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I think this should go into 2.6.24. I have no idea what broke this or if
it has been wrong forever... However, my eapol stuff relies on this fix.

There is one small problem with this: monitor interfaces are also set up
with this function but have 802.11 frame type. I have found that to not
matter but I'm not entirely sure. Does anybody think it does? In that
case I'll have to (re-)assign this conditionally when changing the
interface type.

 net/mac80211/ieee80211.c |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/net/mac80211/ieee80211.c	2007-12-12 16:24:31.929129394 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-12 16:25:23.609131835 +0100
@@ -449,7 +449,6 @@ static const struct header_ops ieee80211
 void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
-	dev->header_ops = &ieee80211_header_ops;
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->set_multicast_list = ieee80211_set_multicast_list;


