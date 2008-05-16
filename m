Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:24209 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYEPV5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:57:22 -0400
Received: by py-out-1112.google.com with SMTP id u52so1063929pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 14:57:21 -0700 (PDT)
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210972335.6381.52.camel@johannes.berg>
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 <1210971848.5915.58.camel@brick>
	 (sfid-20080516_230412_000613_CA74646C)  <1210972335.6381.52.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Fri, 16 May 2008 14:57:20 -0700
Message-Id: <1210975040.5915.63.camel@brick> (sfid-20080516_235726_146295_23AADF41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-16 at 23:12 +0200, Johannes Berg wrote:
> > > > +static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *=
hdr)
> > >=20
> > > That seems fine too.
> > >=20
> > > > +static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u=
16 ftype)
> > >=20
> > > That, I think, is misnamed, it should be ieee80211_is_ftype()
> >=20
> > Well, I didn't expect this to be used directly that much, hence the
> > following three helpers...ftype_mgmt/ctl/data
>=20
> Right. Still, I think it should be named with _is_ in there.

Yes, I agree with you, that's what I meant to write.

>=20
> > > > +static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u=
16 stype)
> > > > +{
> > > > +	return (hdr->frame_control & cpu_to_le16(stype)) !=3D 0;
> > > > +}
> > >=20
> > > And that even seems implemented wrongly? stype is a 4-bit field, =
this
> > > doesn't make much sense to me.
> >=20
> > It was meant to be used to replace code like:
> >=20
> > =EF=BB=BFfc & IEEE80211_STYPE_QOS_DATA
> >=20
> > =EF=BB=BFieee80211_stype(hdr, IEEE80211_STYPE_QOS_DATA)
> >=20
> > As most users of the stype bits test against a specific constant,
> > otherwise you could add a bunch of helpers, one for each stype
> > constant (similar to the ftype helpers I added.  There were only
> > 3 in the ftype case, so I just added them all and dropped the secon=
d
> > parameter, in the stype case, there are more options, so I just
> > left one two-parameter helper.
>=20
> Well, yes, but that's semantically unclear because of the way these b=
its
> are used vs. how they are called. The subtype (stype) is a four-bit
> field in the frame control field which isn't actually defined to have
> "flags" or bits like that in it. Look at the table in IEEE 802.11-200=
7,
> it's at the beginning of clause 7 somewhere.
>=20
> Hence, hiding this simple AND behind a function that claims to check =
the
> subtype is confusing.

Ahhh, I see what you are getting at now, how about ieee80211_stype_mask=
?

That makes the & a little clearer and has better semantic meaning.

The other option is still to call it stype_mask, but change it to
return a __le16....so tests against !=3D 0 still work and really
is just a wrapper around the byteswap of the constant and the &.

What do you think of that?

Harvey



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
