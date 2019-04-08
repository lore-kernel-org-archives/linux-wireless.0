Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E12C282DE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 06:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DE620870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 06:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="VbtIk6D/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfDHGBf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:01:35 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:35581 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfDHGBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 02:01:34 -0400
Received: by mail-it1-f193.google.com with SMTP id w15so19076802itc.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Apr 2019 23:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4T36vFbzXz9I4WYORZ+tCw1SAFVgCJwxQq7ShjEX1i0=;
        b=VbtIk6D/mX5+ufb9Vmk6hkvP2DPi3SRez32l7eae/k9phducOd/lsHYT4byjSKl/Ff
         Zj0tkGY4ndnRGG3TGzdVndelgoz0Ns3M8eK+/T9Om+mCL+crmTI0j7/XrDEAHoK5lTH/
         06XNjddytFqzXXpsgpZ2DC0M15MRNFQQi5+7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=4T36vFbzXz9I4WYORZ+tCw1SAFVgCJwxQq7ShjEX1i0=;
        b=tdrPR/PT0HXXFK56sToyLRZbaoKqFpwzHfJqon/dcOjxe3etwTAnuOceD/bVFYvLPb
         FWf2hlVzNrfkae5QP80FqpzIb/388pIa14Fy2A9NEvFSUhbRT677LSgGECD1GnJQiqJX
         tjEZTFYbgVyVuTr2rGrMQVxMr8EKUjfPxwhUw9onbhFmWyHz5SuzbPhXCEFRRMDnvw90
         rrvPWxqPLXsCi/j0hKxusijIriHDaRRAOG13fND3cYg7nevP+QIdbZZfbs3uXd0vQvEV
         YZhCzb0HshE//Y1+D3wAYsMpw3/JNjYU4FST2TGvBSNgEzReIyxuzjDouSJFR5Jldakb
         9kww==
X-Gm-Message-State: APjAAAU+KK9/BDHfFMc0N/E9YnazGP8l6CuTSCnotp6oIpfh52GIntxs
        8jaVsBJqPxFKtZSIv48ehNqHXwj6ayYRczXPujelpA==
X-Google-Smtp-Source: APXvYqxuHX5chO2bTnqc2xiKpfYIYN9eWQBWiafvz1uph6MM3vnXKa3S0XyS+iakXfq5webXTSCWnIL6VOKjkgPF0ns=
X-Received: by 2002:a24:cd01:: with SMTP id l1mr8827379itg.150.1554703293850;
 Sun, 07 Apr 2019 23:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <CAJiuCcew10Q3PUOk4VPoiyFc7ZhXwJzxXHQHNeVBUvVAQ3BkbQ@mail.gmail.com>
 <20190407143237.2qyoef4r5e3qvbmh@core.my.home>
In-Reply-To: <20190407143237.2qyoef4r5e3qvbmh@core.my.home>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Mon, 8 Apr 2019 11:31:22 +0530
Message-ID: <CAMty3ZDpppM5zBvxCBx3NjdVsRm4S93yz5kqi5Z5a0rhC-+zPg@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 00/12] Add support for Orange Pi 3
To:     megous@megous.com,
        =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 7, 2019 at 8:02 PM 'Ond=C5=99ej Jirman' via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> On Sun, Apr 07, 2019 at 03:36:21PM +0200, Cl=C3=A9ment P=C3=A9ron wrote:
> > Hi,
> >
> > On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
> > <linux-sunxi@googlegroups.com> wrote:
> > >
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > This series implements support for Xunlong Orange Pi 3 board.
> >
> > OrangePi 3 Lite2 and One Plus boards support has already been merged.
> > The support is not complete but you should rebase your patches on top
> > of sunxi/for-next
>
> Hi,
>
> OrangePi 3 is somewhat different from these two boards (mostly it has a d=
iffernt
> power tree). It doesn't use the AXP regulators that are defined in the
> sun50i-h6-orangepi.dtsi in the same way.
>
> For example:
>
> - bldo3 (is turned always on in sun50i-h6-orangepi.dtsi but unused for op=
i3)
> - cldo2 and cldo3 are unused on opi3 and have nothing to do with WiFi
> - aldo3 is not for dram
> - bldo1 on the other hand is for dram on opi3
> - some other regulators are used for different/more functions and thus
>   named differntly
> - USB id-det pin is differnt
> - ...

Based on my communication with OrangePI, OPI-3 has PCIE, 4 USB-3.0
ports and AV are the key differences and rest seems to be similar. but
if we have a diff or unused regulators may be we can't enable them in
dtsi (I never looked that close as of now)
