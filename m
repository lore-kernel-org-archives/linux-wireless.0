Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22507 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161212AbXBOUwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:52:25 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] d80211: Simplify channel & mode configuration
Date: Thu, 15 Feb 2007 15:52:02 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702092325.39994.flamingice@sourmilk.net> <200702092343.54479.flamingice@sourmilk.net> <20070215211528.623e1c14@griffin.suse.cz>
In-Reply-To: <20070215211528.623e1c14@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8746436.xBg7uj3rIC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702151552.02331.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8746436.xBg7uj3rIC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 15 February 2007 15:15, Jiri Benc wrote:
> > +	local->hw.conf.channel =3D chan->chan;
> > +	local->hw.conf.channel_val =3D chan->val;
> > +	local->hw.conf.power_level =3D chan->power_level;
> > +	local->hw.conf.freq =3D chan->freq;
> > +	local->hw.conf.phymode =3D mode->mode;
> > +	local->hw.conf.antenna_max =3D chan->antenna_max;
>
> What about passing ieee80211_channel and ieee80211_hw_mode structures
> instead of a ton of variables? (Just an idea, not a problem with the
> patch.)
>
I was thinking that too, but I was trying to avoid driver api changes. I mi=
ght=20
make a patch for it later if it still makes sense then.

> > +	if (local->curr_rates !=3D mode->rates)
> > +		rate_control_clear(local);
> > +	local->curr_rates =3D mode->rates;
> > +	local->num_curr_rates =3D mode->num_rates;
> > +	ieee80211_prepare_rates(local);
>
> This will trigger rate control reinitialization when scanning on abg
> cards. It's needed but not obvious at first sight. Perhaps some comment
> would be useful here? (Again, not a problem with the patch, just
> something I realized looking at the patch and thinking why the hell do
> we do the reinitialization here?)
>
Yeah, this is why rate control never seems to work right on my system -=20
NetworkManager keeps scanning and resetting the rate control. I'm not sure=
=20
exactly how to fix it, so I just left it..

=2DMichael Wu

--nextPart8746436.xBg7uj3rIC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1MfyT3Oqt9AH4aERAuhcAKCyB6omR4zuwK9gmBEtfSoaRROhPACePoM9
4BJQI0bpfs7ugoYhdLcXt9s=
=efFc
-----END PGP SIGNATURE-----

--nextPart8746436.xBg7uj3rIC--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
