Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89246C00319
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594AE20851
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kViykZsx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfB0KQZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 05:16:25 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47087 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfB0KQZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 05:16:25 -0500
Received: by mail-io1-f67.google.com with SMTP id k21so13022680ior.13
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2019 02:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSEnQlO4ryJ5lj1eUjpEnJNgdDcKb7s4xmHWDAD6wFA=;
        b=kViykZsxAUrFfq+Zejo7w/E/rf9vjyhY37z3ZMXmnrLLe+2bIJAcGuMwJ1ykxz9SbX
         7Onuzn+mjyJ+CORMNaLMs6rvT1d+wofFxEzhfLwUZN0gYADKSuslU4XizGqvW6cFg8df
         9FnZayk+IY23PEAwkPp/yLJHp+V4tlzGmJpS9mk3fGnYY8hXccOJFheQU/A0nK9MOW4p
         2NNZxGmcRRGobB4eLftBGlBjbuvCgPNjEdAXyZQwBpJtwHYgXJ743qH03WcsLknv7RxM
         X2tGkThjD3HG8CmkwnWxElob6zXzjxj1ZPPPiAQSu+zUYB4cPNQCa2Cl1ywz3/pPDzWF
         1/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSEnQlO4ryJ5lj1eUjpEnJNgdDcKb7s4xmHWDAD6wFA=;
        b=LIDn39fL4R3+e1aqzVaJ8851pAn3zs3L2blMkXHNaQevREDUI0pF3+WB87/FmowWJi
         Wb1dr8tuU6mFnHSoCmyvltqFW8BQNHSBNeDZp2XtWMQ314ZLlW/bMG4Xc35ZDpCp6v+U
         fCk2qtJ8sd+vPLw/xBUGvVnFFqW0WFsn6z5OlqSGRdyXpyZxNSLKXD5MkLgoGkSMduvs
         G7W6GmU4xDYML13u1XBcfHyNB0Od41eInQKlyTDQX1EyydC1yxyRX17b4ItFo22fq5AO
         Gv04ch7gY/z3eCExvwRbwnAUfRx27QOjeHhqzM+sC9w/gpFG/Iqa0fmG/z382R40Mopd
         EtRg==
X-Gm-Message-State: APjAAAXOEkyI4Mbh6T3zDUAPjBMpB7F+mhPQPr0lRFCnTVrtM7BIpF2/
        eVw9aGBmDx3BlKegTDLMOoRVX+9JddX2fva+BfegZw==
X-Google-Smtp-Source: APXvYqxO9HQ9KWZQWEqmdGEwKaw5+KXyYiq9o9hgt1i/4kSVEQkCmMwNZAPJ/7nG39ptRqsCkOpqcQLOfsuy1y978mo=
X-Received: by 2002:a6b:7b02:: with SMTP id l2mr1605643iop.60.1551262583854;
 Wed, 27 Feb 2019 02:16:23 -0800 (PST)
MIME-Version: 1.0
References: <20190224140426.3267-1-marc.zyngier@arm.com> <20190226232822.GA174696@google.com>
 <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
In-Reply-To: <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 27 Feb 2019 11:16:12 +0100
Message-ID: <CAKv+Gu_fZK7dUqrrVPCejAZNWyUeMUX2ojQ=vQ3hiMkGF6e6tw@mail.gmail.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Brian Norris <briannorris@chromium.org>,
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
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 27 Feb 2019 at 11:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> + Lorenzo
>
> Hi Brian,
>
> On 26/02/2019 23:28, Brian Norris wrote:
> > + others
> >
> > Hi Marc,
> >
> > Thanks for the series. I have a few bits of history to add to this, and
> > some comments.
> >
> > On Sun, Feb 24, 2019 at 02:04:22PM +0000, Marc Zyngier wrote:
> >> For quite some time, I wondered why the PCI mwifiex device built in my
> >> Chromebook was unable to use the good old legacy interrupts. But as MSIs
> >> were working fine, I never really bothered investigating. I finally had a
> >> look, and the result isn't very pretty.
> >>
> >> On this machine (rk3399-based kevin), the wake-up interrupt is described as
> >> such:
> >>
> >> &pci_rootport {
> >>      mvl_wifi: wifi@0,0 {
> >>              compatible = "pci1b4b,2b42";
> >>              reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
> >>                     0x83010000 0x0 0x00100000 0x0 0x00100000>;
> >>              interrupt-parent = <&gpio0>;
> >>              interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
> >>              pinctrl-names = "default";
> >>              pinctrl-0 = <&wlan_host_wake_l>;
> >>              wakeup-source;
> >>      };
> >> };
> >>
> >> Note how the interrupt is part of the properties directly attached to the
> >> PCI node. And yet, this interrupt has nothing to do with a PCI legacy
> >> interrupt, as it is attached to the wake-up widget that bypasses the PCIe RC
> >> altogether (Yay for the broken design!). This is in total violation of the
> >> IEEE Std 1275-1994 spec[1], which clearly documents that such interrupt
> >> specifiers describe the PCI device interrupts, and must obey the
> >> INT-{A,B,C,D} mapping. Oops!
> >
> > You're not the first person to notice this. All the motivations are not
> > necessarily painted clearly in their cover letter, but here are some
> > previous attempts at solving this problem:
> >
> > [RFC PATCH v11 0/5] PCI: rockchip: Move PCIe WAKE# handling into pci core
> > https://lkml.kernel.org/lkml/20171225114742.18920-1-jeffy.chen@rock-chips.com/
> > http://lkml.kernel.org/lkml/20171226023646.17722-1-jeffy.chen@rock-chips.com/
> >
> > As you can see by the 12th iteration, it wasn't left unsolved for lack
> > of trying...
>
> I wasn't aware of this. That's definitely a better approach than my
> hack, and I would really like this to be revived.
>

I don't think this approach is entirely sound either.

From the side of the PCI device, WAKE# is just a GPIO line, and how it
is wired into the system is an entirely separate matter. So I don't
think it is justified to overload the notion of legacy interrupts with
some other pin that may behave in a way that is vaguely similar to how
a true wake-up capable interrupt works.

So I'd argue that we should add an optional 'wake-gpio' DT property
instead to the generic PCI device binding, and leave the interrupt
binding and discovery alone.
