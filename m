Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7F1C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C30213A2
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IS2KUIgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbfB0U57 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:57:59 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43123 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbfB0U57 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 15:57:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id m10so8569889plt.10
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2019 12:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c8VWH6zBnriKrNXSEqZVVW0Kns2rlHqKeHT5OroTUIQ=;
        b=IS2KUIgJgNd0ucZl768yoRseJvxnyHKS/3NycTcRYZSEjwRArteaDb7lvOR0zwBhRi
         L2SS43CEyx7h8uKvGY7A1lRRYU4pBbWznUqXM+5XqUH5WoJyArubm/N9omPO7BVaXcsM
         5IczBEs4mrCr+ygxwTwUdkywizoVCgkRMI04s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c8VWH6zBnriKrNXSEqZVVW0Kns2rlHqKeHT5OroTUIQ=;
        b=pqWExolNPF56BPgxhREAMGOjfxvNP9y5ge3oqGQZ6Z8ZgUj7mtDaV6anWWOwH/Httl
         3bYI6Aq3M6Envr9FnmFw49km7rklWRK2SDsNlvsIY57qbUySM82fUvJg/Niu0/65ekca
         8BLVwmn22vAPTpeK04JuZC1d+zMfjPjaY2XdMrGgUE0adakZou0HcdJakJBHca0rf7BK
         diq+dCd7I9aKaghyA1rt+ItloAdgmYg81ixS12nznNhRC/EUmV2QorXef1qLmlGmiJPr
         HYdJOX1kbn6DyZlmH9s6dnAqIQRPHlo6ZshJwV9HSSKK/5FSsgViwShRc7V8ekilwgaN
         OUqA==
X-Gm-Message-State: AHQUAuYs6tZeCmhcOYv7K4PDg5NfebGH7TdDmo8qi9Fti9QDVulaz6/1
        /lwpZ2v/hLNZb3VW1YDzva2DeQ==
X-Google-Smtp-Source: AHgI3Ib7syP6DcLdP9NHp9gQdrO6NgYoCGNPaMVqk/1Djv5xl6BX3qIYqHBiYM9BCmgFgaVwqAgWdQ==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr4161242plk.313.1551301078637;
        Wed, 27 Feb 2019 12:57:58 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id u11sm17044796pfh.23.2019.02.27.12.57.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Feb 2019 12:57:57 -0800 (PST)
Date:   Wed, 27 Feb 2019 12:57:55 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
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
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
Message-ID: <20190227205754.GF174696@google.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <20190226232822.GA174696@google.com>
 <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
 <CAKv+Gu_fZK7dUqrrVPCejAZNWyUeMUX2ojQ=vQ3hiMkGF6e6tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_fZK7dUqrrVPCejAZNWyUeMUX2ojQ=vQ3hiMkGF6e6tw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ard,

On Wed, Feb 27, 2019 at 11:16:12AM +0100, Ard Biesheuvel wrote:
> On Wed, 27 Feb 2019 at 11:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 26/02/2019 23:28, Brian Norris wrote:
> > > You're not the first person to notice this. All the motivations are not
> > > necessarily painted clearly in their cover letter, but here are some
> > > previous attempts at solving this problem:
> > >
> > > [RFC PATCH v11 0/5] PCI: rockchip: Move PCIe WAKE# handling into pci core
> > > https://lkml.kernel.org/lkml/20171225114742.18920-1-jeffy.chen@rock-chips.com/
> > > http://lkml.kernel.org/lkml/20171226023646.17722-1-jeffy.chen@rock-chips.com/
> > >
> > > As you can see by the 12th iteration, it wasn't left unsolved for lack
> > > of trying...
> >
> > I wasn't aware of this. That's definitely a better approach than my
> > hack, and I would really like this to be revived.
> >
> 
> I don't think this approach is entirely sound either.

(I'm sure there may be problems with the above series. We probably
should give it another shot though someday, as I think it's closer to
the mark.)

> From the side of the PCI device, WAKE# is just a GPIO line, and how it
> is wired into the system is an entirely separate matter. So I don't
> think it is justified to overload the notion of legacy interrupts with
> some other pin that may behave in a way that is vaguely similar to how
> a true wake-up capable interrupt works.

I think you've conflated INTx with WAKE# just a bit (and to be fair,
that's exactly what the bad binding we're trying to replace did,
accidentally). We're not trying to claim this WAKE# signal replaces the
typical PCI interrupts, but it *is* an interrupt in some sense --
"depending on your definition of interrupt", per our IRC conversation ;)

> So I'd argue that we should add an optional 'wake-gpio' DT property
> instead to the generic PCI device binding, and leave the interrupt
> binding and discovery alone.

So I think Mark Rutland already shot that one down; it's conceptually an
interrupt from the device's perspective. We just need to figure out a
good way of representing it that doesn't stomp on the existing INTx
definitions.

Brian
