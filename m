Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C083C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392F72147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kT5a3vbL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fpOsCM7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfBZJ2L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:28:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZJ2L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:28:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2FDB360E5D; Tue, 26 Feb 2019 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173290;
        bh=VQLEWaLvpFhmeyRn+DYXOaJoZ0DT8PYj2TgSVjJyzd0=;
        h=From:To:Cc:Subject:Date:From;
        b=kT5a3vbL0GJ79Ozc7gN++4lisxsjC8kpoJqbqYa4DX1MV2vMjQ/LCh9L2AJM6dPS/
         qCQHzowtatxR8obaSw1gBvEuM6A2k+lFLiHrv6KeMKAcwfkw0NhNHQIhOpuys/d0gb
         vp0+wg/wlXSHRQGzbcyRpf1SxWQVRwHFFyB2oBq0=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7569160767;
        Tue, 26 Feb 2019 09:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173289;
        bh=VQLEWaLvpFhmeyRn+DYXOaJoZ0DT8PYj2TgSVjJyzd0=;
        h=From:To:Cc:Subject:Date:From;
        b=fpOsCM7UENYCaLDNQj1PaHcEnHkmDrgyzAPWPwDP9FOU432Btp5YQo2rfKQGiXXTa
         0yuKt9VszyA4/vZJ153FZEsGr+qE1ejdoeWOoVIcYlI2qkGHCRzhdHR+krzgPpR0hb
         Tjcej/81lylp9qOyu/q/5sZvrzrA8dUs3O4Gs/pI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7569160767
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2 0/4] Fix inconsistencies observed in population of tx_stats in debugfs
Date:   Tue, 26 Feb 2019 14:57:54 +0530
Message-Id: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There are some inconsistencies observed while filling various peer tx stats in tx_stats
debugfs entry per sta.

This patchset fixes the wrong updation of NSS, SGI, Bandwidth and rate_table in tx_stats
debugfs entry per sta.

Changes from v1:
-Initialized the uninitialized variable flags in [Patch 3/4]

Surabhi Vishnoi (4):
  ath10k: Fix the incorrect updation of NSS data in tx stats
  ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
  ath10k: Fix the wrong updation of SGI in tx_stats debugfs
  ath10k: Fix the wrong calculation ht_idx and idx of rate table for
    tx_stats

 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  7 ++++---
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 26 ++++++++++++++------------
 drivers/net/wireless/ath/ath10k/wmi.h         |  3 ++-
 3 files changed, 20 insertions(+), 16 deletions(-)

-- 
1.9.1

