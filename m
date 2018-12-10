Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9665AC67839
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D6CD2082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n9o7Xg5Q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b5L/vuDv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D6CD2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbeLJSdh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 13:33:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLJSdg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 13:33:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AEA506130B; Mon, 10 Dec 2018 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466815;
        bh=RPI8wq/o5rD0pLJ8Alj24SJE6v8fFnpIpei79G9hYmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9o7Xg5QBHTKBNQbHBI6Oh+KHPcxK0NtLwpIVIch4i0addbfQgoFJXNxmWYXvzWll
         wqsw5mOvA1KkT2GMRroBvQxu2CfTM8g0CUar81vlI/JI2u8Zlxcf7KTse7POW4sMvx
         OkCG9n2J/CZsXBxDgstljiTNFXXa+Ad3bgmGrSno=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDDF560C48;
        Mon, 10 Dec 2018 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466814;
        bh=RPI8wq/o5rD0pLJ8Alj24SJE6v8fFnpIpei79G9hYmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5L/vuDvH2TwPjaBkhnM3sJbDAjk0hBPourwlJhLI7dSFm/f9/262VmG3TBmVxGu6
         P3DVlRbFDlT3MXW07L97/LzkieGppexCx/QRjy/vBi1kaBg4cXP4A4y3+nI5ksycpS
         GAx7ewh9q4K7hW3RcZ6nY1eApvaV9VQs0A45uy1E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BDDF560C48
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v3 1/3] dt-bindings: net: ath10k: fix node name and device type in qcom ath10k example
Date:   Tue, 11 Dec 2018 00:01:29 +0530
Message-Id: <1544466691-11821-2-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
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

