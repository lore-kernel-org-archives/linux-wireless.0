Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4467FC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD2021473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="buTJzBbK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g9Vq+XFN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AD2021473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbeJDShq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 14:37:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbeJDShq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 14:37:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0F86860C85; Thu,  4 Oct 2018 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538653492;
        bh=yZUtWdOi8dnrM+2aNCCmHNmdozf5HJINn0PjHSS5dvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buTJzBbKqDMR6fcJDxvVNFG5WDqHfbgrJGpG+OFd3jf5eH8FUPsmSgGEc6hjA5H/7
         uSrOG2M0KmRgy72bbDRYBNTyScCZcvfaRWsEh/bWE4lXhRBxv8rBYpTAfNafwzolns
         RorJGAoy761wKoc2iEZIIC+cc5iIGYpLNyPqp9vI=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8D0E607BD;
        Thu,  4 Oct 2018 11:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538653491;
        bh=yZUtWdOi8dnrM+2aNCCmHNmdozf5HJINn0PjHSS5dvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9Vq+XFN3PzokJAxZlIN+CDco1h9Oyc4vu9tXnEZXyf/rwuMd0+GdPUiDWSNt7BNJ
         MK7d+JUUn0vA9+GwQTIKTa1jhbvHTqPIWz812kdgX9h45D7itO3iZjGVa6nyJO1j2K
         c2EhF1tDhWTMR3J3t8He99oz4EWEATq+Ltr86Mjo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8D0E607BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        bperumal@codeaurora.org
Subject: [PATCH 1/2] dt: bindings: add new dt entry to indentify external FEM
Date:   Thu,  4 Oct 2018 17:12:43 +0530
Message-Id: <1538653364-1239-2-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
References: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds new dt entry ext-fem-name, it is used by ath10k driver
to select correct timing parameters and configure it in target wifi hardware.
The Front End Module(FEM) normally includes tx power amplifier(PA) and
rx low noise amplifier(LNA). The default timing parameters like tx end to
PA off timing values were fine tuned for internal FEM used in reference
design. And these timing values can not be same if ODM modifies hardware
design with different external FEM. This DT entry helps to choose correct
timing values in driver if different external FEM hardware used.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt          | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8c..fbaf309 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -56,6 +56,7 @@ Optional properties:
 				     the length can vary between hw versions.
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" is "vdd-0.8-cx-mx".
+- ext-fem-name: name of external front end module used.
 
 Example (to supply the calibration data alone):
 
@@ -150,3 +151,24 @@ wifi@18000000 {
 			   <0 141 0 /* CE11 */ >;
 		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
 };
+
+Example (to supply the external front end module name):
+
+In this example, the front end module is defined as a property of the ath10k
+device node.
+
+pci {
+	pcie@0 {
+		reg = <0 0 0 0 0>;
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		device_type = "pci";
+
+		ath10k@0,0 {
+			reg = <0 0 0 0 0>;
+			device_type = "pci";
+			ext-fem-name = "microsemi-lx5586";
+		};
+	};
+};
-- 
1.9.1

