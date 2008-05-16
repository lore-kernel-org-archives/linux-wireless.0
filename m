Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:58729 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYEPVEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:04:10 -0400
Received: by py-out-1112.google.com with SMTP id u52so1037343pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 14:04:09 -0700 (PDT)
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210969866.6381.46.camel@johannes.berg>
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Fri, 16 May 2008 14:04:07 -0700
Message-Id: <1210971848.5915.58.camel@brick> (sfid-20080516_230414_876666_3F946B8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-16 at 22:31 +0200, Johannes Berg wrote:
> > +static inline int ieee80211_fctl_tods(struct ieee80211_hdr *hdr)
>=20
> > +static inline int ieee80211_fctl_fromds(struct ieee80211_hdr *hdr)
>=20
> These seem fine though I don't see why you implement them with a > 0
> rather than !=3D 0 comparison?

No reason, I'll move to all !=3D 0

>=20
> > +static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *hdr)
>=20
> That seems fine too.
>=20
> > +static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u16 f=
type)
>=20
> That, I think, is misnamed, it should be ieee80211_is_ftype()

Well, I didn't expect this to be used directly that much, hence the
following three helpers...ftype_mgmt/ctl/data

>=20
> > +static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u16 s=
type)
> > +{
> > +	return (hdr->frame_control & cpu_to_le16(stype)) !=3D 0;
> > +}
>=20
> And that even seems implemented wrongly? stype is a 4-bit field, this
> doesn't make much sense to me.

It was meant to be used to replace code like:

=EF=BB=BFfc & IEEE80211_STYPE_QOS_DATA

=EF=BB=BFieee80211_stype(hdr, IEEE80211_STYPE_QOS_DATA)

As most users of the stype bits test against a specific constant,
otherwise you could add a bunch of helpers, one for each stype
constant (similar to the ftype helpers I added.  There were only
3 in the ftype case, so I just added them all and dropped the second
parameter, in the stype case, there are more options, so I just
left one two-parameter helper.

>=20
> > +static inline int ieee80211_ftype_mgmt(struct ieee80211_hdr *hdr)
>=20
> > +static inline int ieee80211_ftype_ctl(struct ieee80211_hdr *hdr)
>=20
> > +static inline int ieee80211_ftype_data(struct ieee80211_hdr *hdr)
>=20
> similarly, ieee80211_is_data() (remove the ftype, everybody hacking
> wireless should know that data/mgmt/ctl are frame types)

OK, I'll drop ftype from these three, but leave it in the two-param
version as it is really just a helper for these three.

What do you think if I just left the stype version as-is, subject
to the usage I showed above, which is the common case.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
