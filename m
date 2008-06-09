Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:49808 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYFISWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 14:22:51 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2206622wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 11:22:49 -0700 (PDT)
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213034570.22220.18.camel@johannes.berg>
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
	 <1213033412.5974.28.camel@brick>
	 (sfid-20080609_194341_412413_70F0E00E)  <1213033579.22220.8.camel@johannes.berg>
	 <1213034059.5974.33.camel@brick>
	 (sfid-20080609_195423_018122_29F9C06D)  <1213034570.22220.18.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Mon, 09 Jun 2008 11:22:47 -0700
Message-Id: <1213035768.5974.46.camel@brick> (sfid-20080609_202258_465623_4661541E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 20:02 +0200, Johannes Berg wrote:
> > Well, the way the other functions of the same type:
> >=20
> > ieee80211_ctl_is_ack
> > ieee80211_mgmt_is_beacon
> >=20
> > check not only that the ftype is exactly ctl/mgmt and that it is of
> > stype ack/beacon.
>=20
> Hah. Well, I think they should probably be named
> ieee80211_is_ctl_ack/is_mgmt_beacon then, or just shorter
> _is_ack/_is_beacon (since everybody knows ack are ctl and beacon are
> mgmt.)

OK, just for clarity, could you spell out the helper names you'd like t=
o
see, and I'll adjust accordingly, at this point I think you would agree
with:

ieee80211_is_data
=EF=BB=BFieee80211_is_ctl
=EF=BB=BFieee80211_is_mgmt

ieee80211_has_protected
=EF=BB=BFieee80211_has_morefrags
ieee80211_has_tods
ieee80211_has_fromds
ieee80211_has_a4

And you'd like to see the following changes:

ieee80211_data_has_qos -> ieee80211_is_data_qos (maybe dataqos)
ieee80211_ctl_is_ack -> ieee80211_is_ack
=EF=BB=BFieee80211_ctl_is_pspoll -> ieee80211_is_pspoll
ieee80211_ctl_is_back_req -> ieee80211_is_back_req
=EF=BB=BFieee80211_mgmt_is_beacon -> ieee80211_is_beacon

I agree that does look nicer, and it just has to be clear that these
explicity check the ftype as well.

>=20
> >   I chose ieee80211_data_has_qos because it checks
> > the ftype _is_ data _and_ that it _has_ qos included.  I think my
> > naming is more consistent with this.
> >=20
> > Do you still think it should be changed?
>=20
> I think you're looking at the bits too much. If you look at 802.11-20=
07,
> Table 7-1, you'll notice that all frames that have data ftype and the
> "QoS bit" set in the subtype are actually data+qos frames, just with
> extra functionality added onto them by the other stype bits.
>=20
> Hence, I do think it should be changed, we're more interested in the
> semantic meaning ("this is a data+QoS [possibly +stuff] frame") rathe=
r
> than the bitwise meaning ("this is a data frame which has some QoS bi=
t
> set"). I guess the correct way would be to say "this is data frame wh=
ich
> has QoS information" which we'd have to express as "_is_data_has_qos"=
 or
> something, no?

Well, I agree with your semantics argument above, so this won't be nece=
ssary.
I guess I got a little caught up in the checks themselves vs the semant=
ics
it was expressing.

So choose a colour for the bikeshed and I'll get painting ;-)

Cheers,

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
