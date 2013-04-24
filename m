Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50111 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab3DXLMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 07:12:52 -0400
Message-ID: <1366801969.21854.1.camel@jlt4.sipsolutions.net> (sfid-20130424_131255_550188_0AC7588B)
Subject: Re: Question on ieee80211_tx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 24 Apr 2013 13:12:49 +0200
In-Reply-To: <5176DD33.9000100@candelatech.com> (sfid-20130423_233115_840840_D02CAECE)
References: <5176DD33.9000100@candelatech.com>
	 (sfid-20130423_233115_840840_D02CAECE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 12:12 -0700, Ben Greear wrote:
> It appears that ieee80211_tx_status also scales poorly
> when using large numbers of virtual stations connected
> to a single AP, due to for_each_sta_info(local, hdr->addr1, sta, tmp)...
> 
> I'm going to try using the vif-hashing to make this faster,
> but first a question:
> 
> Since it matches on MAC addresses, should it
> just return at the bottom of the loop since it has
> found a match, and MACs are supposed to be unique?
> 
> 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
> 		/* skip wrong virtual interface */
> 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
> 			continue;
> ...

I think that'd be mostly safe, since we don't allow the same station to
be added to multiple VLANs. However, I'm not entirely sure if it really
is safe in the case of WDS interfaces.

> If so, that would be a good improvement since the hash can easily
> be turned into a linear search even in AP mode (without all of
> my virtual-station scenarios)...

I don't really see how the hash could be linear? When the low byte of
MAC addresses is the same, but otherwise?

johannes

