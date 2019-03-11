Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D980C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D807420657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R7YtO2HF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R7YtO2HF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfCKPxb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:53:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbfCKPxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:53:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 89E0960159; Mon, 11 Mar 2019 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319610;
        bh=VWHmbxzOYvfXTexuCw+gl/H79GvqwSj+skytSeNo1fI=;
        h=From:To:Cc:Subject:Date:From;
        b=R7YtO2HFDCdPB5hBpopxoRWCvO8IpicmbxROfAi5GkJ5AsG5UHG6CzwtaTT7NdoHa
         1gbq5F99xoGc7e3jp84YChNSCe4GAU4shhQH5VtTA3iP29aliibg/FG6Nc0DGwvRs+
         C3GNj08/+mXz3EaJGJ8d+MZ+gQl3lIn93VZMoitU=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9A016016D;
        Mon, 11 Mar 2019 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319610;
        bh=VWHmbxzOYvfXTexuCw+gl/H79GvqwSj+skytSeNo1fI=;
        h=From:To:Cc:Subject:Date:From;
        b=R7YtO2HFDCdPB5hBpopxoRWCvO8IpicmbxROfAi5GkJ5AsG5UHG6CzwtaTT7NdoHa
         1gbq5F99xoGc7e3jp84YChNSCe4GAU4shhQH5VtTA3iP29aliibg/FG6Nc0DGwvRs+
         C3GNj08/+mXz3EaJGJ8d+MZ+gQl3lIn93VZMoitU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C9A016016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 0/2] Fix tx stats inconsistencies
Date:   Mon, 11 Mar 2019 21:23:20 +0530
Message-Id: <1552319602-17795-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The rate table indexes and the NSS values are
incorrect, causing the tx stats to be displayed
incorrectly.

This patchset fix these issues in the tx stats
displayed via debugfs.

Rakesh Pillai (2):
  ath10k: Fix rate table updation in tx stats
  ath10k: Fix NSS tx stats for legacy rates

 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.7.4

