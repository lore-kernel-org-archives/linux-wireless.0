Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B453C5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D433F20879
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OPlkY9p1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eRskU1RP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D433F20879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbeLKQOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:14:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbeLKQOC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 11:14:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA330615F3; Tue, 11 Dec 2018 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544544841;
        bh=16nq+ObuH9jbk5/t2LdzxWLtBW8Vkop+pRrFcJbeQSU=;
        h=From:To:Cc:Subject:Date:From;
        b=OPlkY9p1po/JSl/5H6G70Ke2BVFaUzxbYJ894NYZk/fQUloGVfC/MyNsvK/LkAwEa
         yTfzFU+smLquIWWA1GRmTzUjE1Ue5ZrvBiR5yTMFg+qGbsQmLCY+AYZPSNOvK7JyDT
         YtocLTe9vOT0gV9NX+bZ/Hu323Ce7hRUOWTn/QmQ=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67B08615B5;
        Tue, 11 Dec 2018 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544544820;
        bh=16nq+ObuH9jbk5/t2LdzxWLtBW8Vkop+pRrFcJbeQSU=;
        h=From:To:Cc:Subject:Date:From;
        b=eRskU1RP5amU1+wCo33I1FaSQADbUsC8tkYfo7qZMo10ajNtngC13HDVmZgjnLZY6
         kbDQ4PfLm31DAXzIH/mVL3Z5DTgsS/g5F1bjSekbKZKHTdN78fE87jP2VQNr5jHk7a
         4MOmH9WitCzONAcuvlfIuBGH7AG1WLlyzuibGzGs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 67B08615B5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v4 0/3] ath10k: Add support to configure BB timing for external FEM
Date:   Tue, 11 Dec 2018 21:43:21 +0530
Message-Id: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
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

v4:
 Corrected typo error in the commit log of PATCH 1/3.

 .../bindings/net/wireless/qcom,ath10k.txt          | 12 ++++--
 drivers/net/wireless/ath/ath10k/mac.c              | 47 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h          | 20 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c              | 23 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h              | 26 ++++++++++++
 5 files changed, 125 insertions(+), 3 deletions(-)

-- 
1.9.1

