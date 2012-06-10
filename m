Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53998 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2FJFN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 01:13:28 -0400
Received: by wgbdr13 with SMTP id dr13so2085080wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 22:13:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206091601.34601.chunkeey@googlemail.com>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
	<201206091414.41940.chunkeey@googlemail.com>
	<1339244892.5763.1.camel@jlt3.sipsolutions.net>
	<201206091601.34601.chunkeey@googlemail.com>
Date: Sun, 10 Jun 2012 08:13:25 +0300
Message-ID: <CANUX_P3smm6Pci-69aXA+PmW23nUSg-s2LGSv5Mn_rvTF-Q9-Q@mail.gmail.com> (sfid-20120610_071404_575300_A80889F8)
Subject: Re: [RFC v3] mac80211: follow 802.11-2007 11.5.3 Error recovery upon
 HT BA failure
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	Per-Erik Westerberg <per-erik.westerberg@bredband.net>,
	=?ISO-8859-2?Q?Miko=B3aj_Kuligowski?= <mikolaj.q@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The path is
> 11. -> MLME
>        5. -> Block Ack operation
>                3. -> Error Recovery upon a peer failure
>
> > > > >  - The spec says we should test for BlockAcks, however
> > > > >    that is not feasible because it is a control frame
> > > > >    (so FIF_CONTROL might filter it on some hardware).
> > > >
> > > > In some way, all devices are going to have to report these
> > > > frames. Maybe not as the frame itself, but as some other
> > > > notification, to allow cleaning up the TX queues
> > > > accordingly, I think? There's a BA notification in iwlwifi
> > > > for example.
> > > Alright, I guess this means that we probably need a new HW
> > > feature flag like:
> > >     IEEE80211_HW_REPORTS_BA_NOTIFICATION
> > > for hardware/firmware which filter BA frames, but have a BA
> > > notification trap. And every other driver need to pass BA
> > > to the stack where a new rx handler will update the last_tx
> > > accordingly.
> >
> > But that notification trap would also have to call some function
> > in the stack, and the drivers that don't have it (or don't
> > implement it yet) need something more like this patch?
>
> (see v3 attached to this mail).
>
> Yes, drivers that don't pass BAs to the stack and won't call
> ieee80211_ba_notification will have their BA sessions "removed" in v3.
> Of course, we can also retain the old behavoir and reset the
> tx ba session timeout until we know we don't break anything.

But if the peer acked a packet sent in a BA session, then it must send
a BA (spec AFAIK), so when the driver calls ieee80211_tx_status at the
originator side, mac80211 can assume that a BA was received, right ?

Even if you still want a specific notification from the driver to
mac80211, what about adding it to ieee80211_tx_info.status ?
We have a trade-off here. We can have a new notification which is a
new API (which is a disadvantage in terms of runtime and design) but
can be called once per batch: meaning that we will reset the the timer
once every 15 packets or so. Or we can have a bit in the
ieee80211_tx_info.status which would be in every packet, but then, no
need for new API.
Maybe the best way is to have the driver set the new bit in
ieee80211_tx_info.status only for the last packet of the batch (or the
first, whatever).

But I don't see why we cannot rely on the assumption I made in the
beginning of this mail to start with.
