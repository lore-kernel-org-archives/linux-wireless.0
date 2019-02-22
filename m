Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCA4C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD0E20818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A7Kc/s7i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bNdH/rym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfBVHUw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:20:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfBVHUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:20:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 39EE46090B; Fri, 22 Feb 2019 07:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820051;
        bh=Zn5xrpp9/S2U7Wz+rNaG5utJLAVmBnm7Dj6oDT/DVhw=;
        h=From:To:Cc:Subject:Date:From;
        b=A7Kc/s7i+7r55/r/GIakKPI0005PAeyXGn8Bn6mXTaz82/DA5xeWwnRCqR9pIymmb
         gwxC3lb3pAr9R4wji+9auctFOSA8EjSHr719baRKVDPs1c5sAB/Nsc54m6iqRfZz0M
         LEKRIhCRfsjXdNVg4Y5aBQnfgU4byaE5L9hDLKtg=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D20A608D4;
        Fri, 22 Feb 2019 07:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820045;
        bh=Zn5xrpp9/S2U7Wz+rNaG5utJLAVmBnm7Dj6oDT/DVhw=;
        h=From:To:Cc:Subject:Date:From;
        b=bNdH/rymqJpRF3qE5G+e7AMLfzlr2b19fCKr1gYbhUCg1SeMBa7vkVMrEHi2YNkyV
         SMoxKL3VPsEPMhg8qs0glkWZXeirB1rigv0PGHMJybjxSz2SFtlc54UUeqiYjjX9Nl
         0Gd4ENL1nsMFVLZkXGzB6U9j4KXnkddNnSMw5mQA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1D20A608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 0/4] Fix inconsistencies observed in population of tx_stats in debugfs
Date:   Fri, 22 Feb 2019 12:50:30 +0530
Message-Id: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There are some inconsistencies observed while filling various peer tx stats in tx_stats
debugfs entry per sta.

This patchset fixes the wrong updation of NSS, SGI, Bandwidth and rate_table in tx_stats
debugfs entry per sta.

Surabhi Vishnoi (4):
  ath10k: Fix the incorrect updation of NSS data in tx stats
  ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
  ath10k: Fix the wrong updation of SGI in tx_stats debugfs
  ath10k: Fix the wrong calculation ht_idx and idx of rate table for
    tx_stats

 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  8 +++++---
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 25 +++++++++++++------------
 drivers/net/wireless/ath/ath10k/wmi.h         |  3 ++-
 3 files changed, 20 insertions(+), 16 deletions(-)

-- 
1.9.1

