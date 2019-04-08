Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF527C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 23:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96956206C0
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 23:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="FwAF64CZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfDHXWg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:22:36 -0400
Received: from vps.xff.cz ([195.181.215.36]:35592 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfDHXWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 19:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554765752; bh=XTJlGnE5vkjn9oUO3IP89glVt8S8Omp84lzYQbjt9ZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FwAF64CZzPB+0cMcLJgUmTu44HblaHcZRa+LLgszxCRh3zgn6pI04gqIHueQe/CH+
         OqGYRWbxGqqmo5ZBfrxfaw67R2p3/9SDijJvDrDHHZtdWAwsyxlN9A0noAm7D3XfSu
         HnJExPuq/OTwpXu2GxDTeYz8Pn4zzJkpEH/09eHE=
Date:   Tue, 9 Apr 2019 01:22:32 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
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
Subject: Re: [PATCH 07/12] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Message-ID: <20190408232232.fsl2ddthwo2rr4ql@core.my.home>
Mail-Followup-To: Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
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
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-8-megous@megous.com>
 <20190408074042.74s5qckukcpore3e@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408074042.74s5qckukcpore3e@flea>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 08, 2019 at 09:40:42AM +0200, Maxime Ripard wrote:
> On Sat, Apr 06, 2019 at 01:45:09AM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 has two regulators that power the Realtek RTL8211E.
> > According to the phy datasheet, both regulators need to be enabled
> > at the same time, but we can only specify a single phy-supply in
> > the DT.
> >
> > This can be achieved by making one regulator depedning on the
> > other via vin-supply. While it's not a technically correct
> > description of the hardware, it achieves the purpose.
> >
> > All values of RX/TX delay were tested exhaustively and a middle
> > one of the working values was chosen.
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 44 +++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > index 644946749088..5270142527f5 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > @@ -15,6 +15,7 @@
> >
> >  	aliases {
> >  		serial0 = &uart0;
> > +		ethernet0 = &emac;
> >  	};
> >
> >  	chosen {
> > @@ -64,6 +65,27 @@
> >  		regulator-max-microvolt = <5000000>;
> >  		regulator-always-on;
> >  	};
> > +
> > +	/*
> > +	 * The board uses 2.5V RGMII signalling. Power sequence
> > +	 * to enable the phy is to enable GMAC-2V5 and GMAC-3V3 (aldo2)
> > +	 * power rails at the same time and to wait 100ms.
> > +	 */
> > +	reg_gmac_2v5: gmac-2v5 {
> > +                compatible = "regulator-fixed";
> > +                regulator-name = "gmac-2v5";
> > +                regulator-min-microvolt = <2500000>;
> > +                regulator-max-microvolt = <2500000>;
> > +                startup-delay-us = <100000>;
> > +                enable-active-high;
> > +                gpio = <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
> 
> Is enable-active-high still needed? It's redundant with the
> GPIO_ACTIVE_HIGH flag.

Looking at the code, use/non-use of enable-active-high inhibits
flags specified in gpio property. So the GPIO_ACTIVE_HIGH flag
is ignored here (had GPIO_ACTIVE_LOW been used, the kernel would
ignore it too and print a warning).

So enable-active-high is still necessary here.

See comment in gpiolib-of.c where this is handled:

/*
 * The regulator GPIO handles are specified such that the
 * presence or absence of "enable-active-high" solely controls
 * the polarity of the GPIO line. Any phandle flags must
 * be actively ignored.
 */

regards,
	o.

> The indentation is wrong here as well.
> 
> Maxime
> 
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


