Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A2DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69AFB2087D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FuIIJWcA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FuIIJWcA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69AFB2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeJJTPD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:15:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJTPC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 15:15:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F47660C60; Wed, 10 Oct 2018 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172394;
        bh=4i58qEHn/7FDzbaNuXuhOowwTYDSkpIVgOEYj4GeDYc=;
        h=From:To:Cc:Subject:Date:From;
        b=FuIIJWcAigaDenYIUt1RJmop7LO2FTWdqULU/OXrzBqU3JBWt8tHQN0MiVmUZyZav
         Lb7W5syuXhXIrQFq+9Vndup/ePVh9XiE0DIMQV6TTkDSxoLkeXCrK/DGw4h3eijU5E
         ZBBfRV9pHU2qPnxZB9x1bmSvjYmVgMq7Pte6thpk=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 358446021C;
        Wed, 10 Oct 2018 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172394;
        bh=4i58qEHn/7FDzbaNuXuhOowwTYDSkpIVgOEYj4GeDYc=;
        h=From:To:Cc:Subject:Date:From;
        b=FuIIJWcAigaDenYIUt1RJmop7LO2FTWdqULU/OXrzBqU3JBWt8tHQN0MiVmUZyZav
         Lb7W5syuXhXIrQFq+9Vndup/ePVh9XiE0DIMQV6TTkDSxoLkeXCrK/DGw4h3eijU5E
         ZBBfRV9pHU2qPnxZB9x1bmSvjYmVgMq7Pte6thpk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 358446021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org
Cc:     Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 0/3] Enable ath10k wcn3990 wifi driver support on sdm845
Date:   Wed, 10 Oct 2018 17:22:53 +0530
Message-Id: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series enables ath10k wifi driver support for WCN3990 target
on sdm845 SOC. This series also updates the missing dt binding documentation
and adds optional iommu property.

Changes since v2:
    dropped [v2,4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi module
    device node patch from the series as dependent patch is not yet merged.
    Enabled status flag from sdm845-mtp.dts.

Changes since v1:
    Listed no of interrupts/clocks for each set of compatible.
    Added missing 'wifi' label to sdm845.dtsi.

Govind Singh (3):
  dt: bindings: add missing dt properties for WCN3990 wifi node
  dts: arm64/sdm845: Add WCN3990 WLAN module device node
  dt: bindings: add bindings for wifi iommu node

 .../bindings/net/wireless/qcom,ath10k.txt          | 33 +++++++++++++++++-----
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 ++++++
 arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++++++++++
 3 files changed, 60 insertions(+), 7 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

