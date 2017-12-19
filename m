Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36840 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934845AbdLSKFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 05:05:40 -0500
Message-ID: <1513677938.26145.12.camel@sipsolutions.net> (sfid-20171219_110547_565244_7607276C)
Subject: Re: oops on cloned-mac 802.11s stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Gui Iribarren <gui@altermundi.net>, linux-wireless@vger.kernel.org
Date: Tue, 19 Dec 2017 11:05:38 +0100
In-Reply-To: <39d50d91-ac83-611d-6709-021757686206@altermundi.net> (sfid-20171218_035222_838601_77D93FC5)
References: <39d50d91-ac83-611d-6709-021757686206@altermundi.net>
         (sfid-20171218_035222_838601_77D93FC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-18 at 03:44 +0100, Gui Iribarren wrote:
> Steps to reproduce:
> join a 802.11s mesh with a nodeA, and then join the same 802.11s mesh
> with another nodeB, so that both nodes MAC addresses are exactly the
> same (i.e. nodeB is "cloning" nodeA MAC)
> 
> Expected result:
> nodeA and nodeB coexist in a conflicting state, silently
> (not saying that this is a desired scenario, of course; just came across
> this while testing radios that accidentally had the same (fake) address.
> the warning might ring a bell to someone, so reporting it here just for
> the record)
> 
> What actually happens:
> both on nodeA and nodeB, the log is flooded with these warnings:

That's hardly an "oops", but yeah, not nice.

Somewhere we should drop packets if they appear to come from ourselves.
Perhaps like this:

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3cff69bfd66..fd580614085b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3625,6 +3625,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		}
 		return true;
 	case NL80211_IFTYPE_MESH_POINT:
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2))
+			return false;
 		if (multicast)
 			return true;
 		return ether_addr_equal(sdata->vif.addr, hdr->addr1);

johannes
