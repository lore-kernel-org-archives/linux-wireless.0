Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D0CC04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D7072082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WRvkVHv1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LQHvu73U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D7072082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbeLJSdy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 13:33:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLJSdy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 13:33:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F4B7614BD; Mon, 10 Dec 2018 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466833;
        bh=ga9RyYbpcoVkNI6F/pCJo1PU2BYZuQzbYpMXaa65yyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRvkVHv1soND8gA6YEY4Ojm5n74hFQmgze8hPJJuNOKYO1Kd51QX5aHjWrmj+QgMb
         G1HqOpbgrU1Doc3gGkOCmv630+fYTFlX0YmjTFX55WIlX2rkR5K/0ufoxwC8TFf/gO
         4VvFK1c6LPTzmnTjt/YU+2nRY1Y9vXRJ/n32BYfQ=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C8DA561550;
        Mon, 10 Dec 2018 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466826;
        bh=ga9RyYbpcoVkNI6F/pCJo1PU2BYZuQzbYpMXaa65yyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQHvu73UeJe8d09VHOeOzWcKiKJcBFK3Am9VXVDr2uOaXebUu0vF5PbdH7zVbNtEP
         GL6WfwuWS48+Au9HQ1ial8KbLiCINfXXUIe8txfPNCHnDb7zjaIDTYNxMaVryOnO9S
         9pQcthAvOr6gR1oYd1UnYk/EfO5Mgzu2kMeTtqOo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C8DA561550
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v3 2/3] dt-bindings: net: ath10k: add new dt entry to identify external FEM
Date:   Tue, 11 Dec 2018 00:01:30 +0530
Message-Id: <1544466691-11821-3-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
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
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index ef60f25..71530fd 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -61,8 +61,14 @@ Optional properties:
 	Value type: <phandle>
 	Definition: reference to the reserved-memory for the msa region
 		    used by the wifi firmware running in Q6.
+- ext-fem-name:
+	Usage: Optional
+	Value type: string
+	Definition: Name of external front end module used. Some valid FEM names
+		    for example: "microsemi-lx5586", "sky85703-11"
+		    and "sky85803" etc.
 
-Example (to supply the calibration data alone):
+Example (to supply PCI based wifi block details):
 
 In this example, the node is defined as child node of the PCI controller.
 
@@ -77,6 +83,7 @@ pci {
 		wifi@0,0 {
 			reg = <0 0 0 0 0>;
 			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+			ext-fem-name = "microsemi-lx5586";
 		};
 	};
 };
-- 
1.9.1

