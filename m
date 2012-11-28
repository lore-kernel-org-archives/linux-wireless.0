Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39583 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab2K1PTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 10:19:30 -0500
Date: Wed, 28 Nov 2012 16:19:16 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 1/3] nl80211: add spec scan flag
Message-ID: <20121128151916.GA6175@pandem0nium> (sfid-20121128_161935_488851_C9675524)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354106128.9345.6.camel@jlt4.sipsolutions.net>
 <1354106616.9345.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <1354106616.9345.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

On Wed, Nov 28, 2012 at 01:43:36PM +0100, Johannes Berg wrote:
> On Wed, 2012-11-28 at 13:35 +0100, Johannes Berg wrote:
> > On Tue, 2012-11-27 at 20:01 +0100, Simon Wunderlich wrote:
> > > This flag indicates that a spectrum scan is requested, if supported.
> >=20
> > That "if supported" here is pretty problematic. There's no way to know.
> > Feature flag maybe?

Hmm, I could certainly add a WIPHY_FLAG for that.

> >=20
> > Also, there are scan flags now. However, I don't see that this should
> > (ab)use the scan function. It doesn't seem likely that you want to do
> > this while you're sending probe requests, etc. OTOH, it seems likely
> > you'd want identical dwell times on all channels to have comparable
> > values, which isn't the case here.

The times are not a big problem - at least for now, the spectral scan
is only done for a very short time [tm] when the channel is changed.

The main reason why I wanted to use this function is that it can be used
while operation, that is sending power save, forbidding payload tx, etc.

> >=20
> > I really think you need to decouple the API for this from scanning.
>=20
> And then you can also define APIs to get the data out. While I realize
> that the data is implementation-dependent, you could have an enum that
> indicates the data format and describes it:
>=20
> @NL80211_SPECTRAL_DATA_ATHEROS: u8 rssi,ext_rssi,noise,fft_data[] ...
>=20
> enum nl80211_spectral_data {
> 	NL80211_SPECTRAL_DATA_ATHEROS,
> 	...
> };
>=20
> Then you can define a function to send the data to the userspace socket
> that asked for it (yes, if you have a separate command you can send it
> only to that app... wohoo! :P ) and don't even have to store it in the
> kernel...

Calling the spectral scan and RX the FFT data are different things, but
yes, having everything in one application would be much better than
"trigger at X, receive at Y".=20
>=20
> So bottom line is that I think there are two choices:
> 1) for a proof of concept, implement it in debugfs only, in ath9k only,
>    with e.g. a debugfs file that sets a flag that then triggers the
>    spectral scan when you do a scan (using sw_scan_start, config hooks)
>    --> no need to modify nl80211 at all

So the idea is something like:
 * open debugfs-file (e.g. with cat)
 * start scan "normally", without any flags
 * read debugfs results, and close it

Mhm, this is definitely possible, although not too beautiful as well. :)

It seems there is no way to trigger a scan from within ath9k/debugfs, right?

sw_scan_start() is currently undefined in ath9k, but we could add that.
By "config hooks" you mean the general config driver call to set the channel
etc?

I could also cycle channels within ath9k, but the main problem I see is that
I can't turn off TX/go into power save mode from the driver, or would you s=
ee
anything feasible?=20

> 2) implement some well-defined API in nl80211, but don't tie it to
>    scanning or a debugfs implementation of getting the data out, with
>    versioning of the FFT data packets etc. so it can be updated later
>    without breaking everything

I guess if we implement this in iw, this would be done similarly to scan,
e.g. trigger the scan and wait on the socket for results? Or would we
use events instead?

This would roughly mean:
 * duplicate the mac80211 scan part for spectral scan to cycle channels/be =
quite
   while doing this
 * duplicate iw scan (at least some parts), the interface could look very s=
imilar:
   trigger scan, on receive scan results on another socket, wait for comple=
tion
   (although iw still has this "warning, it's racy" thing inside. :] )

This looks like a whole lot of work, and would duplicate some code which
we need for scan and spec_scan (at least it looks like it). On the plus sid=
e,
this would be easier to change in the future (e.g. adding parameters for sp=
ec
scan, etc).

>=20
> This hybrid isn't a good approach at all.

I don't like hybrid approach as well, but hoped that it could be "good enou=
gh"
for a proof of concept. If someone ever implements pattern matching, the
interface will probably change again as well.

Maybe you could find this idea acceptable: Keep on using the scan command p=
lus
some flag/and or attribute, but send "FFT result" as events or within the s=
can
socket instead of using debugfs. What do you think?

Thanks for your review and suggestions! I'd like to discuss the alternatives
to fully understand them and then choose one. :)

Cheers,
	Simon

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC2K3QACgkQrzg/fFk7axYR9ACgpmgAVkAx48fDMSCFfEaIpXSw
ERcAoM3VrjC6Q2EsmWeUNChQjcQ5+Ei2
=gL/g
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
