Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40423 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754268AbcJDI3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 04:29:31 -0400
Message-ID: <1475569759.5324.22.camel@sipsolutions.net> (sfid-20161004_102935_286017_DBB63EF5)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael.braun@fem.tu-ilmenau.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 04 Oct 2016 10:29:19 +0200
In-Reply-To: <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <1475229714.17481.18.camel@sipsolutions.net>
         <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > First of all - there's nothing specific to "AP interfaces", which
> > you say in the subject, as far as I can tell? That should be
> > removed?
> 
> > 
> > > 
> > > if (unlikely(ta &&
> > > +			     (iftype == NL80211_IFTYPE_AP ||
> > > +			      iftype == NL80211_IFTYPE_AP_VLAN)
> > > &&
> > > +			     !ether_addr_equal(ta, eth.h_source)
> > > +		   ))
> > > +			goto purge;
> 
> So the A-MSDU packets are only dropped if received by an interface in
> AP or AP_VLAN mode, not on client side, as my original issue was
> about arp/ip filters being circumvented on AP side.

D'oh. Not paying attention, I guess.

Nevertheless, why should this be conditional on the interface type? It
seems to me that we should apply this to any type? What if, for
example, another BSS client sends an A-MSDU encrypted with the GTK and
then fakes something inside that way? We verify today that only
multicast frames can be encrypted with the GTK, but that applies to the
outer header, so we're susceptible to a variant of the hole-196 attack,
afaict?

> > > IEEE 802.11-2012 mandates that the outer source mac address
> > > should match the inner source address (section 8.3.2.2). For the
> > > destination mac address, matching is not required (section
> > > 10.23.15).
> > 
> > I think this is wrong. As we do not support DMS (yet), we should
> > adhere to 8.3.2.2 and only accept matching TA/SA and DA/RA.
> 
> IEEE 802.11-2012 8.3.2.2 contains the note "NOTE—It is possible to
> have different DA and SA parameter values in A-MSDU subframe headers
> of the same A-MSDU as long as they all map to the same Address 1 and
> Address 2 parameter values."
> 
> I conclude that embedding multicast in unicast A-MSDU frames is
> generally allowed, because "mapping" does not mean "be identical".

Yeah, I saw this. It's not clear to me that they intended this wording
to be about multicast though. I'm not really sure what they had in mind
here, but there's an exception for multicast for DMS, which would seem
pointless if they had intended this "mapping" to be about multicast.

Then again, I don't know of any "address mapping" service or the like
in the spec either.

johannes
