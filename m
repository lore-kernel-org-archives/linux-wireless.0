Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409D9C5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05AD720879
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bs2VqGV5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dnwjTg61"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05AD720879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbeLKQON (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:14:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbeLKQOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 11:14:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65B6961658; Tue, 11 Dec 2018 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544544851;
        bh=7nDCxlcA7tBZzDUxofMXYs9pdtPUeaBr6QXvjbDoXGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bs2VqGV5GCzv9Ybh1OK/Idy84td/h4rAB3L8fenDe2UKUVyWSGyngClOHqId9UJCj
         zvtQJXDpKHAOIX2uiTTr0jzJ0WJzIq3GOOZALbGkX8SF7akJMbatQPugDGKitsRyCZ
         zsgzLv6jEH++1OVL6VplEdxkaVTI6nXj0h2x5F30=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61D8A6161F;
        Tue, 11 Dec 2018 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544544832;
        bh=7nDCxlcA7tBZzDUxofMXYs9pdtPUeaBr6QXvjbDoXGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnwjTg617nUOmhLn3Ryt1o7vDchVvs2VildFLVpedeFPWaJpx11BwG5T0Oupa8+Du
         9ZlDBfU+mD6xDSiBpgtNq17v9rMwBQIW29x+SQYaswfXcye2RYzeleyWfrBDWYqgwp
         GUETZuI5DT8nzMVGKYbusL4UarG+sbjkdarBhRcw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 61D8A6161F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v4 1/3] dt-bindings: net: ath10k: fix node name and device type in qcom ath10k example
Date:   Tue, 11 Dec 2018 21:43:22 +0530
Message-Id: <1544544804-4039-2-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
References: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In qcom,ath10k documentation, ath10k is used as node name in the example of
pci based device. Normally, node name should be class of device and not the
model name, so fix it to node name "wifi". And remove the property device_type
pci since only pci bridges should have this property.

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

