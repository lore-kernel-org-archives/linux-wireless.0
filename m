Return-Path: <SRS0=q9IJ=AJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA001C433E0
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Jun 2020 17:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 975C020674
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Jun 2020 17:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="gFifh7DZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgF1RCJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Jun 2020 13:02:09 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:39531 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgF1RCJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jun 2020 13:02:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593363728; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=7zLjqLoeGnEBuh4LDTbBmiP3YIu2iUduXQBK1dgClbs=; b=gFifh7DZM2PZttFEpn2mHn3p1Z/9Tt0S4UBHwX+ugTQ1yJ/3m8mDQu43FXHpi2FAyJY9I6Ub
 ojASq/mq6k5x6BigDCzkYnbUtP3VDjsHMcZjbmEHMEH3iuc97W/NJfU4mELSy7BkD04W62ys
 XXz7TQmpYsUkB5A7IMXJaVJBMKk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5ef8cd10567385e8e71d28f5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 28 Jun 2020 17:02:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8E2BEC433C6; Sun, 28 Jun 2020 17:02:07 +0000 (UTC)
Received: from tamizhr-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A3B9C433C8;
        Sun, 28 Jun 2020 17:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A3B9C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh Chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh Chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/4] ath10k: Add support for TID specific configuration
Date:   Sun, 28 Jun 2020 22:31:54 +0530
Message-Id: <1593363718-5148-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add TID specific configuration for noack, retry count, aggregation, Tx rate
and RTS_CTS control. Here if noack is enabled for the TID then aggregation
should be disabled and Tx rate should be and retry count will be 0.
Also add support for reset TID configuration.

Tamizh Chelvam (4):
  ath10k: Add wmi command support for station specific TID config
  ath10k: Move rate mask validation function up in the file
  ath10k: Add new api to support TID specific configuration
  ath10k: Add new api to support reset TID config

 drivers/net/wireless/ath/ath10k/core.c    |   4 +
 drivers/net/wireless/ath/ath10k/core.h    |  20 +
 drivers/net/wireless/ath/ath10k/mac.c     | 839 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/txrx.c    |  11 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  19 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  35 ++
 drivers/net/wireless/ath/ath10k/wmi.h     |  72 +++
 7 files changed, 907 insertions(+), 93 deletions(-)

-- 
1.9.1

