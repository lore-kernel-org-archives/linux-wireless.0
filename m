Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6DFC282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49BFA20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfDHHne (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:43:34 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:33911 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHHnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:43:33 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 904151C0008;
        Mon,  8 Apr 2019 07:43:27 +0000 (UTC)
Date:   Mon, 8 Apr 2019 09:43:27 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
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
Subject: Re: [PATCH 08/12] arm64: dts: allwinner: h6: Add MMC1 pins
Message-ID: <20190408074327.vvubj2sbkvfkwscv@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-9-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uu57uts7ricxgi6i"
Content-Disposition: inline
In-Reply-To: <20190405234514.6183-9-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--uu57uts7ricxgi6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 06, 2019 at 01:45:10AM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> index 91fecab58836..dccad79da90c 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> @@ -238,6 +238,15 @@
>  				bias-pull-up;
>  			};
>
> +

Extra line

> +			mmc1_pins: mmc1-pins {
> +				pins = "PG0", "PG1", "PG2", "PG3",
> +				       "PG4", "PG5";
> +				function = "mmc1";
> +				drive-strength = <30>;
> +				bias-pull-up;
> +			};
> +

Is that the only muxing option?

If so, then it should be assigned by default to mmc1

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--uu57uts7ricxgi6i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKr7nwAKCRDj7w1vZxhR
xaCTAP40wF5BuAv/KQoefes5N0e4XEbG+/RosHq7h/s1hnl/gwD/c/lOEPMEspbT
p+gNsyXohxVvUOIM+rndNYRmYYmbjAM=
=4w6k
-----END PGP SIGNATURE-----

--uu57uts7ricxgi6i--
