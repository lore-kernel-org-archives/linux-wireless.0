Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCC4C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AE620833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfDIHXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:23:48 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:57557 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfDIHXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:23:48 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 5BA5A10000E;
        Tue,  9 Apr 2019 07:23:41 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:23:40 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 07/12] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Message-ID: <20190409072340.lndjtgy7o7y2b76z@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-8-megous@megous.com>
 <20190408074042.74s5qckukcpore3e@flea>
 <20190408232232.fsl2ddthwo2rr4ql@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cti4uw5canfn7foj"
Content-Disposition: inline
In-Reply-To: <20190408232232.fsl2ddthwo2rr4ql@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--cti4uw5canfn7foj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2019 at 01:22:32AM +0200, Ond=C5=99ej Jirman wrote:
> On Mon, Apr 08, 2019 at 09:40:42AM +0200, Maxime Ripard wrote:
> > On Sat, Apr 06, 2019 at 01:45:09AM +0200, megous@megous.com wrote:
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > Orange Pi 3 has two regulators that power the Realtek RTL8211E.
> > > According to the phy datasheet, both regulators need to be enabled
> > > at the same time, but we can only specify a single phy-supply in
> > > the DT.
> > >
> > > This can be achieved by making one regulator depedning on the
> > > other via vin-supply. While it's not a technically correct
> > > description of the hardware, it achieves the purpose.
> > >
> > > All values of RX/TX delay were tested exhaustively and a middle
> > > one of the working values was chosen.
> > >
> > > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > > ---
> > >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 44 +++++++++++++++++=
++
> > >  1 file changed, 44 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b=
/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > > index 644946749088..5270142527f5 100644
> > > --- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > > @@ -15,6 +15,7 @@
> > >
> > >  	aliases {
> > >  		serial0 =3D &uart0;
> > > +		ethernet0 =3D &emac;
> > >  	};
> > >
> > >  	chosen {
> > > @@ -64,6 +65,27 @@
> > >  		regulator-max-microvolt =3D <5000000>;
> > >  		regulator-always-on;
> > >  	};
> > > +
> > > +	/*
> > > +	 * The board uses 2.5V RGMII signalling. Power sequence
> > > +	 * to enable the phy is to enable GMAC-2V5 and GMAC-3V3 (aldo2)
> > > +	 * power rails at the same time and to wait 100ms.
> > > +	 */
> > > +	reg_gmac_2v5: gmac-2v5 {
> > > +                compatible =3D "regulator-fixed";
> > > +                regulator-name =3D "gmac-2v5";
> > > +                regulator-min-microvolt =3D <2500000>;
> > > +                regulator-max-microvolt =3D <2500000>;
> > > +                startup-delay-us =3D <100000>;
> > > +                enable-active-high;
> > > +                gpio =3D <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
> >
> > Is enable-active-high still needed? It's redundant with the
> > GPIO_ACTIVE_HIGH flag.
>
> Looking at the code, use/non-use of enable-active-high inhibits
> flags specified in gpio property. So the GPIO_ACTIVE_HIGH flag
> is ignored here (had GPIO_ACTIVE_LOW been used, the kernel would
> ignore it too and print a warning).
>
> So enable-active-high is still necessary here.

Too bad :/

> See comment in gpiolib-of.c where this is handled:
>
> /*
>  * The regulator GPIO handles are specified such that the
>  * presence or absence of "enable-active-high" solely controls
>  * the polarity of the GPIO line. Any phandle flags must
>  * be actively ignored.
>  */

Thanks for digging this out

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--cti4uw5canfn7foj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxIfAAKCRDj7w1vZxhR
xW/CAQCrJqoV6FLDqDM5IP7NCK4txMyjvVpL9TidL1s65icMtgEA8w8/LBe0fC/i
0vW0YKPvx+onrCje430iF2jdywhGjgk=
=Jz+2
-----END PGP SIGNATURE-----

--cti4uw5canfn7foj--
