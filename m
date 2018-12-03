Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F38FC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3B4208A3
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iCK9++/S";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iCK9++/S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C3B4208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbeLCRfr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 12:35:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeLCRfr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 12:35:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A1CED6086B; Mon,  3 Dec 2018 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543858539;
        bh=r4LsDlByiQ5T/wrkeOJ+kfS4X/xFi0g10N9rWtcz5vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCK9++/ShjnDdS6b+vfnTv4toArQL0jFMdViKFmRVYKmiZupm4NmhB9BPNUx51PRJ
         h++4TdJ1cz+1s2Jd58VOoAWiD9f1UoQwy9oBiTZ7LFq8HC3TAKs4gJ3xv46Ht+gMCM
         fXJAWPUEKrJ+dzWKqdobEbJW7GsxfxRtZIhrAdcE=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3414860247;
        Mon,  3 Dec 2018 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543858539;
        bh=r4LsDlByiQ5T/wrkeOJ+kfS4X/xFi0g10N9rWtcz5vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCK9++/ShjnDdS6b+vfnTv4toArQL0jFMdViKFmRVYKmiZupm4NmhB9BPNUx51PRJ
         h++4TdJ1cz+1s2Jd58VOoAWiD9f1UoQwy9oBiTZ7LFq8HC3TAKs4gJ3xv46Ht+gMCM
         fXJAWPUEKrJ+dzWKqdobEbJW7GsxfxRtZIhrAdcE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3414860247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v2 2/3] dt-bindings: net: ath10k: add new dt entry to identify external FEM
Date:   Mon,  3 Dec 2018 23:03:34 +0530
Message-Id: <1543858415-23953-3-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
References: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
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
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index ef60f25..2dd0c52 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -61,8 +61,13 @@ Optional properties:
 	Value type: <phandle>
 	Definition: reference to the reserved-memory for the msa region
 		    used by the wifi firmware running in Q6.
+- ext-fem-name:
+	Usage: Optional
+	Value type: string
+	Definition: Name of external front end module used. Valid FEM names are
+		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc.
 
-Example (to supply the calibration data alone):
+Example (to supply PCI based wifi block details):
 
 In this example, the node is defined as child node of the PCI controller.
 
@@ -77,6 +82,7 @@ pci {
 		wifi@0,0 {
 			reg = <0 0 0 0 0>;
 			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+			ext-fem-name = "microsemi-lx5586";
 		};
 	};
 };
-- 
1.9.1

