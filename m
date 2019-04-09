Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0EBC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB88720833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfDIHWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:22:47 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:50539 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfDIHWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:22:47 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 4CEAD100004;
        Tue,  9 Apr 2019 07:22:38 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:22:37 +0200
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
Subject: Re: [PATCH 01/12] arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
Message-ID: <20190409072237.fn2pe7ugtukdlnm2@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-2-megous@megous.com>
 <20190408074628.e5ers4gzlqz4coyk@flea>
 <20190408225851.svelyf7h3fiw4wjw@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vazlaal22ii7l2e2"
Content-Disposition: inline
In-Reply-To: <20190408225851.svelyf7h3fiw4wjw@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--vazlaal22ii7l2e2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2019 at 12:58:51AM +0200, Ond=C5=99ej Jirman wrote:
> > > +&usb2otg {
> > > +	dr_mode =3D "host";
> > > +	status =3D "okay";
> > > +};
> > > +
> > > +&usb2phy {
> > > +	usb0_id_det-gpios =3D <&pio 2 15 GPIO_ACTIVE_HIGH>; /* PC15 */
> > > +	usb0_vbus-supply =3D <&reg_vcc5v>;
> > > +	usb3_vbus-supply =3D <&reg_vcc5v>;
> > > +	status =3D "okay";
> >
> > If we have an ID pin, then why is the OTG controller set to host?
>
> This board has fixed conenction between VBUS and DCIN, so if it is powered
> from DCIN and someone will try to connect it to the PC as a peripheral,
> they'll get PC's VBUS shorted to the power supply connected to DCIN.
>
> Depending on voltage difference between DCIN and PC's VBUS, you can get
> overcurrent condidion and PC's port shutdown.
>
> The board is not entirely foolproof in this regard.
>
> - It can be host powered when connected via microUSB
> - It can be self-powered and host an device on microUSB
> - It can be self-powered and serve as a peripheral if you modify
>   a cable (cut VBUS) or the host is expecting this and has some
>   VBUS detection logic (most hosts will not have this)
>
> I just didn't want to encourage use as a peripheral, because it's not
> very foolproof. But I guess, DTS file will not stop anyone anyway.
>
> I'll change it to otg, and maybe leave a small note.

Your solution was great actually. I guess making a comment explaining
what you just did would be better though, so that no one is confused.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--vazlaal22ii7l2e2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxIPQAKCRDj7w1vZxhR
xQcXAQDol3REexlF7y84fFUCcIEyEMiedbnGpFQLj6gLdmA1LQD6AnjKbKwNsJqo
Is/r3wfDkq5t5cMb3FvH7ld60Tv3rA0=
=d1oR
-----END PGP SIGNATURE-----

--vazlaal22ii7l2e2--
