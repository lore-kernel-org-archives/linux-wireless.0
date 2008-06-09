Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:9680 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYFIRca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:32:30 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1380928ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 10:32:17 -0700 (PDT)
Subject: Re: [PATCH 2/7] mac80211: replace ieee80211_get_morefrag with
	ieee80211_has_morefrags
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213032133.22220.3.camel@johannes.berg>
References: <1212774671.6340.76.camel@brick>
	 (sfid-20080606_195947_229598_F1790495)  <1212997132.698.53.camel@johannes.berg>
	 <1213028961.5974.18.camel@brick>
	 (sfid-20080609_182929_823786_13F038F5)  <1213032133.22220.3.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Mon, 09 Jun 2008 10:32:14 -0700
Message-Id: <1213032734.5974.24.camel@brick> (sfid-20080609_193233_966035_FFE00857)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 19:22 +0200, Johannes Berg wrote:
> On Mon, 2008-06-09 at 09:29 -0700, Harvey Harrison wrote:
> > On Mon, 2008-06-09 at 09:38 +0200, Johannes Berg wrote:
> > > > -	if (ieee80211_get_morefrag(hdr))
> > > > +	if (ieee80211_has_morefrags(hdr->frame_control))
> > >=20
> > > looks fine to me, though I wonder if we should have
> > >=20
> > > ieee80211_has_morefrags(struct 80211hdr)
> > > and
> > > __ieee80211_has_morefrags(__le16 fc)
> > >=20
> > > or something with variants of the functions that do the ->frame_c=
ontrol?
> >=20
> > I considered that, but thought it was a small benefit for doubling =
the
> > number of helpers.
> >=20
> > I chose the __le16 variant as there is some driver code that checks=
 these
> > values in driver-specific structures, so I just left it up to the c=
aller
> > to dereference whatever structure the frame control is held in.
> >=20
> > But if both sets are wanted, I would suggest:
> >=20
> > =EF=BB=BFieee80211_fc_has_morefrags(__le16 fc);
> >=20
> > ieee80211_has_morefrags(struct ieee80211 *hdr)
> > {
> > 	return ieee80211_fc_has_morefrags(hdr->frame_control);
> > }
> >=20
> > Do you think I should add the struct helper(s)?
>=20
> It looks like you'd be using them in many places, so don't you think =
it
> would be helpful? I don't really care too much.
>=20

OK, I've added kernel-doc and incorporated the other comments, I'm not
going to add additional helpers for the struct ieee80211 case at this
time.

I'll check it over and send a revised version in a bit.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
