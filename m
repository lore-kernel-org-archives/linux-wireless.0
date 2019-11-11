Return-Path: <SRS0=nhxg=ZD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7933DC17441
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Nov 2019 04:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449C6214DB
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Nov 2019 04:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dtJf4f1w";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dtJf4f1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKKEZP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Nov 2019 23:25:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfKKEZP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Nov 2019 23:25:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9FD6460AD9; Mon, 11 Nov 2019 04:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573446314;
        bh=MYBm030xYLHdaohaJ+WmfgpEIwca6uZOPoCaZqvBAHk=;
        h=From:To:Cc:Subject:Date:From;
        b=dtJf4f1wmTWIOYiN/Vk52fGByFwFA8VBCikk0bjejGM/p3kHGgyFE9v8N95TeRs+J
         kjLTV80N+h1OsFbc3Atv4LnUw+PR8gve6PhPYL2xlkyECzUbImO4ibRRVNJWscpsVw
         i4Wh/QaTn+hHbvBfdHZg7NCKV+d6MBcR7ZDVc9FI=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC1A66083E;
        Mon, 11 Nov 2019 04:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573446314;
        bh=MYBm030xYLHdaohaJ+WmfgpEIwca6uZOPoCaZqvBAHk=;
        h=From:To:Cc:Subject:Date:From;
        b=dtJf4f1wmTWIOYiN/Vk52fGByFwFA8VBCikk0bjejGM/p3kHGgyFE9v8N95TeRs+J
         kjLTV80N+h1OsFbc3Atv4LnUw+PR8gve6PhPYL2xlkyECzUbImO4ibRRVNJWscpsVw
         i4Wh/QaTn+hHbvBfdHZg7NCKV+d6MBcR7ZDVc9FI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC1A66083E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 0/2] Don't call SCM interface for statically mapped msa region
Date:   Mon, 11 Nov 2019 09:55:06 +0530
Message-Id: <20191111042508.12628-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For some targets ex: SC7180/QCS404, SCM permissions for MSA region is
statically configured in TrustZone fw. Add SCM call disable option
for such targets to avoid duplicate permissions.

Change since v1:
    Added devicetree list for review.

Govind Singh (2):
  dt: bindings: add dt entry flag to skip SCM call for msa region
  ath10k: Don't call SCM interface for statically mapped msa region

 .../devicetree/bindings/net/wireless/qcom,ath10k.txt     | 4 ++++
 drivers/net/wireless/ath/ath10k/qmi.c                    | 9 +++++++++
 drivers/net/wireless/ath/ath10k/qmi.h                    | 1 +
 3 files changed, 14 insertions(+)

-- 
2.22.0

