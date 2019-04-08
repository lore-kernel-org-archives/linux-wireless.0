Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7618CC10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9AE20883
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="A1YEwYYx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfDHMqt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:46:49 -0400
Received: from vps.xff.cz ([195.181.215.36]:57210 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfDHMqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554727605; bh=lTN1NozdCp8DzN8dgazrTIyS14fAuLyXPB7ty8F8eUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1YEwYYxjE7vYpe8injS1072Ba+AQc14gZEfvJn8CX8rQ6nu6LqlZSFvYdXkK1+Db
         99S0PB3HOLS7EyZDoVH9yFs648xcjeL4WZFXOqiE491ncZvdms5Zb6SYBnz2xWxHZP
         p57atcsYpKRUpu8R2q0M4yeOqC3EgGYz37NGiTQg=
Date:   Mon, 8 Apr 2019 14:46:45 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     =?utf-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH 00/12] Add support for Orange Pi 3
Message-ID: <20190408124645.gv2tezjqhoxxx2yg@core.my.home>
Mail-Followup-To: Jagan Teki <jagan@amarulasolutions.com>,
        =?utf-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190405234514.6183-1-megous@megous.com>
 <CAJiuCcew10Q3PUOk4VPoiyFc7ZhXwJzxXHQHNeVBUvVAQ3BkbQ@mail.gmail.com>
 <20190407143237.2qyoef4r5e3qvbmh@core.my.home>
 <CAMty3ZDpppM5zBvxCBx3NjdVsRm4S93yz5kqi5Z5a0rhC-+zPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMty3ZDpppM5zBvxCBx3NjdVsRm4S93yz5kqi5Z5a0rhC-+zPg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Jagan,

On Mon, Apr 08, 2019 at 11:31:22AM +0530, Jagan Teki wrote:
> On Sun, Apr 7, 2019 at 8:02 PM 'Ondřej Jirman' via linux-sunxi
> <linux-sunxi@googlegroups.com> wrote:
> >
> > On Sun, Apr 07, 2019 at 03:36:21PM +0200, Clément Péron wrote:
> > > Hi,
> > >
> > > On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
> > > <linux-sunxi@googlegroups.com> wrote:
> > > >
> > > > From: Ondrej Jirman <megous@megous.com>
> > > >
> > > > This series implements support for Xunlong Orange Pi 3 board.
> > >
> > > OrangePi 3 Lite2 and One Plus boards support has already been merged.
> > > The support is not complete but you should rebase your patches on top
> > > of sunxi/for-next
> >
> > Hi,
> >
> > OrangePi 3 is somewhat different from these two boards (mostly it has a differnt
> > power tree). It doesn't use the AXP regulators that are defined in the
> > sun50i-h6-orangepi.dtsi in the same way.
> >
> > For example:
> >
> > - bldo3 (is turned always on in sun50i-h6-orangepi.dtsi but unused for opi3)
> > - cldo2 and cldo3 are unused on opi3 and have nothing to do with WiFi
> > - aldo3 is not for dram
> > - bldo1 on the other hand is for dram on opi3
> > - some other regulators are used for different/more functions and thus
> >   named differntly
> > - USB id-det pin is differnt
> > - ...
> 
> Based on my communication with OrangePI, OPI-3 has PCIE, 4 USB-3.0
> ports and AV are the key differences and rest seems to be similar. but
> if we have a diff or unused regulators may be we can't enable them in
> dtsi (I never looked that close as of now)

These regulators are not just disabled on Opi 3, they have different/no meaning.

Schematics allow for high amount of variability in the power tree (see all the
NC (not connected) / 0R resistors) in the schematic around AXP805. Every board
based on this Xunlong design can be subtly different. 

I already suggested a maintainable solution, below. Where base dtsi has empty
config for regulators and every board based on that just defines it completely
for itself.

A few regulators (for CPU/GPU) will most probably have the same meaning on every
derived board, so these can probably be kept in dtsi without causing too much
annoyance.

It's unpleasant to have wrong regulator setup defined in an underlying dtsi, and
then trying to override it by removing/adding random properties in the board dts
for the new boards based on that, so that it fits.

The rest of the current HW descriptions in the sun50i-h6-orangepi.dtsi can be
shared (as of now).

thank you and regards,
  o.
