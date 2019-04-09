Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11077C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD74A20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfDIHp0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:45:26 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:38107 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfDIHp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:45:26 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 300C02000A;
        Tue,  9 Apr 2019 07:45:18 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:45:17 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [PATCH 02/12] drm: sun4i: Add support for
 enabling DDC I2C bus to dw_hdmi glue
Message-ID: <20190409074517.lu4gsmyq2qcunqg4@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-3-megous@megous.com>
 <20190408072338.3urcotemju3qi2un@flea>
 <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
 <20190408084714.b6xdi2pxbjvzwsnu@flea>
 <20190408121727.4vdqdokr6w5thck6@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ex55duqs5l5l627l"
Content-Disposition: inline
In-Reply-To: <20190408121727.4vdqdokr6w5thck6@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--ex55duqs5l5l627l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2019 at 02:17:27PM +0200, Ond=C5=99ej Jirman wrote:
> On Mon, Apr 08, 2019 at 10:47:14AM +0200, Maxime Ripard wrote:
> > On Mon, Apr 08, 2019 at 03:28:24PM +0800, Chen-Yu Tsai wrote:
> > > On Mon, Apr 8, 2019 at 3:23 PM Maxime Ripard <maxime.ripard@bootlin.c=
om> wrote:
> > > >
> > > > On Sat, Apr 06, 2019 at 01:45:04AM +0200, megous@megous.com wrote:
> > > > > From: Ondrej Jirman <megous@megous.com>
> > > > >
> > > > > Orange Pi 3 board requires enabling DDC I2C bus via some GPIO con=
nected
> > > > > transistors, before it can be used. Model this as a power supply =
for DDC
> > > > > (via regulator framework).
> > > > >
> > > > > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > > >
> > > > The DDC bus itself is usually attached to the HDMI connector, so it
> > > > would make sense to make the supply also a property of the connecto=
r.
> > >
> > > I believe these are separate things. What this patch covers is power =
for
> > > a voltage shifter between the SoC and HDMI DDC pins. The HDMI connect=
or's
> > > 5V supply to power the remote DDC chip is something else. And on the
> > > Orange Pi 3 they are indeed separate supplies.
> >
> > Then maybe the endpoint link between the two would be the best place
> > to put this?
>
> Interestingly &hdmi node configures the DDC bus pins via pinctrl on the S=
oC
> side, so I put this there too, because it's related to those pins. I'm no=
t sure
> if that changes anything in the discussion.

It's kind of different though. The DDC controller is within the HDMI
controller, which is inside the SoC. Just like the pin muxer. As far
as the hardware goes, even on your board, you don't need that supply
so that the signal gets out of the SoC.

If the regulator is to power up some component on the path between the
SoC and the connector, then it should be attached there.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ex55duqs5l5l627l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxNjQAKCRDj7w1vZxhR
xd1YAQCbZIs2Pp7jd1cm9rrokDi5iMPRnQBKcSOdLIRXgkvLTAEAjNSL9iiFRvXv
J1tkS7/bj/Wsm4X0Ihv29bnFFGddWwQ=
=LLjI
-----END PGP SIGNATURE-----

--ex55duqs5l5l627l--
