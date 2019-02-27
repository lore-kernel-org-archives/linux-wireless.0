Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E50C00319
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 23:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41984218C3
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 23:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551308656;
	bh=ojNCGMRHA8XGXhogYXVoxskGS78JU3T265sYGV/6muE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Of2Ejzqerlc5/Y3894pVJOpKUhKlzTP33IBFSAkVX/YcLnDp8nnF8BaHdSRBhLpLP
	 ls2YNjkzUXglqPkkcyiOSkCNxuAfi5JLtZXt1i3CpF9xFffyXn+zEmch+sf4A1rwkq
	 MfjJfeas9EnunIZrpms5xGllLOMh+mvY1f3Ql6jw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfB0XEL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 18:04:11 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33393 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730139AbfB0XEK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 18:04:10 -0500
Received: by mail-oi1-f195.google.com with SMTP id z14so14988072oid.0;
        Wed, 27 Feb 2019 15:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xp3MERVpFmLr5DjrSIUraGCZG0QRk7Pfas0mtbAFRM=;
        b=OIANhG7iMssiOUKlnx35Tm9YI5fGMz/vfMtyzDTO8SRBYXs2EA7byjWs00dLT1z+m3
         oJrwAG0ORYPDasdh8INvXbRQ4C6Hrw/2zaj8bU4HEDE/EHh9E9v1aLgBis88C0hpRXhG
         IYs/AOZSAvzwCuEwiBPAyr1s7ydmFS/CwMD7q2/hUhUOKU/2PTIHMBZtJLA7W23Te1sn
         bZpwQEWK7noxW99cE5UuM6HAKSB8WD69oIyIgLK6gve0tJdKcRcMoDUT2pJwTJ4kmVRn
         cYKB2r18xAHyGMU6Ju/u0EJpX1FKvtwvxmo4Dn6URpVnXe/sQFTfeBQO54yiIa/0+Ly5
         GTTA==
X-Gm-Message-State: AHQUAuYCWY632Eq3TgAKnd95XWRy1R4GtoVTb0dRwFVjbyUPwVYAi+hk
        Svah2dfzK6JuCY65+ERWxNfFSUlP0YzyY7hHYko=
X-Google-Smtp-Source: AHgI3IbwmM7ugRwp/8WyXr6jFGbU0ALIKO3UtcMW0l6YmC9GAh8qWOOoRK/mLYUZpOCoffSk5zw46jUYZ6JEZOIwieE=
X-Received: by 2002:aca:ed0f:: with SMTP id l15mr1149840oih.76.1551308649198;
 Wed, 27 Feb 2019 15:04:09 -0800 (PST)
MIME-Version: 1.0
References: <20190224140426.3267-1-marc.zyngier@arm.com> <20190226232822.GA174696@google.com>
 <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com> <CAKv+Gu_fZK7dUqrrVPCejAZNWyUeMUX2ojQ=vQ3hiMkGF6e6tw@mail.gmail.com>
 <20190227205754.GF174696@google.com>
In-Reply-To: <20190227205754.GF174696@google.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 28 Feb 2019 00:03:56 +0100
Message-ID: <CAJZ5v0gZFDdtbKQ6y52x+X8yoiPhP6BhGYZO=R_varx2nwuv5g@mail.gmail.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Devicetree List <devicetree@vger.kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 27, 2019 at 9:58 PM Brian Norris <briannorris@chromium.org> wrote:
>
> Hi Ard,
>
> On Wed, Feb 27, 2019 at 11:16:12AM +0100, Ard Biesheuvel wrote:
> > On Wed, 27 Feb 2019 at 11:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > > On 26/02/2019 23:28, Brian Norris wrote:
> > > > You're not the first person to notice this. All the motivations are not
> > > > necessarily painted clearly in their cover letter, but here are some
> > > > previous attempts at solving this problem:
> > > >
> > > > [RFC PATCH v11 0/5] PCI: rockchip: Move PCIe WAKE# handling into pci core
> > > > https://lkml.kernel.org/lkml/20171225114742.18920-1-jeffy.chen@rock-chips.com/
> > > > http://lkml.kernel.org/lkml/20171226023646.17722-1-jeffy.chen@rock-chips.com/
> > > >
> > > > As you can see by the 12th iteration, it wasn't left unsolved for lack
> > > > of trying...
> > >
> > > I wasn't aware of this. That's definitely a better approach than my
> > > hack, and I would really like this to be revived.
> > >
> >
> > I don't think this approach is entirely sound either.
>
> (I'm sure there may be problems with the above series. We probably
> should give it another shot though someday, as I think it's closer to
> the mark.)
>
> > From the side of the PCI device, WAKE# is just a GPIO line, and how it
> > is wired into the system is an entirely separate matter. So I don't
> > think it is justified to overload the notion of legacy interrupts with
> > some other pin that may behave in a way that is vaguely similar to how
> > a true wake-up capable interrupt works.
>
> I think you've conflated INTx with WAKE# just a bit (and to be fair,
> that's exactly what the bad binding we're trying to replace did,
> accidentally). We're not trying to claim this WAKE# signal replaces the
> typical PCI interrupts, but it *is* an interrupt in some sense --
> "depending on your definition of interrupt", per our IRC conversation ;)
>
> > So I'd argue that we should add an optional 'wake-gpio' DT property
> > instead to the generic PCI device binding, and leave the interrupt
> > binding and discovery alone.
>
> So I think Mark Rutland already shot that one down; it's conceptually an
> interrupt from the device's perspective.

Which device are you talking about?  The one that signals wakeup?  If
so, then I beg to differ.

On ACPI platforms WAKE# is represented as an ACPI GPE that is signaled
through SCI and handled at a different level (on HW-reduced ACPI it
actually can be a GPIO interrupt, but it still is handled with the
help of AML).  The driver of the device signaling wakeup need not even
be aware that WAKE# has been asserted.

> We just need to figure out a good way of representing it that doesn't stomp on the existing INTx
> definitions.

WAKE# is a signal that is converted into an interrupt, but that
interrupt may arrive at some place your driver has nothing to do with.
It generally doesn't make sense to represent it as an interrupt for
the target device.
