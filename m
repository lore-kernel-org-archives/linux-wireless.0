Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A84C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 08:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2BBB20811
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 08:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gkEQUODs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EljLzFWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfCHI1G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 03:27:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfCHI1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 03:27:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82F046030B; Fri,  8 Mar 2019 08:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552033624;
        bh=GYvEHVZ8Hz0AsS4XKsMZAKT8P2zqxlUCAlYQX+OQjNY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gkEQUODs57Jkna0MdlR5pHeUPzPjk49lTZRkQoWun0TYyRjxJH44tESAhHfLINkkr
         sYsInxGVWGqWt1UV0tjZBKHsvI4Ii1vTxQBjd8ldC3Yn21p7G/Mnq5vyadg758eb1p
         yQP8ruLKIzJ2r7LoOyWjPtj/T/OH9hDNmLq5Lc54=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCA3D6030B;
        Fri,  8 Mar 2019 08:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552033623;
        bh=GYvEHVZ8Hz0AsS4XKsMZAKT8P2zqxlUCAlYQX+OQjNY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EljLzFWpD8L94mi69QIE/YaL42fk0wnVnK82jrhHawCNWea7at/A0paZmsxzBjYod
         7+9q63qDvquepsaDdbn1zXbDN+wNeeKwswvlfYQbM636MRxYAn0MMHATfLzhMlsDXz
         AmvQuiz7i17GEWIkIbgOYWodlHpb4AK+9dx+iuI8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCA3D6030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
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
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
References: <20190224140426.3267-1-marc.zyngier@arm.com>
Date:   Fri, 08 Mar 2019 10:26:57 +0200
In-Reply-To: <20190224140426.3267-1-marc.zyngier@arm.com> (Marc Zyngier's
        message of "Sun, 24 Feb 2019 14:04:22 +0000")
Message-ID: <87ef7hai0e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Marc Zyngier <marc.zyngier@arm.com> writes:

> For quite some time, I wondered why the PCI mwifiex device built in my
> Chromebook was unable to use the good old legacy interrupts. But as MSIs
> were working fine, I never really bothered investigating. I finally had a
> look, and the result isn't very pretty.
>
> On this machine (rk3399-based kevin), the wake-up interrupt is described as
> such:
>
> &pci_rootport {
> 	mvl_wifi: wifi@0,0 {
> 		compatible = "pci1b4b,2b42";
> 		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
> 		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
> 		interrupt-parent = <&gpio0>;
> 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&wlan_host_wake_l>;
> 		wakeup-source;
> 	};
> };
>
> Note how the interrupt is part of the properties directly attached to the
> PCI node. And yet, this interrupt has nothing to do with a PCI legacy
> interrupt, as it is attached to the wake-up widget that bypasses the PCIe RC
> altogether (Yay for the broken design!). This is in total violation of the
> IEEE Std 1275-1994 spec[1], which clearly documents that such interrupt
> specifiers describe the PCI device interrupts, and must obey the
> INT-{A,B,C,D} mapping. Oops!
>
> The net effect of the above is that Linux tries to do something vaguely
> sensible, and uses the same interrupt for both the wake-up widget and the
> PCI device. This doesn't work for two reasons: (1) the wake-up widget grabs
> the interrupt in exclusive mode, and (2) the PCI interrupt is still routed
> to the RC, leading to a screaming interrupt. This simply cannot work.
>
> To sort out this mess, we need to lift the confusion between the two
> interrupts. This is done by extending the DT binding to allow the wake-up
> interrupt to be described in a 'wake-up' subnode, sidestepping the issue
> completely. On my Chromebook, it now looks like this:
>
> &pci_rootport {
> 	mvl_wifi: wifi@0,0 {
> 		compatible = "pci1b4b,2b42";
> 		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
> 		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&wlan_host_wake_l>;
> 		wake-up {
> 			interrupt-parent = <&gpio0>;
> 			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
> 			wakeup-source;
> 		};
> 	};
> };
>
> The driver is then updated to look for this subnode first, and fallback to
> the original, broken behaviour (spitting out a warning in the offending
> configuration).
>
> For good measure, there are two additional patches:
>
> - The wake-up interrupt requesting is horribly racy, and could lead to
>   unpredictable behaviours. Let's fix that properly.
>
> - A final patch implementing the above transformation for the whole
>   RK3399-based Chromebook range, which all use the same broken
>   configuration.
>
> With all that, I finally have PCI legacy interrupts working with the mwifiex
> driver on my Chromebook.
>
> [1] http://www.devicetree.org/open-firmware/bindings/pci/pci2_1.pdf
>
> Marc Zyngier (4):
>   dt-bindings/marvell-8xxx: Allow wake-up interrupt to be placed in a
>     separate node
>   mwifiex: Fetch wake-up interrupt from 'wake-up' subnode when it exists
>   mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling
>     it too late
>   arm64: dts: rockchip: gru: Move wifi wake-up interrupt into its own
>     subnode
>
>  .../bindings/net/wireless/marvell-8xxx.txt    | 23 ++++++++++++++++++-
>  .../dts/rockchip/rk3399-gru-chromebook.dtsi   |  8 ++++---
>  drivers/net/wireless/marvell/mwifiex/main.c   | 13 +++++++++--
>  3 files changed, 38 insertions(+), 6 deletions(-)

I didn't read the discussion in detail, but I understanding is that I
should drop this series and wait for a new version. Please correct me if
I misunderstood.

-- 
Kalle Valo
