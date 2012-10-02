Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33915 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2JBNfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 09:35:47 -0400
Date: Tue, 2 Oct 2012 15:35:33 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Sven Eckelmann <sven@narfation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	lindner_marek@yahoo.de
Subject: Re: [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Message-ID: <20121002133533.GA19403@pandem0nium> (sfid-20121002_153928_344597_9A934498)
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
 <1349174009-16496-1-git-send-email-sven@narfation.org>
 <CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,

On Tue, Oct 02, 2012 at 06:13:37AM -0700, Adrian Chadd wrote:
> .. well, the rule here is "You shouldn't get PERR/FATAL interrupts."
>=20
> Haven't I posted a summary of what those errors are?
>=20
> Ok. So they're signals from the PCIe core (named host1_fatal and
> host1_perr. Helpfully.) Those errors occured during a DMA transfer.
>=20
> So the question is why you're seeing PERR interrupts when creating an
> adhoc interface. That hints to me that something odd is going on..

thanks for the explanation!

>=20
> I've seen these issues creep up when the NIC is in some way behaving
> very, very badly (lots of timeouts and sync errors with little to no
> traffic at all), which resulted in all kinds of odd and weird,
> unstable behaviour. After replacing the NIC with another NIC (in my
> case, an AR9280 -> AR9280 NIC :-) the errors went away and things
> continued swimmingly.

Sounds like a good solution, but I'm afraid it won't work for us. We
are using AR9330 SoCs (Hornet), and as long as we don't have a very sharp k=
nife
we won't be able to replace the NIC ... And cutting a few thousand of
them will also not be funny.

I'm starting to lose a little bit of confidence in these insects ... :/

>=20
> I'd have to go digging through the PCIe core source to figure out
> exactly what host1_peer and host1_fatal mean. I can if you'd like,
> it'll just take some time as I'm not familiar at all with the PCIe
> host interface.

It would at least be interesting if we are supposed to handle the interrupt
somehow, instead of resetting the chip.

Thanks,
	Simon
>=20
> Thanks,
>=20
>=20
>=20
> Adrian
>=20
> On 2 October 2012 03:33, Sven Eckelmann <sven@narfation.org> wrote:
> > Interrupts with the sync_cause AR_INTR_SYNC_HOST1_FATAL has to be handl=
ed
> > using a chip reset. Otherwise a interrupt storm with unhandled interrup=
ts
> > will cause a hang or crash of the machine.
> >
> > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> > ---
> > I was informed that AR_INTR_SYNC_HOST1_PERR should not be handled this =
way
> > because it can create system freezes after an adhoc interface was creat=
ed.
> >
> > I really need some Atheros developer who can check the documentation to
> > verify the interpretation of these flags. Otherwise this is just guessi=
ng
> > and may lead to even bigger problems.
> >
> >  drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/=
wireless/ath/ath9k/ar9003_mac.c
> > index d5b2e0e..6031bdf 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> > @@ -311,6 +311,11 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, e=
num ath9k_int *masked)
> >         if (sync_cause) {
> >                 ath9k_debug_sync_cause(common, sync_cause);
> >
> > +               if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
> > +                       ath_dbg(common, ANY, "received PCI FATAL interr=
upt\n");
> > +                       *masked |=3D ATH9K_INT_FATAL;
> > +               }
> > +
> >                 if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
> >                         REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
> >                         REG_WRITE(ah, AR_RC, 0);
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBq7aUACgkQrzg/fFk7axYbwQCgsgikKDsk69J4ZTQIFGV0CicW
WsoAnRIh/VW6Kbb4YbFlraZUqlU1iTqY
=zYYB
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
