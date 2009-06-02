Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZFBH2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 03:28:55 -0400
Subject: Re: [RFC] mac80211: handle -EXIST on sta_info_insert()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, Jouni.Malinen@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890906011830q2867ed1el7914846c15c8eb3e@mail.gmail.com>
References: <1243905828-21933-1-git-send-email-lrodriguez@atheros.com>
	 <43e72e890906011830q2867ed1el7914846c15c8eb3e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hA1EwI6qy2sjgLlK349R"
Date: Tue, 02 Jun 2009 09:28:49 +0200
Message-Id: <1243927729.5299.35.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hA1EwI6qy2sjgLlK349R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 18:30 -0700, Luis R. Rodriguez wrote:
> On Mon, Jun 1, 2009 at 6:23 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > There's a few places where we either did not rcu_read_lock()
> > prior to addition of a a new sta or we allocated it before
> > checking for its existance. In most places, like device open
> > and close we should have at least some guarantee the stas are
> > wiped but in other places this could not be the case.
> >
> > Lets protect against RCU in the missing places. The only
> > place I see is is in ieee80211_rx_bss_info(). Not sure
> > we are calling ieee80211_ibss_add_sta() twice there though.
> >
> > In our mac80211 cfg80211 callback for device addition we
> > also can simplify the code by first checking for the STA
> > before trying to add it and then checking for -EEXIST which
> > we were not doing. If that actualy would happen we could
> > end up potentially with a stale sta and the rate info was
> > never updated. It seems cleaner to check for the sta first.
> >
> > Lastly, we add a WARN_ON() on the STA mlme path upon call to
> > ieee80211_rx_mgmt_assoc_resp() for -EEXIST. This should not
> > happen, we could just return -EIO or simply ignore it.
>=20
> Hm, actually on second thought what if we simply kdoc that you should
> check for the sta's existence first prior to addition. Then we can
> remove the pesky -EEXIST.

Umm, no? Neither approach is correct.

johannes

--=-hA1EwI6qy2sjgLlK349R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJNSuAAoJEODzc/N7+Qma6U4P/2+/3pGGFbVgdm409/2PgzIp
NbgE4YOKq1HnO/Aqzg0Wy7aUC2x6d/K7DGeHWB5x5M5UvxKVYROJNjCadf8jKBll
LeXgsurBJ0s6xLCXZ6KBr6YvpAOlEZA3hMZsfcErlEcrN+oYlTlUquPR40ONB+jw
Xb7Y7/juXQeqehVva4cG/IoK1/8Ia2SzJYP+NP9UDZ5ISsRMgcptCj8Fgsu21HO2
nK0E4G/+PcusqxUD46dDiWG+/nm93mbgeFMZ6rQISyHH0osXTYekESrvMGs8J0kH
FfwOLSJezS2420PsWLaTBrKMGWGcDfY2zXy800usv4QYugmg8R1i9/b+DQKBkTUN
p2tbBsAn80hSWcTFnFB3H2m99E/l/RZJPprgElMsqlOe038clQLxuKWsePV77Xp4
NZLPi+FyxyOsOkQISIm7FnO6jCEW/O5kIZgNcBxOJ67dUksRmno2PMz5U71y00j5
At+OFrbyX5uDDnxTcHaz4l+x6Jqx2TvHe3kg+e0ZU6BQJvkSKpy7ls3rwrlUNunv
TYLsyZizna+tmFepdBvH9hUYR5i/mUH67tlEard5kp43jpYp/YJ1M8p4cUico3Us
WQ3VrIOqW6y+vG5clHTqqlpAl4KlR8B3khqx4F9YxFmk6nfcwFb5sYSyzaenqa3b
Unv1k+54mqc6Re0ZJpaV
=t+b3
-----END PGP SIGNATURE-----

--=-hA1EwI6qy2sjgLlK349R--

