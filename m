Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FCBC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB5D9205F4
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfB0KCX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 05:02:23 -0500
Received: from foss.arm.com ([217.140.101.70]:59826 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbfB0KCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 05:02:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1C421596;
        Wed, 27 Feb 2019 02:02:22 -0800 (PST)
Received: from [10.1.196.62] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4133F575;
        Wed, 27 Feb 2019 02:02:18 -0800 (PST)
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Brian Norris <briannorris@chromium.org>
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
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <20190226232822.GA174696@google.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <d67512fe-42b4-513f-d27a-fed85c19e9c2@arm.com>
Date:   Wed, 27 Feb 2019 10:02:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190226232822.GA174696@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Lorenzo

Hi Brian,

On 26/02/2019 23:28, Brian Norris wrote:
> + others
> 
> Hi Marc,
> 
> Thanks for the series. I have a few bits of history to add to this, and
> some comments.
> 
> On Sun, Feb 24, 2019 at 02:04:22PM +0000, Marc Zyngier wrote:
>> For quite some time, I wondered why the PCI mwifiex device built in my
>> Chromebook was unable to use the good old legacy interrupts. But as MSIs
>> were working fine, I never really bothered investigating. I finally had a
>> look, and the result isn't very pretty.
>>
>> On this machine (rk3399-based kevin), the wake-up interrupt is described as
>> such:
>>
>> &pci_rootport {
>> 	mvl_wifi: wifi@0,0 {
>> 		compatible = "pci1b4b,2b42";
>> 		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
>> 		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
>> 		interrupt-parent = <&gpio0>;
>> 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
>> 		pinctrl-names = "default";
>> 		pinctrl-0 = <&wlan_host_wake_l>;
>> 		wakeup-source;
>> 	};
>> };
>>
>> Note how the interrupt is part of the properties directly attached to the
>> PCI node. And yet, this interrupt has nothing to do with a PCI legacy
>> interrupt, as it is attached to the wake-up widget that bypasses the PCIe RC
>> altogether (Yay for the broken design!). This is in total violation of the
>> IEEE Std 1275-1994 spec[1], which clearly documents that such interrupt
>> specifiers describe the PCI device interrupts, and must obey the
>> INT-{A,B,C,D} mapping. Oops!
> 
> You're not the first person to notice this. All the motivations are not
> necessarily painted clearly in their cover letter, but here are some
> previous attempts at solving this problem:
> 
> [RFC PATCH v11 0/5] PCI: rockchip: Move PCIe WAKE# handling into pci core
> https://lkml.kernel.org/lkml/20171225114742.18920-1-jeffy.chen@rock-chips.com/
> http://lkml.kernel.org/lkml/20171226023646.17722-1-jeffy.chen@rock-chips.com/
> 
> As you can see by the 12th iteration, it wasn't left unsolved for lack
> of trying...

I wasn't aware of this. That's definitely a better approach than my
hack, and I would really like this to be revived.

> 
> Frankly, if a proper DT replacement to the admittedly bad binding isn't
> agreed upon quickly, I'd be very happy to just have WAKE# support
> removed from the DTS for now, and the existing mwifiex binding should
> just be removed. (Wake-on-WiFi was never properly vetted on these
> platforms anyway.) It mostly serves to just cause problems like you've
> noticed.

Agreed. If there is no actual use for this, and that we can build a case
for a better solution, let's remove the wakeup support from the Gru DT
(it is invalid anyway), and bring it back if and when we get the right
level of support.

[...]

> One problem Rockchip authors were also trying to resolve here is that
> PCIe WAKE# handling should not really be something the PCI device driver
> has to handle directly. Despite your complaints about not using in-band
> TLP wakeup, a separate WAKE# pin is in fact a documented part of the
> PCIe standard, and it so happens that the Rockchip RC does not support
> handling TLPs in S3, if you want to have decent power consumption. (Your
> "bad hardware" complaints could justifiably fall here, I suppose.)
> 
> Additionally, I've had pushback from PCI driver authors/maintainers on
> adding more special handling for this sort of interrupt property (not
> the binding specifically, but just the concept of handling WAKE# in the
> driver), as they claim this should be handled by the system firmware,
> when they set the appropriate wakeup flags, which filter down to
> __pci_enable_wake() -> platform_pci_set_wakeup(). That's how x86 systems
> do it (note: I know for a fact that many have a very similar
> architecture -- WAKE# is not routed to the RC, because, why does it need
> to? and they *don't* use TLP wakeup either -- they just hide it in
> firmware better), and it Just Works.

Even on an arm64 platform, there is no reason why a wakeup interrupt
couldn't be handled by FW rather than the OS. It just need to be wired
to the right spot (so that it generates a secure interrupt that can be
handled by FW).

> So, we basically concluded that we should standardize on a way to
> describe WAKE# interrupts such that PCI drivers don't have to deal with
> it at all, and the PCI core can do it for us. 12 revisions later
> and...we still never agreed on a good device tree binding for this.

Is the DT binding the only problem? Do we have an agreement for the core
code?

> IOW, maybe your wake-up sub-node is the best way to side-step the
> problems of conflicting with the OF PCI spec. But I'd still really like
> to avoid parsing it in mwifiex, if at all possible.

Honestly, my solution is just a terrible hack. I wasn't aware that this
was a more general problem, and I'd love it to be addressed in the core
PCI code.

> (We'd still be left with the marvell,wakeup-pin propery to parse
> specifically in mwifiex, which sadly has to exist because....well,
> Samsung decided to do chip-on-board, and then they failed to use the
> correct pin on Marvell's side when wiring up WAKE#. Sigh.)

Oh well...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
