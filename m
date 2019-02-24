Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329CDC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA0B206B6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfBXOFY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 09:05:24 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:52534 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfBXOFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 09:05:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6DD1A78;
        Sun, 24 Feb 2019 06:05:22 -0800 (PST)
Received: from why.lan (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B4963F690;
        Sun, 24 Feb 2019 06:05:19 -0800 (PST)
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
Subject: [PATCH 4/4] arm64: dts: rockchip: gru: Move wifi wake-up interrupt into its own subnode
Date:   Sun, 24 Feb 2019 14:04:26 +0000
Message-Id: <20190224140426.3267-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190224140426.3267-1-marc.zyngier@arm.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to get PCIe legacy interrupts working on gru-based Chromebooks,
let's move the wake-up interrupt out of the way and into its own
subnode. This ensures that this interrupt specifier will not be
mistaken as a PCI interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index c400be64170e..61fff688770c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -310,11 +310,13 @@ ap_i2c_tp: &i2c5 {
 		compatible = "pci1b4b,2b42";
 		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
 		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
-		interrupt-parent = <&gpio0>;
-		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&wlan_host_wake_l>;
-		wakeup-source;
+		wake-up {
+			interrupt-parent = <&gpio0>;
+			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
+			wakeup-source;
+		};
 	};
 };
 
-- 
2.20.1

