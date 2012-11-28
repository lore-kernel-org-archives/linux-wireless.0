Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:36872 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2K1TjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 14:39:19 -0500
Date: Wed, 28 Nov 2012 20:39:07 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 1/3] nl80211: add spec scan flag
Message-ID: <20121128193907.GA7131@pandem0nium> (sfid-20121128_203923_007413_02836CEC)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354106128.9345.6.camel@jlt4.sipsolutions.net>
 <1354106616.9345.13.camel@jlt4.sipsolutions.net>
 <20121128151916.GA6175@pandem0nium>
 <1354119974.9345.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
In-Reply-To: <1354119974.9345.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 05:26:14PM +0100, Johannes Berg wrote:
>=20
> > > > That "if supported" here is pretty problematic. There's no way to k=
now.
> > > > Feature flag maybe?
> >=20
> > Hmm, I could certainly add a WIPHY_FLAG for that.
>=20
> nl80211 feature flag would be better
>=20

OK, that would work too. Just that there are some Atheros Chips which don't
support spectral scan, like AR9160, but are supported by ath9k. I guess I'd
just set the feature if the chip revision is supported, from within ath9k.

> > > > Also, there are scan flags now. However, I don't see that this shou=
ld
> > > > (ab)use the scan function. It doesn't seem likely that you want to =
do
> > > > this while you're sending probe requests, etc. OTOH, it seems likely
> > > > you'd want identical dwell times on all channels to have comparable
> > > > values, which isn't the case here.
> >=20
> > The times are not a big problem - at least for now, the spectral scan
> > is only done for a very short time [tm] when the channel is changed.
> >=20
> > The main reason why I wanted to use this function is that it can be used
> > while operation, that is sending power save, forbidding payload tx, etc.
>=20
> That's not an argument for using the scan API. That might be an argument
> for piggy-backing on the scan *implementation*, but that's an orthogonal
> issue. Note how I didn't comment on patch 2 -- I do think piggy-backing
> on the scan implementation would be acceptable.

OK

>=20
> > > So bottom line is that I think there are two choices:
> > > 1) for a proof of concept, implement it in debugfs only, in ath9k onl=
y,
> > >    with e.g. a debugfs file that sets a flag that then triggers the
> > >    spectral scan when you do a scan (using sw_scan_start, config hook=
s)
> > >    --> no need to modify nl80211 at all
> >=20
> > So the idea is something like:
> >  * open debugfs-file (e.g. with cat)
> >  * start scan "normally", without any flags
> >  * read debugfs results, and close it
> >=20
> > Mhm, this is definitely possible, although not too beautiful as well. :)
> >=20
> > It seems there is no way to trigger a scan from within ath9k/debugfs, r=
ight?
>=20
> No.
>=20
> > sw_scan_start() is currently undefined in ath9k, but we could add that.
> > By "config hooks" you mean the general config driver call to set the ch=
annel
> > etc?
>=20
> I meant to trigger the data collection there.
>=20
> > I could also cycle channels within ath9k, but the main problem I see is=
 that
> > I can't turn off TX/go into power save mode from the driver, or would y=
ou see
> > anything feasible?=20
>=20
> Triggering it all from the driver doesn't seem possible, no. You could
> have the function take effect on the next scan, but it's still kinda
> hybrid. However, it wouldn't "pollute" nl80211 that way.
>=20

OK, so it could look like:

echo start > debugfs/ath9k/spectral_scan
iw dev wlan0 scan
cat debugfs/ath9k/spectral_scan
[... get output ...]
echo stop > debugfs/ath9k/spectral_scan

yeah, that's still hybrid, but still simple.

> > > 2) implement some well-defined API in nl80211, but don't tie it to
> > >    scanning or a debugfs implementation of getting the data out, with
> > >    versioning of the FFT data packets etc. so it can be updated later
> > >    without breaking everything
> >=20
> > I guess if we implement this in iw, this would be done similarly to sca=
n,
> > e.g. trigger the scan and wait on the socket for results? Or would we
> > use events instead?
> >=20
> > This would roughly mean:
> >  * duplicate the mac80211 scan part for spectral scan to cycle channels=
/be quite
> >    while doing this
>=20
> No, I didn't say this. I said the API should be different, the
> implementation in mac80211 could very well just be "either going to send
> probes & wait, or collect spectral scan data and continue to the next
> channel"
>=20
> >  * duplicate iw scan (at least some parts), the interface could look ve=
ry similar:
> >    trigger scan, on receive scan results on another socket, wait for co=
mpletion
> >    (although iw still has this "warning, it's racy" thing inside. :] )
>=20
> Actually you need a separate application anyway, to interpret the
> results, so that application would
>  * open a socket
>  * send the spectral scan command
>  * read the results on the socket

Ah OK, so we would have a new nl80211 spectral scan command which then calls
the mac80211/scan stuff, but with special flags which the normal scan would=
n't
do. It could then return the results, and the current scan command wouldn't=
 be
harmed. I hope I got this right? :)

Also, putting all this into iw to dump the raw data would be feasible, no?
Right now I'm dumping the data on some AP, but display it on another comput=
er
(with a screen :] ), so this intermediate step is needed anyways.

Actually, the ath9k-only way seems to be faster for now. I'm not sure about
the data interpretation (offset/exponents etc), and I'd like to have
this confirmed/corrected before exporting results via nl80211 - I don't want
to change the data format all the time. Maybe some ath9k fellow can comment
on that, or if they like the debugfs-only idea. :)

Thanks again,
	Simon

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC2aFsACgkQrzg/fFk7axb5QwCgksFhe4wwLlmylqP1+vckStW4
D6gAoNL7PmuFwNqOwFy5vh/THgvkZCzM
=ejvb
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
