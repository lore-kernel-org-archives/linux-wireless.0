Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E31C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 04:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096822075E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 04:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GxKdsU0P";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DTGpnaUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfCTEso (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 00:48:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbfCTEso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 00:48:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 69B3960DAD; Wed, 20 Mar 2019 04:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553057323;
        bh=7atp+JxqmU8JtBhm+x4paCEcFS0Nq8J2HdH/vFVMVcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxKdsU0PlUaRe2Y0T0ZKKwImkv2lTeoganHwoicPR2iRakSs2kaAK5bIsFayVx4oN
         n3N0+pi5L4C3Xpq4cxej5IgpV3+qLXLD9uX4AtF+E65Sr/VCVlLH03eV++oovrD/J9
         gKkYxuqjok+i8WwObTYkUffYiU+MUgbcQ5YnqT3M=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6612E60DAA;
        Wed, 20 Mar 2019 04:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553057322;
        bh=7atp+JxqmU8JtBhm+x4paCEcFS0Nq8J2HdH/vFVMVcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTGpnaUQ1QgK/oHV6gFh+3/GgvW55m/ZxZ04tLtXp4g1cLfQWvzYX1LYs+UhglBDj
         mBlfQIDHdtsSSaCuA6NhIE3mOeknt1A4sVl1Rs7LJUdSAWdb3OznaJBofCVn6sI3BJ
         3V7mgszKTikbkC3tv98GKTENIiui0Kfb4SdeJRKg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6612E60DAA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 1/2] dt: bindings: add dt entry for XO calibration support
Date:   Wed, 20 Mar 2019 10:15:10 +0530
Message-Id: <20190320044511.12172-2-govinds@codeaurora.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320044511.12172-1-govinds@codeaurora.org>
References: <20190320044511.12172-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add dt binding to get xo calibration data support for wifi rf clock.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index ae661e65354e..ab8042866e83 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -81,6 +81,7 @@ Optional properties:
 	Definition: Name of external front end module used. Some valid FEM names
 		    for example: "microsemi-lx5586", "sky85703-11"
 		    and "sky85803" etc.
+- xo-cal-data: xo cal offset to be configured in xo trim register.
 
 Example (to supply PCI based wifi block details):
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

