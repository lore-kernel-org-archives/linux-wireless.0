Return-Path: <SRS0=mHGl=2G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1E5C43603
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 11:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3131220700
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 11:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Lupt2s9k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfLPLmJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Dec 2019 06:42:09 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:25582 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727316AbfLPLmJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Dec 2019 06:42:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576496528; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=3FEt1x6PkgE7MJoaVAZA0pUlBjtjXhuR6plIbJ7ZDV8=; b=Lupt2s9kkeGfgz/xFjpi6QZFBmN2QWEA4EUvViZ0JeK+B8DTtz0geE0GnI5VEqm5t+NN9EZM
 XhDdPfwVxZdgHd8U0Nj8dFspmTiV32oEwxAszzc9CmayGRLn1Tu5dgaYlvuhzHvSl0zjHAp/
 eQtct8ChQDCy1czzovnlAwtdHoM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df76d8d.7fa434fc1ce0-smtp-out-n02;
 Mon, 16 Dec 2019 11:42:05 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BDF08C43383; Mon, 16 Dec 2019 11:42:05 +0000 (UTC)
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06D80C433CB;
        Mon, 16 Dec 2019 11:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06D80C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh Chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        Tamizh Chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/2] dt-bindings: ath10k: Add new dt entries to identify coex support
Date:   Mon, 16 Dec 2019 17:10:14 +0530
Message-Id: <1576496415-23064-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds new dt entries qcom,coexist-support and qcom,coexist-gpio-pin
which will be used by ath10k driver to identify coex support
of a hardware and notify wifi firmware the gpio pin number.
This pin number information is needed for the hardware QCA4019.

Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 0171283..a41e936 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -87,6 +87,10 @@ Optional properties:
 	Definition: Quirk specifying that the firmware expects the 8bit version
 		    of the host capability QMI request
 - qcom,xo-cal-data: xo cal offset to be configured in xo trim register.
+- qcom,coexist-support : should contain eithr "0" or "1" to indicate coex
+			 support by the hardware.
+- qcom,coexist-gpio-pin : gpio pin number  information to support coex
+			  which will be used by wifi firmware.
 
 Example (to supply PCI based wifi block details):
 
@@ -156,6 +160,8 @@ wifi0: wifi@a000000 {
 	qcom,msi_addr = <0x0b006040>;
 	qcom,msi_base = <0x40>;
 	qcom,ath10k-pre-calibration-data = [ 01 02 03 ... ];
+	qcom,coexist-support = <1>;
+	qcom,coexist-gpio-pin = <0x33>;
 };
 
 Example (to supply wcn3990 SoC wifi block details):
-- 
1.9.1
