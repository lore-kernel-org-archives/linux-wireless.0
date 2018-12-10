Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BCCC5CFFE
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A232082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R+K3C9Q9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NlExte1h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A232082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbeLJSdY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 13:33:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLJSdY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 13:33:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 70B1E61493; Mon, 10 Dec 2018 18:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466803;
        bh=rp85zFrM9h04F/NBT49kJMDBMx25iwdC30egTeXwNwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=R+K3C9Q9XE46CplGNa0rRpW8tK/SLG7S2BDptS63LTxXXyGDm6hUB0c2v6WwfIbfO
         qh+DMFntT9dDmlCS0A6c7gwBIkur9EyPIM5GDLCZLcPiO1eA0GuddDftKqJ6rzB66w
         NHhSWwPePOsDn7RbL/26+qv3AT9t5w90FogXvM2k=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 799CE6147D;
        Mon, 10 Dec 2018 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466802;
        bh=rp85zFrM9h04F/NBT49kJMDBMx25iwdC30egTeXwNwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NlExte1hXGxOuhcb0tOj7CkStSt+F/PeSB/brHgyQhCDaqgnB23Kf7MTCZEAXn61C
         UHmWXd5tuuEN4qKia8o7tK3J8o4gDEcC3H+9U/1/q0DZReWqo3pQ4gXJSFec38z0kX
         hTSk2JcRnpp36dMZY0Ybawrf4hngrI8ygMKUl4hw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 799CE6147D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v3 0/3] ath10k: Add support to configure BB timing for external FEM
Date:   Tue, 11 Dec 2018 00:01:28 +0530
Message-Id: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds support to choose correct Base Band(BB) timing values based on
the input Front End Module(FEM) hardware name from Device Tree entry and
configure it in hardware through WMI interface. Since the BB timing values
can vary between FEM hardwares and not same as default value used
in reference hardware.

Bhagavathi Perumal S (3):
  dt-bindings: net: ath10k: fix node name and device type in qcom ath10k
    example
  dt-bindings: net: ath10k: add new dt entry to identify external FEM
  ath10k: Add support to configure BB timing over wmi

v2:
 Addressed review comments in dt:
  * Fixed node name and device type with new dt patch "dt-bindings: net: ath10k:
     fix node name and device type in qcom ath10k example".
  * Changed the dt patch subject to "dt-bindings: net: ath10k: add new dt entry
    to identify external FEM".
  * Added new property in existing example.
  * Enumarated some valid FEM names.

v3:
 Addressed review comments in valid fem names.

 .../bindings/net/wireless/qcom,ath10k.txt          | 12 ++++--
 drivers/net/wireless/ath/ath10k/mac.c              | 47 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h          | 20 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c              | 23 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h              | 26 ++++++++++++
 5 files changed, 125 insertions(+), 3 deletions(-)

-- 
1.9.1

