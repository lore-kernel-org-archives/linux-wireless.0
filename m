Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:57949 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2LMWHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:07:05 -0500
Date: Thu, 13 Dec 2012 23:06:51 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121213220651.GA30855@pandem0nium> (sfid-20121213_230734_114843_2BBC3039)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20121213140753.GA26868@pandem0nium>
 <50CA0F8B.3060905@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
In-Reply-To: <50CA0F8B.3060905@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Felix,

thanks, this looks like exactly what I was hoping for!

On Thu, Dec 13, 2012 at 06:25:31PM +0100, Felix Fietkau wrote:
> On 2012-12-13 3:07 PM, Simon Wunderlich wrote:
> > Hey there,
> >=20
> > just to bump the issue again - isn't there anyone here who can answer
> > some of these questions?
> >=20
> > Adrian gave me some hints, but the FFT format is still completely uncle=
ar
> > - I would really like to integrate/fix things before bringing this patc=
h(set)
> > to the next level.
> >=20
> > I'm begging all the Qualcomm/Atheros-affiliated guys on the list to have
> > a look on the questions below and help me out here. :)
> >=20
> > Thanks a lot!
> > 	Simon
> >=20
> > On Thu, Dec 06, 2012 at 05:36:07PM +0100, Simon Wunderlich wrote:
> >> This patch(set) is the second iteration of the request for comments for
> >> upcoming spectral scan feature. It adds spectral scan control and dump
> >> features to debugfs. When the open questions regarding interpretation
> >> are answered, I would like to build an interface to nl80211/mac80211.
> >> Please see the open questions below, every hint is kindly appreciated.=
 :)
> >>=20
> >> This feature has been enabled for AR92xx and AR93xx based chipsets.
> >> We've also written a visual evaluation program for these samples (see
> >> screenshot [1] and sourcecode [2]).
> >>=20
> >> Many details are not known due to the fact that I don't have access to
> >> Atheros specifications and details. Many things are done by guessing
> >> and might be wrong. I'm therefore requesting help from Qualcomm/Atheros
> >> guys to confirm or correct my findings. Apart from that, after
> >> discussion I think we could integrate this patchset to allow other
> >> people to work on this as well, even if it is experimental now.
> >>=20
> >> Questions from my end:
> >>  1. There are many TODOs/Comments in the patches regarding details,
> >>     please answer if you can. :)
> >=20
> > See code comments, e.g. regarding phy error type which are not defined
> > in the headers, etc.
> Here's how to detect usable PHY error reports: Check for PHY error types
> RADAR (5), FALSE_RADAR_EXT (24) or SPECTRAL (38). If it's 38, no further
> validation is necessary. In the other cases, check the last byte
> (bwinfo). If it has bit 4 set, the data is usable for spectral.
>=20

So 38 is spectral then? Then this is confirmed, I'll extend/correct the
ath9k_phyerr enum appropriately. Didn't know that anyone can
come on "ATH9K_PHYERR_FALSE_RADAR_EXT", I have never seen this on my
hardware, but can add it just to be sure.

I guess the last 3 (radar) bytes are always used to "encapsulate" the
data, also for phyerr 38? I'll then always check bit 4. :)

> >>  2. The output format is very Atheros-dependent. If my finding that=20
> >>     byte n-4 is some kind of offset/exponent, I'd integrate this in
> >>     the debugfs output as well
> Here's my understanding of the data format:
>=20
> HT20:
> 56 bytes bin magnitude data (8 bits per bin)
> 3 bytes bin maximum values (see below)
> 1 byte exponent:
> 	[3:0] - number of bits to shift the magnitude data
>=20

Now that is exactly what I was looking for! So shifting the data makes it s=
ome
kind of exponent, so I wasn't so wrong. :D

BTW, does the 56 byte ever change, or may it happen that there is something=
 in front
of the FFT bins? or in the middle? I still see different data lengths, and =
the
format looks pretty fixed to me. In theory:
 * 56 bytes FFT bins
 * 3 bytes maximum values
 * 1 byte exponent
 * 3 byte radar trailer (with bwinfo etc)

Thoughts? I'll check my data again, too.


> HT40:
> 128 bytes bin magnitude data (64 lower bins, 64 upper bins)
> 3 bytes lower bin maximum values (see below)
> 3 bytes upper bin maximum values (see below)
> 1 byte exponent (like HT20)

I have not experimented in HT40 mode yet, but we should add that too. :)
>=20
> Bin maximum values:
> Byte 1: [1:0] - max_magnitude[1:0]
>         [7:2] - bitmap_weight[5:0]
> Byte 2: [7:0] - max_magnitude[9:2]
> Byte 3: [5:0] - max_index[5:0]
>         [7:6] - max_magnitude[11:10]
>=20

OK - not sure what "weight" means, max_magnitude might be the highest of the
FFT bins? What "index" is max_index?=20

BTW, the FFT bins/magnitude values, are these absolute values or logarithmic
values? I'd guess it's absolute from the look of it (applying log() makes it
"look better" in the visualization), but not sure.


> >>  3. The data length varies pretty much, there might be some false
> >>     positives/PHY errors which are not FFT data - what should be
> >>     the correct length?
> See above.
>=20
> >>  4. Is there any special handling for HT40? At least the proprietary
> >>     driver symbol names suggest so [3]
> >=20
> > -> this one is solved: yes, there is. it has more FFT bins. Although
> > I didn't see that yet (I doubt they are the "small" variations I have s=
een,
> > like up to 4 byte, I'd expect like double frame size).
> See above.
>=20

Yup, thanks for the detailed explanation!

> >> (Possible) further work:
> >>  1. Integrate this patchset, confirm/correct findings
> >>  2. If anyone would like: Atheros proprietary driver seems to
> >>     support some kind of classification [3] (is this microwave? cordle=
ss
> >>     phone? whatever?)
> That should be done in userspace.
>=20

I agree.

> >>  3. If other devices also offer spectral scan support: define a
> >>     common interface to use it (not debugfs).
> Makes sense. The data should be in an extensible binary format that can
> also cover vendor specific extra information. One suggestion would be to
> prefix the FFT message data with a netlink-style TLV header describing
> the message format (using an enum for data types and an enum for fields,
> both of which we can extend if we need to add more data).
> That way userspace can use the header to figure out the message size and
> can ignore any fields that it does not support.

Yeah, sounds good. Although I'm still not sure how we could compose the
userspace interface. We might want to configure things like:
 * count, interval, endless mode?
 * trigger for a scan
 * listen for samples (endlessly?) ...

The recent patch contains a control file and a listen file - maybe we could
have similar commands for iw?

Also I'm not sure if the performance is very good for the case that we want
to stream a lot of samples. About the data format, keeping it somewhat flex=
ible
for adding fields in the future is a good idea IMHO.

Also as the exponent seems to be confirmed now, I'd directly apply it to th=
e FFT
values when giving it to userspace, like FFT_bin[i] << exponent (if this is=
 the
correct form)

> I hope this helps.

Definitely! That was what I was hoping for! Thanks for sharing this info. :)

Cheers,
	Simon

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDKUXsACgkQrzg/fFk7axbuMACglQ+McODeYoasrYCbzFUoaCLN
JDIAn2r1sjfm3fiOWaryoEFuJlJiJRkO
=j6rg
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
