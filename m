Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5859FC282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F04920883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDILsG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:48:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38631 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfDILsG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:48:06 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id DF06560006;
        Tue,  9 Apr 2019 11:47:56 +0000 (UTC)
Date:   Tue, 9 Apr 2019 13:47:56 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
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
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v2 02/13] arm64: dts: allwinner: h6: Add
 Orange Pi 3 DTS
Message-ID: <20190409114756.v6v33nsdtiitglee@flea>
References: <20190409002452.14551-1-megous@megous.com>
 <20190409002452.14551-3-megous@megous.com>
 <CAMty3ZBK2jPHTP4Y+hiy8Gq+Nx9iWYoUgke+BvopyzR8T6=0Xw@mail.gmail.com>
 <20190409113157.e4vrzesbgmyslomb@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aa6vze47q2e2azio"
Content-Disposition: inline
In-Reply-To: <20190409113157.e4vrzesbgmyslomb@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--aa6vze47q2e2azio
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2019 at 01:31:57PM +0200, Ond=C5=99ej Jirman wrote:
> Hi Jagan,
>
> On Tue, Apr 09, 2019 at 02:08:18PM +0530, Jagan Teki wrote:
> > Based on the conversation about using common dtsi from this thread[1],
> > I'm commenting here to make show the diff directly on the nodes,
> > giving comments on each node so-that we can see the diff globally.
>
> Thanks for the suggestions below. It mostly repeats the differences and
> commonalities I already stated in the previous discussion.
>
> I don't have much to add to what I already said previously, though, becau=
se you
> didn't address my concerns there. But I can restate and expand on those
> concerns.
>
> Previously I already agreed it's possible to base orangepi-3.dts on
> orangepi.dtsi, and proposed a maintainable way forward, and why to follow=
 it (to
> quote myself):
>
>   Schematics allow for high amount of variability in the power tree (see =
all the
>   NC (not connected) / 0R resistors) in the schematic around AXP805. Ever=
y board
>   based on this Xunlong design can be subtly different.
>
>   I already suggested a maintainable solution, below. Where base dtsi has=
 empty
>   config for regulators and every board based on that just defines it com=
pletely
>   for itself.
>
>   A few regulators (for CPU/GPU) will most probably have the same meaning=
 on
>   every derived board, so these can probably be kept in dtsi without caus=
ing too
>   much annoyance.
>
>   It's unpleasant to have wrong regulator setup defined in an underlying =
dtsi,
>   and then trying to override it by removing/adding random properties in =
the
>   board dts for the new boards based on that, so that it fits.
>
>   The rest of the current HW descriptions in the sun50i-h6-orangepi.dtsi =
can be
>   shared (as of now).
>
> My suggestion was this:
>
>   So to base Orange Pi 3 dts on top of existing sun50i-h6-orangepi.dtsi I=
'd have
>   to first move some things out of the base dtsi to the OrangePi Lite2 an=
d One
>   Plus board dts files, in order to have sun50i-h6-orangepi.dtsi only des=
cribe
>   HW that is *really* shared by these 2 boards and Orange Pi 3.
>
>   If I do that, I'd undefine all the axp805 regulator nodes and move the
>   configurations to each of the 3 board files. That will probably end up =
being
>   the least confusing and most maintainable. See axp81x.dtsi lines 86-144=
 for
>   what I mean.
>
> You seem to be suggesting a solution where every time we add an OrangePi =
H6
> based board, the person adding it will have to go through the base dtsi a=
nd all
> the other boards based on it, status disable or otherwise change regulato=
rs in
> the base dtsi, patch all the other boards to re-enable it.
>
> It would be already unpleasant just adding a third board based on this ap=
proach.
> And when the fourth board is added, with another small differences in the
> regulator use/meanings, the person will be looking at patching 4 dts files
> + adding one for his own board. For what benefit, to save some bytes righ=
t now?
>
> I think maintainability, ease of adding new boards is more important, than
> having a dtsi that tries to maximally cover all the commonalities between=
 the
> existing boards right now, without regards for the future. That's why
> I suggested an approach like in axp81x.dtsi lines 86-144.

I agree.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--aa6vze47q2e2azio
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKyGbAAKCRDj7w1vZxhR
xZTAAQCOzqr6NWU8ZLOC72DWyNDWvVDoMHEH5977Yq/x03pA3wEAwsPhQ1kQG3mb
mRjfuU5xD+jCyn066cuvMBk6bRHgQgA=
=ef/T
-----END PGP SIGNATURE-----

--aa6vze47q2e2azio--
