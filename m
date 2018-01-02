Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54082 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbeABUWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 15:22:11 -0500
Message-ID: <1514924529.10342.4.camel@sipsolutions.net> (sfid-20180102_212214_981861_1A71DE03)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 02 Jan 2018 21:22:09 +0100
In-Reply-To: <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com> (sfid-20180102_192300_834715_F98D3C68)
References: <20171228175832.3253-1-denkenz@gmail.com>
         <20171228175832.3253-5-denkenz@gmail.com>
         <1514899804.2024.5.camel@sipsolutions.net>
         <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com>
         (sfid-20180102_192300_834715_F98D3C68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-02 at 12:22 -0600, Denis Kenzior wrote:

> > There are cases where CONTROL_PORT_ETHERTYPE_NO_ENCRYPT should be
> > unset, but specific frames still shouldn't be encrypted.
> > 
> > So I think for this particular path it would be better to deprecate
> > CONTROL_PORT_ETHERTYPE_NO_ENCRYPT entirely, and have a separate per-
> > frame flag.
> > 
> > That also means that we can't really implement it fully in cfg80211,
> > but have to provide some functionality for the driver to do things to
> > be able to honour such flags.
> 
> Here's another thought I had while poking around.  Given the above I 
> don't want to pursue it too seriously unless you think it might work:
> 
> We already have the IEEE80211_TX_INTFL_DONT_ENCRYPT flag on the skb and 
> some drivers seem to honor this.  At least that seems to be the intent 
> as the CONTROL_PORT_NO_ENCRYPT flag ends up being translated to this 
> somewhere in net/mac80211/tx.c.  Are the drivers supposed to honor that 
> flag?

Drivers don't have a choice, and don't need to check the flag. What
happens internally in mac80211 is that either txinfo->control.key is
assigned, or not, and drivers make encryption decisions based on that.

> If so, can we do something like what ieee80211_process_sa_query_req in 
> net/mac80211/rx.c or ieee80211_tdls_prep_mgmt_packet in 
> net/mac80211/tdls.c do?  E.g. use ieee80211_tx_skb or 
> __ieee80211_subif_start_xmit or similar to inject the skb with the 
> DONT_ENCRYPT flag?

Yes, this will work - but like I said, it requires more control over
the SKB than cfg80211 has today, and than you can get through the
regular netdev xmit.

> > Perhaps a new operation, where we pass a pre-built SKB and control
> > flags?

> 
> This would likely mean that legacy behavior would still have to be 
> supported for quite some time (forever?) for drivers that don't get 
> around to implementing this, which would be unfortunate.

What do you mean by "legacy behaviour"? *Drivers* don't really need to
do anything one way or the other, and mac80211 is the only thing
implementing control port encrypt/ethertype right now, I suspect.

johannes
