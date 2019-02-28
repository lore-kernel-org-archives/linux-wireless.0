Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88C0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 02:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E4220863
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 02:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QpIWPMKv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfB1ChU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 21:37:20 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36336 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730577AbfB1ChU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 21:37:20 -0500
Received: by mail-lj1-f194.google.com with SMTP id v10so15758770lji.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2019 18:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyqFOT7Inb7ltcsQAxtq2y609tKCB1dTKtt4XzU9cmo=;
        b=QpIWPMKvdXGzSz9fQZzVo3Fg8yZ75XyjkJzUB7aRlL4Bgly15JHZRf03PoDNEQeleX
         vTwDW7mtYYjRVJWogD8umPTbo9TShmKQZUpl5LZO2xpNgLQhw627MFSW7FxVr4z+2gve
         Gu9PicSY725DMThFkRGABZ+8V8NDzHsuKg7lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyqFOT7Inb7ltcsQAxtq2y609tKCB1dTKtt4XzU9cmo=;
        b=qMwHH7j/sZQ6MLpIytF38AEYHyCSwNNM4Flleblm6Lcvngh185zvJay+rCmC4ifKRz
         hqv+cDOO2OuyIZLtYx0L2VnbU5QWt+WeLlJCWpcEZxxlnok1RIArdfxyMWLme8YEbN7g
         0+9ViO8De/z5bm9WqBJk//tqVJflDz6+KrRESVJLUzbOMLH2rkzzoZlgnHhZVCVuFVqm
         be0pDB21nCmczWTEWnW+9E4wfI6CLZIZJYCPaDpv1SikVE+mz3lBWn65yFmrA4NMtHlF
         Y+B4ekoTaS3DsAlLEnWaVZ7PK4bGvnCJT58uN/VhiiUSA8vgF7e0Qvkiz3sw3O4Jl7OZ
         MTFA==
X-Gm-Message-State: APjAAAW5AcvXngSGv1bGonM88EcluIc99UD6fFNtBjrQOq0scdomZCxd
        HjUetl4yYUbIwuDpqctyH43p8MgGQCU=
X-Google-Smtp-Source: APXvYqxj/HWTu6OI37qSEhvT/LKEQ7bWZBHzaXP1K4BL+51t+wQo/h4q/POTyERJjp2/PmW9aT/4lA==
X-Received: by 2002:a2e:5bd8:: with SMTP id m85mr691126lje.1.1551321437569;
        Wed, 27 Feb 2019 18:37:17 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id h101sm396219ljh.80.2019.02.27.18.37.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 18:37:17 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id m73so8484609lfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2019 18:37:17 -0800 (PST)
X-Received: by 2002:a19:c98b:: with SMTP id z133mr2657642lff.88.1551320973346;
 Wed, 27 Feb 2019 18:29:33 -0800 (PST)
MIME-Version: 1.0
References: <20190224140426.3267-1-marc.zyngier@arm.com> <20190226232822.GA174696@google.com>
 <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com> <CAKv+Gu_fZK7dUqrrVPCejAZNWyUeMUX2ojQ=vQ3hiMkGF6e6tw@mail.gmail.com>
 <20190227205754.GF174696@google.com> <CAJZ5v0gZFDdtbKQ6y52x+X8yoiPhP6BhGYZO=R_varx2nwuv5g@mail.gmail.com>
In-Reply-To: <CAJZ5v0gZFDdtbKQ6y52x+X8yoiPhP6BhGYZO=R_varx2nwuv5g@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Feb 2019 18:29:21 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNT9Taqfoz7R1Z926Vi1fMNNLYg5vqcZTw2m6JvXk+75w@mail.gmail.com>
Message-ID: <CA+ASDXNT9Taqfoz7R1Z926Vi1fMNNLYg5vqcZTw2m6JvXk+75w@mail.gmail.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     "Rafael J. Wysocki" <rafael@kernel.org>
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
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
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

Hi Rafael,

On Wed, Feb 27, 2019 at 3:04 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Wed, Feb 27, 2019 at 9:58 PM Brian Norris <briannorris@chromium.org> wrote:
> > On Wed, Feb 27, 2019 at 11:16:12AM +0100, Ard Biesheuvel wrote:
> > > So I'd argue that we should add an optional 'wake-gpio' DT property
> > > instead to the generic PCI device binding, and leave the interrupt
> > > binding and discovery alone.
> >
> > So I think Mark Rutland already shot that one down; it's conceptually an
> > interrupt from the device's perspective.

Perhaps I shouldn't speak for Mark, but I am basically quoting him off IRC.

> Which device are you talking about?  The one that signals wakeup?  If
> so, then I beg to differ.

Yes, the endpoint device.

> On ACPI platforms WAKE# is represented as an ACPI GPE that is signaled
> through SCI and handled at a different level (on HW-reduced ACPI it
> actually can be a GPIO interrupt, but it still is handled with the
> help of AML).  The driver of the device signaling wakeup need not even
> be aware that WAKE# has been asserted.

Frankly, ACPI is not relevant to how we represent WAKE# in DT, IMO.
Also, we're talking about the *device*, not the driver. When talking
about Device Tree, that distinction is relevant.

So while the driver need not be aware (and I agree! it only needs to
care about enabling/disabling wake), *something* should be aware, and
the signal that "something" should be receiving is simply "did WAKE
happen"? That sounds basically like the device is signalling an
interrupt to me.

Maybe this goes back to some confusion we had elsewhere: what is the
meaning of "interrupt" in device tree?

> > We just need to figure out a good way of representing it that doesn't stomp on the existing INTx
> > definitions.
>
> WAKE# is a signal that is converted into an interrupt, but that
> interrupt may arrive at some place your driver has nothing to do with.

I could agree with that, perhaps. But that's also what Device Tree is
all about, really. We describe the relation between devices. So some
other <foo> handles events that are triggered by <bar>, so we use a
phandle to relate <bar> to <foo>.

> It generally doesn't make sense to represent it as an interrupt for
> the target device.

What would you suggest then? I'm not clearly understanding how you
think we should (a) describe (in DT) and (b) implement this WAKE#
handling.

Brian
