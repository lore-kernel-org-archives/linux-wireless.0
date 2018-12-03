Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E249FC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF82C2081C
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BXhmUHnv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BXhmUHnv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF82C2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbeLCRfd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 12:35:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeLCRfd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 12:35:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD1D260913; Mon,  3 Dec 2018 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543858525;
        bh=RPI8wq/o5rD0pLJ8Alj24SJE6v8fFnpIpei79G9hYmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXhmUHnvGoFGPbclOzlnP9OTB+h/OSHIYB6bWVGjHOt4yo6aaAX2OgQaRr+AzFBHI
         aDuzvBAZ7RXONFfi7Mxb7rzQv7oVnp9Q0cZ2c/bbM5kOD3ERKsKzgM+iSrXTRsPKd0
         SDorxvMvdQzz/fhLh3i4AKmNxfHl5JB5U7Pl9zu0=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F25D160247;
        Mon,  3 Dec 2018 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543858525;
        bh=RPI8wq/o5rD0pLJ8Alj24SJE6v8fFnpIpei79G9hYmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXhmUHnvGoFGPbclOzlnP9OTB+h/OSHIYB6bWVGjHOt4yo6aaAX2OgQaRr+AzFBHI
         aDuzvBAZ7RXONFfi7Mxb7rzQv7oVnp9Q0cZ2c/bbM5kOD3ERKsKzgM+iSrXTRsPKd0
         SDorxvMvdQzz/fhLh3i4AKmNxfHl5JB5U7Pl9zu0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F25D160247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v2 1/3] dt-bindings: net: ath10k: fix node name and device type in qcom ath10k example
Date:   Mon,  3 Dec 2018 23:03:33 +0530
Message-Id: <1543858415-23953-2-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
References: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In qcom,ath10k documentation, ath10k is used as node name in the example of
pci based device. Normally, node name shoud be class of device and not the model
name, so fix it to node name "wifi". And remove the property device_type pci
since only pci bridges should have this property.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 2196d1a..ef60f25 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -74,9 +74,8 @@ pci {
 		#address-cells = <3>;
 		device_type = "pci";
 
-		ath10k@0,0 {
+		wifi@0,0 {
 			reg = <0 0 0 0 0>;
-			device_type = "pci";
 			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
 		};
 	};
-- 
1.9.1

