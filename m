Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3CDC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9186020666
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pGjp+xt1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K9qNoTny"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9186020666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbeJASEK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbeJASEK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C228360588; Mon,  1 Oct 2018 11:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393210;
        bh=dfJgJaidXisM+vYSiL7nytb8lu2DtetIoKylaGr/MgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGjp+xt13405bSSL7Jb8FwNNTnM0laW/1OgbwkhbvfSvgzBowQIT6puUhjmM33Dzg
         mhQx7NOVy2HcCHdculcL3Z16+g0HD8op49MBx5syulgbkANGUIKwfsmMi+ryD1WVHJ
         9JGXGo/sUGlTBBmTNT12eYdOgmYZ5uDnC9DuM/Nw=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E42B6060A;
        Mon,  1 Oct 2018 11:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393209;
        bh=dfJgJaidXisM+vYSiL7nytb8lu2DtetIoKylaGr/MgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9qNoTnyBD23EIL8HY6gfNesPX1oL4QWRr2PmQsr1JRJr8JQ0vKEsG3H97+ze7cRI
         YxPVifJGXIhOZX4Kwg3agBiyrbVivcMUVeALPH1TO6HOM4qncRRtcFEsRrlWLWSEAE
         AI1G5oWjkeZkoDBOykvS2/ri1DSivDTrAUh1E49g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E42B6060A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, briannorris@chromium.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 2/4] dts: arm64/sdm845: Add WCN3990 WLAN module device node
Date:   Mon,  1 Oct 2018 16:56:34 +0530
Message-Id: <20181001112636.31715-3-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001112636.31715-1-govinds@codeaurora.org>
References: <20181001112636.31715-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add device node for the ath10k SNOC platform driver probe
and add resources required for WCN3990 on SDM845 soc.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts |  7 +++++++
 arch/arm64/boot/dts/qcom/sdm845.dtsi    | 26 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
index eedfaf8922e2..4de57f7df93c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -440,3 +440,10 @@
 		bias-pull-up;
 	};
 };
+
+&wifi {
+	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
+	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
+	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
+	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+};
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index e080072cdfdb..36c716cf3a0c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -86,6 +86,11 @@
 			reg = <0 0x86200000 0 0x2d00000>;
 			no-map;
 		};
+
+		wlan_msa_mem: reserved-memory@96700000 {
+			no-map;
+			reg = <0 0x96700000 0 0x100000>;
+		};
 	};
 
 	cpus {
@@ -1200,5 +1205,26 @@
 				status = "disabled";
 			};
 		};
+
+		wifi: wifi@18800000 {
+			compatible = "qcom,wcn3990-wifi";
+			status = "disabled";
+			reg = <0x18800000 0x800000>;
+			reg-names = "membase";
+			memory-region = <&wlan_msa_mem>;
+			interrupts =
+				<0 413 0 /* CE0 */ >,
+				<0 414 0 /* CE1 */ >,
+				<0 415 0 /* CE2 */ >,
+				<0 416 0 /* CE3 */ >,
+				<0 417 0 /* CE4 */ >,
+				<0 418 0 /* CE5 */ >,
+				<0 420 0 /* CE6 */ >,
+				<0 421 0 /* CE7 */ >,
+				<0 422 0 /* CE8 */ >,
+				<0 423 0 /* CE9 */ >,
+				<0 424 0 /* CE10 */ >,
+				<0 425 0 /* CE11 */ >;
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

