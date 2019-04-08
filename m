Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5300C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 22:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731C320880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 22:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="LNoFxjpz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfDHWlI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:41:08 -0400
Received: from vps.xff.cz ([195.181.215.36]:35354 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbfDHWlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 18:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554763265; bh=xXHKNKecIf3E8WGjO9atsdmzoGsgzYqJLiCEhCcGQ3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNoFxjpz/UstwT9jgTYkDwwPq+LGCAAihqpFEBfNY7JC6XjtdAxvZMBvEP6qOIeOk
         P3iBGcvYhEaKGcSgrKyuwH+QcH6xxMqZoXYV1bjCLRfWHL5TqCxch6YV5WrZfLNbNW
         da8nAYlcXoI1mhq9WkWmhlNEkvwL6gRHicx97usI=
Date:   Tue, 9 Apr 2019 00:41:05 +0200
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
Subject: Re: [PATCH 08/12] arm64: dts: allwinner: h6: Add MMC1 pins
Message-ID: <20190408224104.qwhk33qgem7bq5y7@core.my.home>
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
 <20190405234514.6183-9-megous@megous.com>
 <20190408074327.vvubj2sbkvfkwscv@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408074327.vvubj2sbkvfkwscv@flea>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 08, 2019 at 09:43:27AM +0200, Maxime Ripard wrote:
> On Sat, Apr 06, 2019 at 01:45:10AM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > ---
> >  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> > index 91fecab58836..dccad79da90c 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> > @@ -238,6 +238,15 @@
> >  				bias-pull-up;
> >  			};
> >
> > +
> 
> Extra line
> 
> > +			mmc1_pins: mmc1-pins {
> > +				pins = "PG0", "PG1", "PG2", "PG3",
> > +				       "PG4", "PG5";
> > +				function = "mmc1";
> > +				drive-strength = <30>;
> > +				bias-pull-up;
> > +			};
> > +
> 
> Is that the only muxing option?

I don't think so. I believe someone can use a 1-bit interface (bus-width = <1>),
and then some data pins will be free. This pinconfig is for 4-bit bus width
setup.

Though other SoCs (ex. H3, A83T) don't consider this possibility and make the
4-bit config the default pinctrl for mmc1. To add to the confusion, on these
SoCs 4-bit pinconf is the default, but 1bit bus-width is the (implicit) default.
This led to some confusion in the past.

So we can either:
- keep consistency with what is done elsewhere, and make this default, despite
  not being the only option,
- or perhaps I can rename this to mmc1_bus_width4_pins, or somesuch, to make it
  more explicit, and keep it non-default.

What do you think is better?

thank you and regards,
	o.

> If so, then it should be assigned by default to mmc1
> 
> Thanks!
> Maxime
> 
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


