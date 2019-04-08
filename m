Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C75C10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826AB2087F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="hs/L0DY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfDHMRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:17:31 -0400
Received: from vps.xff.cz ([195.181.215.36]:56788 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfDHMRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554725847; bh=9qCfRdQgJU20bNvwW0+4X2PjgfY2f043EtUF7T42qjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hs/L0DY/Cu2BG5a3WS+/s3gwvPUyTQngfNIPvcvhLTM88VkdK00CAizos2nZUm4Ct
         ZQDB1oQ4DviyJOV1VF+hxETrhuR8yGYN+vtwOXKaFHPkOb23MZZZ3FkJSmCMZ90/O3
         9UGuOsbnvVDYYxa9qvu3Wz6VR5ni0VU/6p2i+VKM=
Date:   Mon, 8 Apr 2019 14:17:27 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Chen-Yu Tsai <wens@csie.org>,
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
Message-ID: <20190408121727.4vdqdokr6w5thck6@core.my.home>
Mail-Followup-To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-3-megous@megous.com>
 <20190408072338.3urcotemju3qi2un@flea>
 <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
 <20190408084714.b6xdi2pxbjvzwsnu@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408084714.b6xdi2pxbjvzwsnu@flea>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 08, 2019 at 10:47:14AM +0200, Maxime Ripard wrote:
> On Mon, Apr 08, 2019 at 03:28:24PM +0800, Chen-Yu Tsai wrote:
> > On Mon, Apr 8, 2019 at 3:23 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > On Sat, Apr 06, 2019 at 01:45:04AM +0200, megous@megous.com wrote:
> > > > From: Ondrej Jirman <megous@megous.com>
> > > >
> > > > Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
> > > > transistors, before it can be used. Model this as a power supply for DDC
> > > > (via regulator framework).
> > > >
> > > > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > >
> > > The DDC bus itself is usually attached to the HDMI connector, so it
> > > would make sense to make the supply also a property of the connector.
> >
> > I believe these are separate things. What this patch covers is power for
> > a voltage shifter between the SoC and HDMI DDC pins. The HDMI connector's
> > 5V supply to power the remote DDC chip is something else. And on the
> > Orange Pi 3 they are indeed separate supplies.
> 
> Then maybe the endpoint link between the two would be the best place
> to put this?

Interestingly &hdmi node configures the DDC bus pins via pinctrl on the SoC
side, so I put this there too, because it's related to those pins. I'm not sure
if that changes anything in the discussion.

regards,
   o.

> Maxime
> 
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


