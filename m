Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E90C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F7D2073F
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="pCtjZcsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfDKKo6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:44:58 -0400
Received: from vps.xff.cz ([195.181.215.36]:49642 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfDKKo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554979493; bh=0gGCEy17EJytU3Qa7YkPYr52jDS0L4gECQ49SrhKOVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCtjZcsuCeA8BCz5/n9dCnKF/hqLw3jZbW+LmEz6djvNqCXHVPTnWF3aV3CE6SZsw
         UbfK7X8BuBFXbeHwRRG+3NRnbUoGoXmDUGgZoWOu6UtnDAhmGeSTb+/Znka8rirdN0
         XYCKOTz32OYTHdLvL+5XJF787IDWJWUcSCs6MOj4=
Date:   Thu, 11 Apr 2019 12:44:53 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
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
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v3 03/11] pinctrl: sunxi: Prepare for
 alternative bias voltage setting methods
Message-ID: <20190411104453.fhwhw3gkffikusfl@core.my.home>
Mail-Followup-To: Julian Calaby <julian.calaby@gmail.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190411101951.30223-1-megous@megous.com>
 <20190411101951.30223-4-megous@megous.com>
 <CAGRGNgUhPC+G+H_zYSi7KFx-K10uPOXRsPqPFcirGaWScw59dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRGNgUhPC+G+H_zYSi7KFx-K10uPOXRsPqPFcirGaWScw59dQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 11, 2019 at 08:34:33PM +1000, Julian Calaby wrote:
> Hi Ondrej
> 
> On Thu, Apr 11, 2019 at 8:19 PM megous via linux-sunxi
> <linux-sunxi@googlegroups.com> wrote:
> >
> > From: Ondrej Jirman <megous@megous.com>
> >
> > H6 has a different I/O voltage bias setting method than A80. Prepare
> > existing code for using alternative bias voltage setting methods.
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> > index ee15ab067b5f..4bfc8a6d9dce 100644
> > --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> > +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> > @@ -95,6 +95,13 @@
> >  #define PINCTRL_SUN7I_A20      BIT(7)
> >  #define PINCTRL_SUN8I_R40      BIT(8)
> >
> > +enum sunxi_desc_bias_voltage {
> > +       BIAS_VOLTAGE_NONE,
> > +       /* Bias voltage configuration is done through
> > +        * Pn_GRP_CONFIG registers, as seen on A80 SoC. */
> > +       BIAS_VOLTAGE_GRP_CONFIG,
> > +};
> > +
> >  struct sunxi_desc_function {
> >         unsigned long   variant;
> >         const char      *name;
> > @@ -117,7 +124,7 @@ struct sunxi_pinctrl_desc {
> >         const unsigned int              *irq_bank_map;
> >         bool                            irq_read_needs_mux;
> >         bool                            disable_strict_mode;
> > -       bool                            has_io_bias_cfg;
> > +       int                             io_bias_cfg_variant;
> 
> Shouldn't we be defining this field using the enum rather than as an int?

Yes, thank you, I fixed it for v4.

regards,
  	o.

> Thanks,
> 
> -- 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
