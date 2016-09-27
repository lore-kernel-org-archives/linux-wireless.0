Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48245 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbcI0Izm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 04:55:42 -0400
Message-ID: <1474966538.5141.12.camel@sipsolutions.net> (sfid-20160927_105546_729466_94EEB1FA)
Subject: Re: [PATCHv2] mac80211: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Amitkumar Karwar <akarwar@marvell.com>,
        Avinash Patil <patila@marvell.com>
Date: Tue, 27 Sep 2016 10:55:38 +0200
In-Reply-To: <dbc9f09e4d932d808fed99ebd02301c0@fami-braun.de>
References: <1474802886-27220-1-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_132809_451078_E31A6EC3) <1474963267.5141.11.camel@sipsolutions.net>
         <dbc9f09e4d932d808fed99ebd02301c0@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-09-27 at 10:53 +0200, michael-dev wrote:
> Am 27.09.2016 10:01, schrieb Johannes Berg:
> > 
> > ...
> > 
> > This leaves "eth_80211" uninitialized if has_80211_header is false.
> > 
> > > 
> > > @@ -768,6 +768,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff
> > > *skb, struct sk_buff_head *list,
> > >  		subframe_len = sizeof(struct ethhdr) + len;
> > >  		padding = (4 - subframe_len) & 0x3;
> > >  
> > > +		if (unlikely(has_80211_header &&
> > > +			     (iftype == NL80211_IFTYPE_AP ||
> > > +			      iftype == NL80211_IFTYPE_AP_VLAN)
> > > &&
> > > > > > +			     !ether_addr_equal(eth_80211.h_source,
> > > eth.h_source)
> > > +		   ))
> > > +			goto purge;
> > 
> > And this then compares against uninitialized data, so this won't
> > work.
> 
> but it only compares against eth_80211 if has_80211_header is true
> due to order of evaluation, which in turn implies eth_80211 is
> initialized, right?
> 

Oh, right, I missed that, sorry.

Nevertheless, it seems it would be better to allow the other users (not
mac80211) that have has_80211_header=false to still have the check?

johannes
