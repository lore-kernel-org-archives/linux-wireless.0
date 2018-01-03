Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbeACU0k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:26:40 -0500
Message-ID: <1515011196.10342.8.camel@sipsolutions.net> (sfid-20180103_212649_626756_B2B829DC)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 03 Jan 2018 21:26:36 +0100
In-Reply-To: <00fc2806-3e2c-811e-0f00-6774dc37d843@gmail.com> (sfid-20180103_181741_570171_25A40738)
References: <20171228175832.3253-1-denkenz@gmail.com>
         <20171228175832.3253-5-denkenz@gmail.com>
         <1514899804.2024.5.camel@sipsolutions.net>
         <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com>
         <1514924529.10342.4.camel@sipsolutions.net>
         <00fc2806-3e2c-811e-0f00-6774dc37d843@gmail.com>
         (sfid-20180103_181741_570171_25A40738)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > If so, can we do something like what ieee80211_process_sa_query_req in
> > > net/mac80211/rx.c or ieee80211_tdls_prep_mgmt_packet in
> > > net/mac80211/tdls.c do?  E.g. use ieee80211_tx_skb or
> > > __ieee80211_subif_start_xmit or similar to inject the skb with the
> > > DONT_ENCRYPT flag?
> > 
> > Yes, this will work - but like I said, it requires more control over
> > the SKB than cfg80211 has today, and than you can get through the
> > regular netdev xmit.
> 
> So, I'm a bit lost here.  You're saying this will work but then it 
> won't.  Are you saying this would only work for mac80211 based devices 
> (e.g. ones that implement ieee80211_ops) but not ones that implement 
> cfg80211_ops?  I presume because those provide their own net_device_ops?

Heh, yeah, badly phrased. It'll work to do it like process_sa_query or
similar code, for mac80211 drivers. What will *not* work is actually
building and submitting the SKB in cfg80211 though, since you can't
even set the DONT_ENCRYPT flag from there.

> > > This would likely mean that legacy behavior would still have to be
> > > supported for quite some time (forever?) for drivers that don't get
> > > around to implementing this, which would be unfortunate.
> > 
> > What do you mean by "legacy behaviour"? *Drivers* don't really need to
> > do anything one way or the other, and mac80211 is the only thing
> > implementing control port encrypt/ethertype right now, I suspect.
> > 
> 
> When I say legacy I mean 'over netdev', e.g. not over nl80211.

We need to support that behaviour forever anyway, for existing versions
of userspace software.

> Okay, so what you're saying is that the current CONTROL_PORT_* stuff 
> doesn't work on anything besides mac80211 since drivers can completely 
> ignore stuff inside cfg80211_connect_params.  And there's no way for 
> userspace to know this ahead of time?

Yes, NL80211_ATTR_CONTROL_PORT_ETHERTYPE is an attribute set in the
wiphy info - see WIPHY_FLAG_CONTROL_PORT_PROTOCOL in the code.

> So essentially we'd need a new operation in cfg80211_ops that would 
> accept the control port frame data and some control flags.  Do we want 
> to pass in an skb with all the 802.11 headers set or a 802.3 formatted 
> skb (since that is what other data frames look like initially on the 
> netdev).

I think 802.3 format would be better - matches better for full-MAC
devices that might do all header conversion in the device, and getting
the BSSID might even be difficult from cfg80211, etc.

johannes
