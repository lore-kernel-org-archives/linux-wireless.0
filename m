Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63217 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2FJMUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 08:20:38 -0400
Received: by wgbdr13 with SMTP id dr13so2276828wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 05:20:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [RFC v3] mac80211: follow 802.11-2007 11.5.3 Error recovery upon HT BA failure
Date: Sun, 10 Jun 2012 14:20:28 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	"Per-Erik Westerberg" <per-erik.westerberg@bredband.net>,
	=?utf-8?q?Miko=C5=82aj_Kuligowski?= <mikolaj.q@wp.pl>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <201206091601.34601.chunkeey@googlemail.com> <CANUX_P3smm6Pci-69aXA+PmW23nUSg-s2LGSv5Mn_rvTF-Q9-Q@mail.gmail.com>
In-Reply-To: <CANUX_P3smm6Pci-69aXA+PmW23nUSg-s2LGSv5Mn_rvTF-Q9-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206101420.30607.chunkeey@googlemail.com> (sfid-20120610_142042_250907_629A7326)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 June 2012 07:13:25 Emmanuel Grumbach wrote:
> > > But that notification trap would also have to call some function
> > > in the stack, and the drivers that don't have it (or don't
> > > implement it yet) need something more like this patch?
> >
> > (see v3 attached to this mail).
> >
> > Yes, drivers that don't pass BAs to the stack and won't call
> > ieee80211_ba_notification will have their BA sessions "removed" in v3.
> > Of course, we can also retain the old behavoir and reset the
> > tx ba session timeout until we know we don't break anything.
> 
> But if the peer acked a packet sent in a BA session, then it must send
> a BA (spec AFAIK), so when the driver calls ieee80211_tx_status at the
> originator side, mac80211 can assume that a BA was received, right?
Not necessarily, some wifi devices (especially USB) just don't provide
a status report. I think rtlwifi is a example for this case, since it
just sticks "STAT_ACK" on every package.

(Also, when the signal is bad, some devices fall back to legacy (retry)
rates and abandon aggregation at least for the time... so no, we
have to look elsewhere. Furthermore, I haven't found any
references in the spec that explicitly says that you can't
do that (e.g. A-MSDU vs A-MPDU mixed, etc...), so do you know
the paragraph that says BAs and normal acks can't be mixed?)
> Even if you still want a specific notification from the driver to
> mac80211, what about adding it to ieee80211_tx_info.status ?
> We have a trade-off here. We can have a new notification which is a
> new API (which is a disadvantage in terms of runtime and design) but
> can be called once per batch: meaning that we will reset the the timer
> once every 15 packets or so. Or we can have a bit in the
> ieee80211_tx_info.status which would be in every packet, but then, no
> need for new API.
> Maybe the best way is to have the driver set the new bit in
> ieee80211_tx_info.status only for the last packet of the batch (or the
> first, whatever).
If you look in ieee80211_tx_prep_agg you'll see that in the current
design the timer is already updated for every frame as well. So if
we just move this to a different place so the "cost" should remain
the same, right?

Regards,
	Christian
