Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2C0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1D0218CD
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UZvFI2Gj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfBZXo2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 18:44:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36490 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbfBZXo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 18:44:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id n22so7026207pfa.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 15:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OFnLT5XdPjqDxL6/K91hoXuMuyo4KTpfIXDgQ+N2d3Y=;
        b=UZvFI2GjkVuuFoyBvh4bJSdn7ATJZRWjS30gFEmLU37mK1BBfLrV/tvmc9PnixBT8M
         So+FliEBPa/oBXiYdELL9iDYVDLDZxCO9RFLp2EA+64bpeYbFQDVdw4oHDBQkGSYTdkG
         cVFtuhjbYqBrxuCAhUOUjCSKls1M7GaSlU5S0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OFnLT5XdPjqDxL6/K91hoXuMuyo4KTpfIXDgQ+N2d3Y=;
        b=BcqYIkQO7LTsf+TJmnD7IgWYNwOSNdIfPF1MAralZ5bdTwR/WYhoNVuA1x50u5BniO
         9L4GKSdVAcNaMd7ifk9PUjpP8guzlES4CjPk1m9jN3KZJ1aLf1mIC5EV2PO18wkK4QHc
         +x3xcitPwBzueqgCXQnBzZibak/EvTkacc5aJ7lwEFvLFULVHqzxmgupea9YJYCYFKdQ
         TSo/RsEG2LATMuNxjAL1QTNX9zpf54IuHJRyxfKUChlmS/PAnpXBxbz8Wfo9YTka6/Cv
         L3f17mDvG/hBBLuQZYSApfmuuBc7LKDNWflcww6HPjcRLIdN2z+mwd2Ytjh59wtYyXw0
         v3GA==
X-Gm-Message-State: AHQUAuYp0g7UTmQO9ONdI/XxXZWe1p68V4BW2haYQQLhiRd1ydf3759d
        7gehaZGVE2Ry6+cXt/XNrqmUng==
X-Google-Smtp-Source: AHgI3IZ3b25RdTEFdcJ4w+m0hBHnIhGkp5dN+7k66Ly/vLQ284p0Gvn7FT9oPhFP4BcM72QTK1hXgA==
X-Received: by 2002:a65:4147:: with SMTP id x7mr22593pgp.54.1551224666997;
        Tue, 26 Feb 2019 15:44:26 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id q62sm24471018pfi.183.2019.02.26.15.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Feb 2019 15:44:25 -0800 (PST)
Date:   Tue, 26 Feb 2019 15:44:23 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Jeffy Chen <jeffy.chen@rock-chips.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
Message-ID: <20190226234422.GD174696@google.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <CAKv+Gu9OOzOxx0rTAZqM8r4q_hRmOp3b=KP7fwgNeiu67FCApA@mail.gmail.com>
 <5310b73b-4821-6dff-b9c0-34c59fb7fd72@arm.com>
 <CAKv+Gu_=bQyVZqgUnJm9moCcaCcpDrag6NWGEpaR65=pMiTFJQ@mail.gmail.com>
 <0c433a70-27f6-76ad-c46c-6015de1ffaa4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c433a70-27f6-76ad-c46c-6015de1ffaa4@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Tue, Feb 26, 2019 at 05:14:00PM +0000, Marc Zyngier wrote:
> On 26/02/2019 16:21, Ard Biesheuvel wrote:
> > On Mon, 25 Feb 2019 at 15:53, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >> It outlines one thing: If you have to interpret per-device PCI
> >> properties from DT, you're in for serious trouble. I should get some
> >> better HW.
> >>
> > 
> > Yeah, it obviously makes no sense at all for the interrupt parent of a
> > PCI device to deviate from the host bridge's interrupt parent, and
> > it's quite unfortunate that we can't simply ban it now that the cat is
> > out of the bag already.
> > 
> > Arguably, the wake up widget is not part of the PCI device, but I have
> > no opinion as to whether it is better modeling it as a sub device as
> > you are proposing or as an entirely separate device referenced via a
> > phandle.
> 
> It is not that clear. The widget seems to be an integral part of the
> device, as it is the same basic IP that is used for SDIO and USB.

It's not really a widget specific to this IP. It's just a GPIO. It so
happens that both SDIO and PCIe designs have wanted to use a GPIO for
wakeup, as many other devices do. (Note: it's not just cheap ARM
devices; pulling up some Intel Chromebook designs, I see the exact same
WAKE# GPIO on their PCIe WiFi as well.)

> It looks like the good old pre-PCI-2.2 days, where you had to have a
> separate cable between your network card and the base-board for the
> wake-up interrupt to be delivered. Starting with PCI-2.2, the bus can
> carry the signal just fine. With PCIe, it should just be an interrupt
> TLP sent to the RC, but that's obviously not within the capabilities of
> the HW.

You should search the PCI Express specification for WAKE#. There is a
clearly-documented "side-band wake" feature that is part of the
standard, as an alternative to in-band TLP wakeup. While you claim this
is an ancient thing, it in fact still in use on many systems -- it's
just usually abstracted better by ACPI firmware, whereas the dirty
laundry is aired a bit more on a Device Tree system. And we got it
wrong.

> Anyway, it'd be good if the Marvell people could chime in and let us
> know how they'd prefer to handle this.

I'm not sure this is really a Marvell-specific problem. (Well, except
for the marvell,wakeup-pin silliness, which is somewhat orthogonal.) In
fact, if we cared a little more about Wake-on-WiFi, we'd be trying to
support the same (out-of-band WAKE#) with other WiFi drivers.

Brian
