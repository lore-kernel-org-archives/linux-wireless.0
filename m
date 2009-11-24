Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799AbZKXSh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 13:37:27 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0C2720.3090308@irobot.com>
References: <4AF0D54D.4090303@irobot.com>	 <4AFC8E4F.5090307@irobot.com>
	 <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>
	 <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>
	 <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local>
	 <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>
	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>
	 <4B0C1E0A.9020003@irobot.com> <1259085518.3491.24.camel@johannes.local>
	 <4B0C2720.3090308@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V8/JS8JOzfhzrWOASh8k"
Date: Tue, 24 Nov 2009 19:36:59 +0100
Message-ID: <1259087819.3491.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V8/JS8JOzfhzrWOASh8k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 10:34 -0800, Adam Wozniak wrote:
> Johannes Berg wrote:
> > Or you can probably call rate_exit and rate_init but I don't know how
> > the algorithms would react if you actually ask it for a rate during tha=
t
> > race window?
> >  =20
> There is no rate_exit in rate_control_ops, only init and update.  There=20
> is an rc80211_minstrel_exit() in rc80211_minstrel.c, but that just=20
> unregisters the module, which I don't think is what you want.

Hah, indeed, I thought it was symmetric, guess it's not.

However, that reminds me that I actually wanted to get rid of
rate_init() since it's mostly not useful to have it separate from
alloc_sta()... oh well.

I suppose if we document clearly that rate_init maybe called multiple
times and audit the existing algorithms the patch could be ok.

johannes

--=-V8/JS8JOzfhzrWOASh8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDCfFAAoJEODzc/N7+Qmap1sQAIb62XKv79KqN076Szwvrmj/
U/0xrBOK2oStrQs77O69CW0xUmGlvEM2bRhTPxKBNzwqZpZ2RCFprB6FeY8ExwvU
YAOzktjKw+Fjue6hJ5cob6y2Y0ufiEBJMEhpgs8aFMShD7QBNwZJCe8Guib8904M
Vn1K8apFPXJGGeX8S2BudUGpuv7T+EHcsy3qNbu/JktoSQPrRJxI4M6jNp07aDm7
QrrhLAcik8IU6CmsWSQpP0fUCyYnEV4J82AlZx3XsRyv6qqzUemXZ/Xb9sHW+ao0
h1More8mFMA3NuROyEN7TsYhMDdP7q4p8dJ4e3QiZ2EaAFyPv626cMpzFArinfFP
FVuMC5/Rc7cqtyRydjebUWrUIsDN3FivMiFfN5PTMfsVI24g872WfWmXCDz8llAN
K8Fbpiz3XQ0uM0wx+6Cm7obABCSky11stEoHpSmGFfbB9UNfHO0eiXQcr8SW4qnf
OZ4kCDVxzXfNqjxCwfKqgQJXdgz+SuLvOHsXNWDN+W5nb7KSvGhSPoTg/QMI3lkb
r5Ut9+jM2CoS0mxn+S9+p0M+v281OzXxjOsIolRDsIagSH/FYts7nFgtFqoRL0bt
7+TMMSacYLRPkdXTVWq7kgcFgfpa8ZSFUDfzRrbBcOBMCeCZ98Vi8QlquGMEe9/+
cwZjGly1wO3DX7UkzKuW
=5UES
-----END PGP SIGNATURE-----

--=-V8/JS8JOzfhzrWOASh8k--

