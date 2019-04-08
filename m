Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17055C282DE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 08:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58A620880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 08:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfDHIrY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:47:24 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:50833 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfDHIrY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 04:47:24 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 657D610001B;
        Mon,  8 Apr 2019 08:47:14 +0000 (UTC)
Date:   Mon, 8 Apr 2019 10:47:14 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
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
Message-ID: <20190408084714.b6xdi2pxbjvzwsnu@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-3-megous@megous.com>
 <20190408072338.3urcotemju3qi2un@flea>
 <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hnppvtnr77cffabd"
Content-Disposition: inline
In-Reply-To: <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--hnppvtnr77cffabd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2019 at 03:28:24PM +0800, Chen-Yu Tsai wrote:
> On Mon, Apr 8, 2019 at 3:23 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > On Sat, Apr 06, 2019 at 01:45:04AM +0200, megous@megous.com wrote:
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
> > > transistors, before it can be used. Model this as a power supply for DDC
> > > (via regulator framework).
> > >
> > > Signed-off-by: Ondrej Jirman <megous@megous.com>
> >
> > The DDC bus itself is usually attached to the HDMI connector, so it
> > would make sense to make the supply also a property of the connector.
>
> I believe these are separate things. What this patch covers is power for
> a voltage shifter between the SoC and HDMI DDC pins. The HDMI connector's
> 5V supply to power the remote DDC chip is something else. And on the
> Orange Pi 3 they are indeed separate supplies.

Then maybe the endpoint link between the two would be the best place
to put this?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--hnppvtnr77cffabd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKsKkgAKCRDj7w1vZxhR
xWcIAP9Pddl+Ri5TuPgfHFSLxQZJkmay8uc3CPeqtO6YD/nPbgEA8130cRGdOdpG
XuiFcOd3lAO7E61GKVNY99Id+JJCNwI=
=P/5f
-----END PGP SIGNATURE-----

--hnppvtnr77cffabd--
