Return-Path: <SRS0=3v18=Y4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108F0CA9EA0
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Nov 2019 12:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E2A217F5
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Nov 2019 12:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EfrvT4HZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j2xzjm0Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfKDMJq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:09:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKDMJq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Nov 2019 07:09:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1694E60AD0; Mon,  4 Nov 2019 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572869385;
        bh=TB4qTSppkKqHCkkwbgsFfBaUYqjEXor2+8Hu0Nhn5YQ=;
        h=From:To:Cc:Subject:Date:From;
        b=EfrvT4HZLPUUEj3h/Bpw57Q4HCwg8BGlKgAAMsRe0uvXyk/Z79AtmkjnWVjXx+Z4Z
         TfjBHrnFjN0JdvkRnvQmx0098oHwCHVUXJCJXVTXkE4SfUX3zzhLlZCMDowfhROoiH
         Lbip6+MUpH6Epp9MvrQuY+WwahCbd/EV1AZtnR+s=
Received: from murugana-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: murugana@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 177C7603A3;
        Mon,  4 Nov 2019 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572869384;
        bh=TB4qTSppkKqHCkkwbgsFfBaUYqjEXor2+8Hu0Nhn5YQ=;
        h=From:To:Cc:Subject:Date:From;
        b=j2xzjm0ZO/IYimHOE4/n8veF8wolfiPWEZE8fwj3S+BRsv1cB5Q0fQcAA3M0Vo2Wq
         jIB+Z4YSmQgHrCLtGB9ycgyxeumA6TBpg2mAFONCbhuPtx1Lto2FwZf5FIBpWoqSeN
         R1iXu/rhMHSip1LYyA61j3dyJ5D0V58V9qf+PcOA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 177C7603A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=murugana@codeaurora.org
From:   Sathishkumar Muruganandam <murugana@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: [PATCH v2 0/2] add Wide Band Scan support
Date:   Mon,  4 Nov 2019 17:39:32 +0530
Message-Id: <1572869374-9635-1-git-send-email-murugana@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wide Band Scan allows to perform off-channel scan on requested channel/
frequency along with corresponding phy mode/bandwidth (40Mhz, 80Mhz).

Below are use cases of Wide Band Scan,

1. In case of phy running both AP and monitor vifs, wide band scan on
   a different channel along with phymode (40Mhz, 80Mhz) captures
   those off-channel data frames to monitor vif.

2. Doing wide band scan instead of normal 20Mhz scan before spectral
   dump, allows to fetch FFT reports for the complete requested
   bandwidth (40Mhz, 80Mhz).

Sathishkumar Muruganandam (2):
  nl80211: add Wide Band Scan support

 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  7 +++++
 net/mac80211/scan.c          |  2 ++
 net/wireless/nl80211.c       | 68 ++++++++++++++++++++++++++++----------------
 4 files changed, 55 insertions(+), 24 deletions(-)

  ath11k: add Wide Band Scan support

 drivers/net/wireless/ath/ath11k/mac.c |  41 ++++++++++--
 drivers/net/wireless/ath/ath11k/wmi.c | 115 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/wmi.h |  34 +++++++++-
 3 files changed, 175 insertions(+), 15 deletions(-)

-- 
2.7.4
