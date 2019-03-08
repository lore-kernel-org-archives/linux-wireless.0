Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D047C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 158C320855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfCHJCQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 04:02:16 -0500
Received: from foss.arm.com ([217.140.101.70]:55568 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfCHJCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 04:02:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6649AA78;
        Fri,  8 Mar 2019 01:02:15 -0800 (PST)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D12CD3F71D;
        Fri,  8 Mar 2019 01:02:12 -0800 (PST)
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <87ef7hai0e.fsf@codeaurora.org>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <15c00f9e-58df-e885-f3b0-2c57e9fadb11@arm.com>
Date:   Fri, 8 Mar 2019 09:02:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <87ef7hai0e.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 08/03/2019 08:26, Kalle Valo wrote:
> Marc Zyngier <marc.zyngier@arm.com> writes:
> 
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
>>
>> The net effect of the above is that Linux tries to do something vaguely
>> sensible, and uses the same interrupt for both the wake-up widget and the
>> PCI device. This doesn't work for two reasons: (1) the wake-up widget grabs
>> the interrupt in exclusive mode, and (2) the PCI interrupt is still routed
>> to the RC, leading to a screaming interrupt. This simply cannot work.
>>
>> To sort out this mess, we need to lift the confusion between the two
>> interrupts. This is done by extending the DT binding to allow the wake-up
>> interrupt to be described in a 'wake-up' subnode, sidestepping the issue
>> completely. On my Chromebook, it now looks like this:
>>
>> &pci_rootport {
>> 	mvl_wifi: wifi@0,0 {
>> 		compatible = "pci1b4b,2b42";
>> 		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
>> 		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
>> 		pinctrl-names = "default";
>> 		pinctrl-0 = <&wlan_host_wake_l>;
>> 		wake-up {
>> 			interrupt-parent = <&gpio0>;
>> 			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
>> 			wakeup-source;
>> 		};
>> 	};
>> };
>>
>> The driver is then updated to look for this subnode first, and fallback to
>> the original, broken behaviour (spitting out a warning in the offending
>> configuration).
>>
>> For good measure, there are two additional patches:
>>
>> - The wake-up interrupt requesting is horribly racy, and could lead to
>>   unpredictable behaviours. Let's fix that properly.
>>
>> - A final patch implementing the above transformation for the whole
>>   RK3399-based Chromebook range, which all use the same broken
>>   configuration.
>>
>> With all that, I finally have PCI legacy interrupts working with the mwifiex
>> driver on my Chromebook.
>>
>> [1] http://www.devicetree.org/open-firmware/bindings/pci/pci2_1.pdf
>>
>> Marc Zyngier (4):
>>   dt-bindings/marvell-8xxx: Allow wake-up interrupt to be placed in a
>>     separate node
>>   mwifiex: Fetch wake-up interrupt from 'wake-up' subnode when it exists
>>   mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling
>>     it too late
>>   arm64: dts: rockchip: gru: Move wifi wake-up interrupt into its own
>>     subnode
>>
>>  .../bindings/net/wireless/marvell-8xxx.txt    | 23 ++++++++++++++++++-
>>  .../dts/rockchip/rk3399-gru-chromebook.dtsi   |  8 ++++---
>>  drivers/net/wireless/marvell/mwifiex/main.c   | 13 +++++++++--
>>  3 files changed, 38 insertions(+), 6 deletions(-)
> 
> I didn't read the discussion in detail, but I understanding is that I
> should drop this series and wait for a new version. Please correct me if
> I misunderstood.

I indeed plan to resend the series with a slightly different approach,
removing support for the wake-up interrupt on mwifiex PCI devices
altogether.

Note that patch #3 is a fairly independent fix, which could be applied
right now.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
