Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D00BC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EBB20666
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W+G8rEer";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m4otOTB/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3EBB20666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbeJASED (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbeJASED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E0E86076A; Mon,  1 Oct 2018 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393204;
        bh=bdketOBVyt4SBy9u66xDrgjdDNNmY/gR24SXuN3arRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=W+G8rEerEiRzxn98af7kGFLmCJpUsUpbKVXiZmw8QnjENFVM4XD7v0RIcs01gIHPE
         gt9A/XVGKXKO8700pjikr6mg0cJ9CkG3RK/eg00zUQlcTB/bFq8k1ydVLf4o56+3z2
         bB2uk4WL0A0ilsWKw/DbK8gTzxZmBRVKobMzvKEU=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24EE860588;
        Mon,  1 Oct 2018 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393203;
        bh=bdketOBVyt4SBy9u66xDrgjdDNNmY/gR24SXuN3arRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=m4otOTB/6hcZx+/qSwjNZSkaVNs0GPbvSnT6Z9kQcpUP6RmC5v7Z6DwVPfjuGbkZO
         upVQ/pI/mxoze2UJnP09IQ9bKxNTnhTYsU2YLkw/g24N3hnOY8CVzZbhahAD4sp0EE
         jTGcRungx1Wq412KRpZAJxLMnFypJD63w0g+b36o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 24EE860588
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, briannorris@chromium.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 0/4] Enable ath10k wcn3990 wifi driver support on sdm845
Date:   Mon,  1 Oct 2018 16:56:32 +0530
Message-Id: <20181001112636.31715-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series enables ath10k wifi driver support for WCN3990 target
on sdm845 SOC. This series also updates the missing dt binding documentation
and adds optional iommu property.

sdm845 dtsi changes in this series are based on top of
https://patchwork.kernel.org/cover/10573121/ change.

Changes since v1:
	Listed no of interrupts/clocks for each set of compatible.
	Added missing 'wifi' label to sdm845.dtsi.

Govind Singh (4):
  dt: bindings: add missing dt properties for WCN3990 wifi node
  dts: arm64/sdm845: Add WCN3990 WLAN module device node
  dt: bindings: add bindings for wifi iommu node
  dts: arm64/sdm845: Enable iommu for WCN3990 wifi module device node

 .../bindings/net/wireless/qcom,ath10k.txt     | 34 +++++++++++++++----
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts       |  7 ++++
 arch/arm64/boot/dts/qcom/sdm845.dtsi          | 27 +++++++++++++++
 3 files changed, 61 insertions(+), 7 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

