Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58147 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2LEKkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 05:40:18 -0500
Date: Wed, 5 Dec 2012 11:40:08 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 3/3] ath9k: add spectral scan feature
Message-ID: <20121205104008.GA29382@pandem0nium> (sfid-20121205_114027_431291_04301B1B)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Adrian,

thanks a lot for your feedback!

On Fri, Nov 30, 2012 at 08:00:51PM -0800, Adrian Chadd wrote:
> Not that I'm specifically getting into this in any deep way right now, bu=
t..
>=20
> On 27 November 2012 11:01, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>=20
> [snip] - this should apply to AR9380 and later I think.
>=20

Actually I have pretty much the same code in both ar9002_phy.c and ar9003_p=
hy.c,
because they get different register definitions (addresses etc) from their =
respective
header files.

You think that this wouldn't apply for AR9280? Is there something wrong or =
different
with the register access?

I have put scan count of 8 in here, but on AR9380 I get much more samples (=
more like
256). I haven't played with this very much, because "a couple" of samples w=
as all I
needed for my graphical analyzer.

> > +void ar9002_hw_spectral_scan(struct ath_hw *ah)
> > +{
> > +       struct ath_common *common =3D ath9k_hw_common(ah);
> > +
> > +       REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
> > +
> > +       /* NOTE: this will generate a few samples ... lacking documenta=
tion,
> > +        * I'm not really sure what these parameters mean.
> > +        */
> > +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENAB=
LE);
> > +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> > +                   AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
> > +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> > +                     AR_PHY_SPECTRAL_SCAN_COUNT, 8);
> > +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> > +                     AR_PHY_SPECTRAL_SCAN_PERIOD, 0xF);
> > +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> > +                     AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, 0xFF);
> > +
> > +       /* Activate spectral scan */
> > +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> > +                   AR_PHY_SPECTRAL_SCAN_ACTIVE);
> > +
> > +       /* Poll for spectral scan complete */
> > +       if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
> > +                          AR_PHY_SPECTRAL_SCAN_ACTIVE,
> > +                          0, AH_WAIT_TIMEOUT)) {
> > +               ath_err(common, "spectral scan wait failed\n");
> > +               return;
> > +       }
> > +
> > +       /* Disable spectral scan */
> > +       REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> > +                   AR_PHY_SPECTRAL_SCAN_ENABLE);
> > +}
> > +
>=20
> You shouldn't have to do this. There's two spectral scan modes (well, thr=
ee) -
>=20
> * when you're not decoding things, and you meet these parameters,
> please send me some events (I think the patent mentions this);
> * trigger _now_ and send me "X" events; then clear the spectral scan bit;
> * trigger _now_ and just send me infinite events - on earlier chips
> (AR9280 I think) the magic value may be 0; on the later values it may
> be 255. Someone should experiment.
>=20
> I suggest you separate out "configure/enable/disable" and "trigger" as op=
tions.

OK, yeah I can do that - guess we should have different function calls for =
this
then, too. Don't know if all of this should be callable from mac80211 as we=
ll.

>=20
> Grr, mumble mumble open source developers mumble mumble.. :-)

What are you muttering about? :D

Should we rather keep this wonderful feature to the closed source world?
I don't think so :)

>=20
> I suggest experimenting around with those particular parameters. You
> should be able to coax out specific numbers of spectral scan events
> when you set the COUNT parameter to something other than 8. But
> polling that bit isn't needed. It should be asynchronous.

As I said, on AR9220 it appears I get 8 samples when doing setting=20
AR_PHY_SPECTRAL_SCAN_COUNT to 8 (plus maybe some other "stuff"/non-samples).
On AR9380 I'm not so sure. Probably need to play with it a little
more. Also, I don't know what "SHORT REPEAT" is supposed to mean, etc.

About polling, you mean the SCAN_ACTIVE bit? It is probably only
needed when I want to trigger for few samples and want to be informed when
it's finished -  which is a good thing when doing spectral scan (change cha=
nnel,
start and wait for samples, change again). But we probably don't need to wa=
it
for the "background spectral scanning" mode, that's right. If someone wants
to implement detection for interfering radio users, that mode would be usef=
ul.
I don't need it, but can prepare the neccesary functions.

So I'd repost then:
 * ath9k/debugfs only patch for now, as Johannes suggested - I think we
   should concentrate on this for now (their are still a lot of open
   questions in my initial mail regarding sample interpretation etc)
 * split commands into enable/disable/configure/trigger
 * maybe add some defines for magic values (if I find any)

I'd like this patchset to make the graphical spectral scan possible (as
a Ubiquiti Airview), and give others the opportunity to add own features
(pattern matching etc) on top of it. However I (currently) don't plan to
do the latter myself.

>=20
> Good luck,
>=20
>=20
>=20
> Adrian

Thanks!
	Simon


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC/JIcACgkQrzg/fFk7axZJXgCfcSMZAcZ0kluWY+dWZzOGJ5tw
XVMAoK3TKTQbtYvzfPwTcqGD2V3i4f2q
=5hL7
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
