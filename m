Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5C0C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 13:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4CB21473
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 13:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="lxyLNdP9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfDHNIZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:08:25 -0400
Received: from vps.xff.cz ([195.181.215.36]:57442 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfDHNIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 09:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554728902; bh=ow5VGNA0hGlAG1tdR4FhzUwe8VNbcPhQ0YtZab7jyLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lxyLNdP927qRf21aqA+3j9GkShsdbT9zAWAA6adx1wa3K0yDumu/eztMj9MeBEBW2
         +BIBa3XyOHOFOnmJw7OoervxpsB9gca3lRwR3kIVRJ98OL3OjlZ0d5D99MCZICZjoR
         tFQg/1vAvUSPqZ+yB7ujy4p8CQr+A8OH5hE9IMaw=
Date:   Mon, 8 Apr 2019 15:08:21 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
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
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 09/12] pinctrl: sunxi: Prepare for alternative bias
 voltage setting methods
Message-ID: <20190408130821.minpds2ygqdv6yir@core.my.home>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
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
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-10-megous@megous.com>
 <CACRpkdY=G0rpxVZL8TKJOQcf+Na8o5_FwG0EyBfb-ZCYXi=_oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY=G0rpxVZL8TKJOQcf+Na8o5_FwG0EyBfb-ZCYXi=_oA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Linus,

On Mon, Apr 08, 2019 at 02:53:58PM +0200, Linus Walleij wrote:
> On Sat, Apr 6, 2019 at 1:45 AM <megous@megous.com> wrote:
> 
> > From: Ondrej Jirman <megous@megous.com>
> >
> > H6 has a different I/O voltage bias setting method than A80. Prepare
> > existing code for using alternative bias voltage setting methods.
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c |  2 +-
> >  drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 38 ++++++++++++-----------
> >  drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  4 ++-
> 
> I need Maxime's ACK on these patches to merge.
> 
> Can the pinctrl parts be applied independently of the rest
> of the changes when Maxime is happy with the patches?

Yes, the two pinctrl patches are independent of the rest of the series.

thank you,
	Ondrej

> Yours,
> Linus Walleij
