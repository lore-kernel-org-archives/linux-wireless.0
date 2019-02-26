Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1146BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD30F218D0
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NRxBWjZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfBZX22 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 18:28:28 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43185 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbfBZX22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 18:28:28 -0500
Received: by mail-pl1-f194.google.com with SMTP id m10so6976397plt.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 15:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IbZV9S4wZ1HxFTbys16uZNUt6pTk6EVk+H8ofv4j4dA=;
        b=NRxBWjZPTu290aGn6Nlh6ugxbVVcKOmfoBak65wBBFF8fb/4UV5IIq0YQoRk+9TQOf
         OERM7KbXT+5aaVKs0tGmb768tNZRz0HXgrrPNlmTcjk3ZDTw4b84Rn55gkWJMd2T5Jj9
         sYVh6mjXDbdHZGCOgUbMIc/ngaOo5mRz7kclg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IbZV9S4wZ1HxFTbys16uZNUt6pTk6EVk+H8ofv4j4dA=;
        b=ZSwddyGpo/QSdF2NVT1nbGeAeiNmBcV2UW84Egi2nachRg6xfKkvr5d9zsTZF2Y8qC
         e2gvpW0PwmrzsQdh1x9Fh4YBzwYrGjRJnvpys66ye+VsJ/dv+aiU8883688UAlTr8Tz5
         p80KntC0RlTVRD/ZBIVoXifllWcKbhUlgZvVhSKxkfPuSwW3oSxtuMwxQE1aUAIMRrIG
         9hwUH677YZ3N0OZKzoKhR1seJP0bYBUXkvuJUWjjZGr1lATZkN+5+vUxAHez2fuBSZ4W
         CDkx9cDDI0QcXFPew2U45Mq27PB8qHWeu8BAtlJ3szcp74j4Z1wrA7kfnKcyz4PgnmyN
         2GJg==
X-Gm-Message-State: AHQUAubZKosnybruDn8gPbpjlhPN51eA/lWmMz/zHBGiMZFWS4A1K+Zp
        SjB48E8R/qJ/4zF4y1iHua5n4Q==
X-Google-Smtp-Source: AHgI3IaWDEehnBG8/uYRmmOdYRTU0/y7pu302/gRQZB19FWfvaxxRkhz3DpqilX0R27zax+jIsR8XQ==
X-Received: by 2002:a17:902:505:: with SMTP id 5mr6811546plf.337.1551223707313;
        Tue, 26 Feb 2019 15:28:27 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id j68sm28306548pfc.64.2019.02.26.15.28.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Feb 2019 15:28:25 -0800 (PST)
Date:   Tue, 26 Feb 2019 15:28:23 -0800
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
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
Message-ID: <20190226232822.GA174696@google.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190224140426.3267-1-marc.zyngier@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ others

Hi Marc,

Thanks for the series. I have a few bits of history to add to this, and
some comments.

On Sun, Feb 24, 2019 at 02:04:22PM +0000, Marc Zyngier wrote:
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

You're not the first person to notice this. All the motivations are not
necessarily painted clearly in their cover letter, but here are some
previous attempts at solving this problem:

[RFC PATCH v11 0/5] PCI: rockchip: Move PCIe WAKE# handling into pci core
https://lkml.kernel.org/lkml/20171225114742.18920-1-jeffy.chen@rock-chips.com/
http://lkml.kernel.org/lkml/20171226023646.17722-1-jeffy.chen@rock-chips.com/

As you can see by the 12th iteration, it wasn't left unsolved for lack
of trying...

Frankly, if a proper DT replacement to the admittedly bad binding isn't
agreed upon quickly, I'd be very happy to just have WAKE# support
removed from the DTS for now, and the existing mwifiex binding should
just be removed. (Wake-on-WiFi was never properly vetted on these
platforms anyway.) It mostly serves to just cause problems like you've
noticed.

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

One problem Rockchip authors were also trying to resolve here is that
PCIe WAKE# handling should not really be something the PCI device driver
has to handle directly. Despite your complaints about not using in-band
TLP wakeup, a separate WAKE# pin is in fact a documented part of the
PCIe standard, and it so happens that the Rockchip RC does not support
handling TLPs in S3, if you want to have decent power consumption. (Your
"bad hardware" complaints could justifiably fall here, I suppose.)

Additionally, I've had pushback from PCI driver authors/maintainers on
adding more special handling for this sort of interrupt property (not
the binding specifically, but just the concept of handling WAKE# in the
driver), as they claim this should be handled by the system firmware,
when they set the appropriate wakeup flags, which filter down to
__pci_enable_wake() -> platform_pci_set_wakeup(). That's how x86 systems
do it (note: I know for a fact that many have a very similar
architecture -- WAKE# is not routed to the RC, because, why does it need
to? and they *don't* use TLP wakeup either -- they just hide it in
firmware better), and it Just Works.

So, we basically concluded that we should standardize on a way to
describe WAKE# interrupts such that PCI drivers don't have to deal with
it at all, and the PCI core can do it for us. 12 revisions later
and...we still never agreed on a good device tree binding for this.

IOW, maybe your wake-up sub-node is the best way to side-step the
problems of conflicting with the OF PCI spec. But I'd still really like
to avoid parsing it in mwifiex, if at all possible.

(We'd still be left with the marvell,wakeup-pin propery to parse
specifically in mwifiex, which sadly has to exist because....well,
Samsung decided to do chip-on-board, and then they failed to use the
correct pin on Marvell's side when wiring up WAKE#. Sigh.)

> The driver is then updated to look for this subnode first, and fallback to
> the original, broken behaviour (spitting out a warning in the offending
> configuration).
> 
> For good measure, there are two additional patches:
> 
> - The wake-up interrupt requesting is horribly racy, and could lead to
>   unpredictable behaviours. Let's fix that properly.

Ack. That mistake was repeated in other drivers and has since been fixed
in those. We need it here too.

Brian

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
> 
> -- 
> 2.20.1
> 
