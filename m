Return-Path: <SRS0=v3Rz=VA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5593C06511
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 03:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB02021721
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 03:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a18CdN/R";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n6JWO34M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGCD5S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Jul 2019 23:57:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfGCD5R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jul 2019 23:57:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 55BBA6038E; Wed,  3 Jul 2019 03:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562126237;
        bh=Aq4cCJDxYrULJtxL5b8KPbo01q6oair5ivvgUrHGj6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=a18CdN/RaEcu548QrtYRLupKrQAp2ZRPD+2Ht2MuLkNTeAYVz3i8DlToH0menNywH
         dprrU6XyNbkWRIRuiOMcT4JLrtq+UgLVWUcOwT2O1sDCecYhFLx0RD5+hYvK6VUbmj
         r906kT8IdA9KO48nWcaYRP2l4lXLAe97H6cgn0JM=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 337DF6038E;
        Wed,  3 Jul 2019 03:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562126236;
        bh=Aq4cCJDxYrULJtxL5b8KPbo01q6oair5ivvgUrHGj6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=n6JWO34Mw4XbxIkJ5pVYQLK0Kb9XAhSRICWo/9GRxn8NWvJHLkgpuaUnUHUylBQBS
         hEhydJy1vV7e281f9BHERULra8pGFSIPprxkrfrBkcGuQEShSkBbIb4T+/SKs7fFta
         YtAP734tO2DRzgqOopGQpt34xYQhrIwklYGIhu8o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 337DF6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 0/3] Move voltage regulator config to driver private data
Date:   Wed,  3 Jul 2019 09:27:08 +0530
Message-Id: <20190703035711.25592-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 voltage regulator config is varying b/w different MSM platforms ex: SDM845/
QCS404. In order to have scalable config, move regulator config to driver
private data.

Tested HW: WCN3990(SDM845/QCS404)
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Govind Singh (3):
  dt: bindings: update compatible dt properties for WCN3990 wifi node
  ath10k: Move regulator config to driver private data
  arm64: dts: qcom: qcs404: Modify wifi dt node for SDM845/QCS404
    devices

 .../bindings/net/wireless/qcom,ath10k.txt     |  2 +
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi      |  3 ++
 arch/arm64/boot/dts/qcom/qcs404.dtsi          |  2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  2 +-
 drivers/net/wireless/ath/ath10k/snoc.c        | 38 +++++++++++++++----
 drivers/net/wireless/ath/ath10k/snoc.h        | 23 ++++++-----
 6 files changed, 51 insertions(+), 19 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

