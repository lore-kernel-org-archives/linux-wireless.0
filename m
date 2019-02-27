Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D212C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 09:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D45362133F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 09:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfB0J1g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 04:27:36 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:59260 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfB0J1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 04:27:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F6A71596;
        Wed, 27 Feb 2019 01:27:34 -0800 (PST)
Received: from [10.1.196.62] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A5753F575;
        Wed, 27 Feb 2019 01:27:30 -0800 (PST)
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Brian Norris <briannorris@chromium.org>
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
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <CAKv+Gu9OOzOxx0rTAZqM8r4q_hRmOp3b=KP7fwgNeiu67FCApA@mail.gmail.com>
 <5310b73b-4821-6dff-b9c0-34c59fb7fd72@arm.com>
 <CAKv+Gu_=bQyVZqgUnJm9moCcaCcpDrag6NWGEpaR65=pMiTFJQ@mail.gmail.com>
 <0c433a70-27f6-76ad-c46c-6015de1ffaa4@arm.com>
 <20190226234422.GD174696@google.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <abbee52f-39ce-6e8f-af3c-f6f8d1a39020@arm.com>
Date:   Wed, 27 Feb 2019 09:27:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190226234422.GD174696@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 26/02/2019 23:44, Brian Norris wrote:
> Hi,
> 
> On Tue, Feb 26, 2019 at 05:14:00PM +0000, Marc Zyngier wrote:
>> On 26/02/2019 16:21, Ard Biesheuvel wrote:
>>> On Mon, 25 Feb 2019 at 15:53, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> It outlines one thing: If you have to interpret per-device PCI
>>>> properties from DT, you're in for serious trouble. I should get some
>>>> better HW.
>>>>
>>>
>>> Yeah, it obviously makes no sense at all for the interrupt parent of a
>>> PCI device to deviate from the host bridge's interrupt parent, and
>>> it's quite unfortunate that we can't simply ban it now that the cat is
>>> out of the bag already.
>>>
>>> Arguably, the wake up widget is not part of the PCI device, but I have
>>> no opinion as to whether it is better modeling it as a sub device as
>>> you are proposing or as an entirely separate device referenced via a
>>> phandle.
>>
>> It is not that clear. The widget seems to be an integral part of the
>> device, as it is the same basic IP that is used for SDIO and USB.
> 
> It's not really a widget specific to this IP. It's just a GPIO. It so
> happens that both SDIO and PCIe designs have wanted to use a GPIO for
> wakeup, as many other devices do. (Note: it's not just cheap ARM
> devices; pulling up some Intel Chromebook designs, I see the exact same
> WAKE# GPIO on their PCIe WiFi as well.)

Arghh! If I can't even point people to an Intel design as an example of
something done halfway right, we're screwed! ;-)

> 
>> It looks like the good old pre-PCI-2.2 days, where you had to have a
>> separate cable between your network card and the base-board for the
>> wake-up interrupt to be delivered. Starting with PCI-2.2, the bus can
>> carry the signal just fine. With PCIe, it should just be an interrupt
>> TLP sent to the RC, but that's obviously not within the capabilities of
>> the HW.
> 
> You should search the PCI Express specification for WAKE#. There is a
> clearly-documented "side-band wake" feature that is part of the
> standard, as an alternative to in-band TLP wakeup. While you claim this
> is an ancient thing, it in fact still in use on many systems -- it's
> just usually abstracted better by ACPI firmware, whereas the dirty
> laundry is aired a bit more on a Device Tree system. And we got it
> wrong.

I stand corrected. I was really hoping for these side-band wires to be a
thing of the past, but clearly the world hasn't moved as quickly as I hoped.

>> Anyway, it'd be good if the Marvell people could chime in and let us
>> know how they'd prefer to handle this.
> 
> I'm not sure this is really a Marvell-specific problem. (Well, except
> for the marvell,wakeup-pin silliness, which is somewhat orthogonal.) In
> fact, if we cared a little more about Wake-on-WiFi, we'd be trying to
> support the same (out-of-band WAKE#) with other WiFi drivers.

I'd definitely like to see this standardized. It would give us more
coverage, and prevent everyone from doing their own thing. But as you
mention, WoW doesn't seem to get much traction.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
