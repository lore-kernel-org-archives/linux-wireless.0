Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9BDC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF48620819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EemBpve+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EemBpve+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF48620819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbeKEW22 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:28:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbeKEW21 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 17:28:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D5B8D60C5F; Mon,  5 Nov 2018 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423326;
        bh=XSyyoNBPsFpp5HZzch6yJ8aPqY6NppEVfGx2m1C6tY4=;
        h=From:To:Cc:Subject:Date:From;
        b=EemBpve+w9y7tJx39LpUYc1QVaGpv/iU7N9sc8bZnKUGY228Zu0WG97e76QRM6XHX
         8so6IazD/JxVRo+IKHhllnvFmcpPRPwtrVp1rkN4fBdyf4GZmCYcK+NqV9MtKiXS01
         OS0cRUzzgXyBYPhN0OUJ/YMfEL5HyL7W0rFee4nk=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9137A6053D;
        Mon,  5 Nov 2018 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423326;
        bh=XSyyoNBPsFpp5HZzch6yJ8aPqY6NppEVfGx2m1C6tY4=;
        h=From:To:Cc:Subject:Date:From;
        b=EemBpve+w9y7tJx39LpUYc1QVaGpv/iU7N9sc8bZnKUGY228Zu0WG97e76QRM6XHX
         8so6IazD/JxVRo+IKHhllnvFmcpPRPwtrVp1rkN4fBdyf4GZmCYcK+NqV9MtKiXS01
         OS0cRUzzgXyBYPhN0OUJ/YMfEL5HyL7W0rFee4nk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9137A6053D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org
Cc:     Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v4 0/3] Enable ath10k wcn3990 wifi driver support on sdm845 
Date:   Mon,  5 Nov 2018 18:38:35 +0530
Message-Id: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series enables ath10k wifi driver support for WCN3990 target
on sdm845 SOC. This series also updates the missing dt binding documentation
and adds optional iommu property.

Changes since v3:
    Moved interrupt/reg/reg-name to required property.
    Removed unused clocks.
    Corrected interrupt no's.

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

 .../bindings/net/wireless/qcom,ath10k.txt          | 62 ++++++++++++++--------
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 +++
 arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++
 3 files changed, 74 insertions(+), 22 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

