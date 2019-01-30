Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17D2C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63797218A4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UKs1gSnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfA3OH7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:07:59 -0500
Received: from nbd.name ([46.4.11.11]:40148 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbfA3OH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 09:07:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uQ6S6ba2XnLNApBEhlf5oY720Y/IkB92YzXTbNSpzqM=; b=UKs1gSnHLmJ0t5KC++ZlasO64a
        A5n8ac5eWpnx2BK+bJwWPZ7cx/d910Vrowof5Bvtqvo7LRKwJHej4bQ9/CZWgHWeNoQvapgzWAKGq
        Rqa0II3MdO0MTR7BtVvU/TqV2SMLt2k7BhGNi/9Q25mD+VcIifgNd9PZ17YCc8yawWyA=;
Received: by maeck.lan (Postfix, from userid 501)
        id 522374E25A72; Wed, 30 Jan 2019 15:07:56 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     devicetree@vger.kernel.org
Subject: [PATCH 2/3] dt-bindings: net: mt76: update binding for mt7603 driver
Date:   Wed, 30 Jan 2019 15:07:55 +0100
Message-Id: <20190130140756.91317-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190130140756.91317-1-nbd@nbd.name>
References: <20190130140756.91317-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In addition to MT7603E PCI devices, the driver supports the WLAN core on
MT7628/MT7688, which needs to be defined in DT.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../bindings/net/wireless/mediatek,mt76.txt   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
index 0c17a0ec9b7b..7b9a776230c0 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -4,6 +4,13 @@ This node provides properties for configuring the MediaTek mt76xx wireless
 device. The node is expected to be specified as a child node of the PCI
 controller to which the wireless chip is connected.
 
+Alternatively, it can specify the wireless part of the MT7628/MT7688 SoC.
+For SoC, use the compatible string "mediatek,mt7628-wmac" and the following
+properties:
+
+- reg: Address and length of the register set for the device.
+- interrupts: Main device interrupt
+
 Optional properties:
 
 - mac-address: See ethernet.txt in the parent directory
@@ -30,3 +37,15 @@ Optional nodes:
 		};
 	};
 };
+
+MT7628 example:
+
+wmac: wmac@10300000 {
+	compatible = "mediatek,mt7628-wmac";
+	reg = <0x10300000 0x100000>;
+
+	interrupt-parent = <&cpuintc>;
+	interrupts = <6>;
+
+	mediatek,mtd-eeprom = <&factory 0x0000>;
+};
-- 
2.17.0

