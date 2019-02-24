Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBF5C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B32206B6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfBXOFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 09:05:10 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:52460 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfBXOFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 09:05:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7859A78;
        Sun, 24 Feb 2019 06:05:08 -0800 (PST)
Received: from why.lan (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B762A3F690;
        Sun, 24 Feb 2019 06:05:05 -0800 (PST)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
Date:   Sun, 24 Feb 2019 14:04:22 +0000
Message-Id: <20190224140426.3267-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For quite some time, I wondered why the PCI mwifiex device built in my
Chromebook was unable to use the good old legacy interrupts. But as MSIs
were working fine, I never really bothered investigating. I finally had a
look, and the result isn't very pretty.

On this machine (rk3399-based kevin), the wake-up interrupt is described as
such:

&pci_rootport {
	mvl_wifi: wifi@0,0 {
		compatible = "pci1b4b,2b42";
		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
		interrupt-parent = <&gpio0>;
		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
		pinctrl-names = "default";
		pinctrl-0 = <&wlan_host_wake_l>;
		wakeup-source;
	};
};

Note how the interrupt is part of the properties directly attached to the
PCI node. And yet, this interrupt has nothing to do with a PCI legacy
interrupt, as it is attached to the wake-up widget that bypasses the PCIe RC
altogether (Yay for the broken design!). This is in total violation of the
IEEE Std 1275-1994 spec[1], which clearly documents that such interrupt
specifiers describe the PCI device interrupts, and must obey the
INT-{A,B,C,D} mapping. Oops!

The net effect of the above is that Linux tries to do something vaguely
sensible, and uses the same interrupt for both the wake-up widget and the
PCI device. This doesn't work for two reasons: (1) the wake-up widget grabs
the interrupt in exclusive mode, and (2) the PCI interrupt is still routed
to the RC, leading to a screaming interrupt. This simply cannot work.

To sort out this mess, we need to lift the confusion between the two
interrupts. This is done by extending the DT binding to allow the wake-up
interrupt to be described in a 'wake-up' subnode, sidestepping the issue
completely. On my Chromebook, it now looks like this:

&pci_rootport {
	mvl_wifi: wifi@0,0 {
		compatible = "pci1b4b,2b42";
		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
		pinctrl-names = "default";
		pinctrl-0 = <&wlan_host_wake_l>;
		wake-up {
			interrupt-parent = <&gpio0>;
			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
			wakeup-source;
		};
	};
};

The driver is then updated to look for this subnode first, and fallback to
the original, broken behaviour (spitting out a warning in the offending
configuration).

For good measure, there are two additional patches:

- The wake-up interrupt requesting is horribly racy, and could lead to
  unpredictable behaviours. Let's fix that properly.

- A final patch implementing the above transformation for the whole
  RK3399-based Chromebook range, which all use the same broken
  configuration.

With all that, I finally have PCI legacy interrupts working with the mwifiex
driver on my Chromebook.

[1] http://www.devicetree.org/open-firmware/bindings/pci/pci2_1.pdf

Marc Zyngier (4):
  dt-bindings/marvell-8xxx: Allow wake-up interrupt to be placed in a
    separate node
  mwifiex: Fetch wake-up interrupt from 'wake-up' subnode when it exists
  mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling
    it too late
  arm64: dts: rockchip: gru: Move wifi wake-up interrupt into its own
    subnode

 .../bindings/net/wireless/marvell-8xxx.txt    | 23 ++++++++++++++++++-
 .../dts/rockchip/rk3399-gru-chromebook.dtsi   |  8 ++++---
 drivers/net/wireless/marvell/mwifiex/main.c   | 13 +++++++++--
 3 files changed, 38 insertions(+), 6 deletions(-)

-- 
2.20.1

