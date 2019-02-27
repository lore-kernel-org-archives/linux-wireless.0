Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215EBC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D92D9217F5
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JEZ4+jTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfB0Uvv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:51:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35145 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfB0Uvv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 15:51:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id p19so8588865plo.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2019 12:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8wmkdekUxLYxZChNgATUWmR0Z5SXg06nnSmuJG/WF0M=;
        b=JEZ4+jTHAPfENHWlUrv4QuVqM72M4ECKJLdlkTa0XIqSxvQFW53AeCE5zeIeY477yb
         m3cO5UhypROXmeoI0krV4xe3Y8+x5tK0zTxmMgefRVHkD2n26d/dikZpSfqAlys6JRu/
         VslrwI92iVq7VS5ySB+hO+SE41lm0O6X0fIWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8wmkdekUxLYxZChNgATUWmR0Z5SXg06nnSmuJG/WF0M=;
        b=aWomNBOWNFInVSxXt0qTQPb/tllVXJK10fF4enhSIrVdyCh5T9b3nkxKs5tEC15x+U
         4P+j64z76+boLXHKE6zXjCiguz+Q1k/+JQvUWCf9TCddeA6THK1N4O4t2mvtPC4ECXkX
         e9VfS+UDw9HhD+2e/3fh6KTUJhmimEbnEuN2RScylJMm0w84lvK01x+Zg5gEKIlHfyvT
         Cmym0fIkdovY3ZHircEQLwBtq2QT6oGep5fbX65eZpPXFw1c2K4OBirxZkKLqc4JMIou
         MeZThwQUSw0pYLpGkw2hBo4PxUfjp1SPLgfQEf0j/NSA/2cYprT1A9mIkYL4KhPmvy0a
         gb2Q==
X-Gm-Message-State: AHQUAua5Id4Zt3GvtIOksI+qNVeqL6HP/kxK/WXjCHKAMvgWY2x+O+0Q
        WW67Q+cAAOwGmRjhyeOHkCq3vw==
X-Google-Smtp-Source: AHgI3IZZ/Ogx6tKI0poxhsJNOZHMzo5UPZ8ynB1LyMFy9Q4SeY9kqh8wFXMPRN4aHmnVLA1qwdWohQ==
X-Received: by 2002:a17:902:2de4:: with SMTP id p91mr4193177plb.215.1551300709989;
        Wed, 27 Feb 2019 12:51:49 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id z7sm36689613pfl.4.2019.02.27.12.51.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Feb 2019 12:51:49 -0800 (PST)
Date:   Wed, 27 Feb 2019 12:51:46 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, Jeffy Chen <jeffy.chen@rock-chips.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tony Lindgren <tony@atomide.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
Message-ID: <20190227205139.GE174696@google.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <20190226232822.GA174696@google.com>
 <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marc,

On Wed, Feb 27, 2019 at 10:02:16AM +0000, Marc Zyngier wrote:
> On 26/02/2019 23:28, Brian Norris wrote:
> > On Sun, Feb 24, 2019 at 02:04:22PM +0000, Marc Zyngier wrote:
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

Well, in some respects it may be better (mostly, handling in the PCI
core rather than each driver). But I'm still unsure about the DT
binding.

And while perhaps I could find time to revive it, it's probably more
expedient to kill the bad binding first.

> > Frankly, if a proper DT replacement to the admittedly bad binding isn't
> > agreed upon quickly, I'd be very happy to just have WAKE# support
> > removed from the DTS for now, and the existing mwifiex binding should
> > just be removed. (Wake-on-WiFi was never properly vetted on these
> > platforms anyway.) It mostly serves to just cause problems like you've
> > noticed.
> 
> Agreed. If there is no actual use for this, and that we can build a case
> for a better solution, let's remove the wakeup support from the Gru DT
> (it is invalid anyway), and bring it back if and when we get the right
> level of support.

+1

Today, something simple like NL80211_WOWLAN_TRIG_DISCONNECT and
NL80211_WOWLAN_TRIG_NET_DETECT may work OK, but I'm not confident that
anything more complicated is really a compelling story today (well,
outside of Android, which has a massively more complicated--and not
upstream--setup for this stuff).

> [...]
> 
> > One problem Rockchip authors were also trying to resolve here is that
> > PCIe WAKE# handling should not really be something the PCI device driver
> > has to handle directly. Despite your complaints about not using in-band
> > TLP wakeup, a separate WAKE# pin is in fact a documented part of the
> > PCIe standard, and it so happens that the Rockchip RC does not support
> > handling TLPs in S3, if you want to have decent power consumption. (Your
> > "bad hardware" complaints could justifiably fall here, I suppose.)
> > 
> > Additionally, I've had pushback from PCI driver authors/maintainers on
> > adding more special handling for this sort of interrupt property (not
> > the binding specifically, but just the concept of handling WAKE# in the
> > driver), as they claim this should be handled by the system firmware,
> > when they set the appropriate wakeup flags, which filter down to
> > __pci_enable_wake() -> platform_pci_set_wakeup(). That's how x86 systems
> > do it (note: I know for a fact that many have a very similar
> > architecture -- WAKE# is not routed to the RC, because, why does it need
> > to? and they *don't* use TLP wakeup either -- they just hide it in
> > firmware better), and it Just Works.
> 
> Even on an arm64 platform, there is no reason why a wakeup interrupt
> couldn't be handled by FW rather than the OS. It just need to be wired
> to the right spot (so that it generates a secure interrupt that can be
> handled by FW).

True...but then you also need a configuration (enable/disable) API for
it too. I don't think we have such a per-device API? So it would be a
pretty similar problem to solve anyway.

> > So, we basically concluded that we should standardize on a way to
> > describe WAKE# interrupts such that PCI drivers don't have to deal with
> > it at all, and the PCI core can do it for us. 12 revisions later
> > and...we still never agreed on a good device tree binding for this.
> 
> Is the DT binding the only problem? Do we have an agreement for the core
> code?

I'll have to re-read the old threads. I don't really remember where we
got bogged down... I think one outstanding question was whether WAKE#
should be associated with the port vs. the device. That might have been
might fault for confusing that one though.

> > IOW, maybe your wake-up sub-node is the best way to side-step the
> > problems of conflicting with the OF PCI spec. But I'd still really like
> > to avoid parsing it in mwifiex, if at all possible.
> 
> Honestly, my solution is just a terrible hack. I wasn't aware that this
> was a more general problem, and I'd love it to be addressed in the core
> PCI code.

Ack, so we agree.

Thanks,
Brian
