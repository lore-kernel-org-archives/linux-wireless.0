Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F28AC3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2429322CF7
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 11:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LmWLAMZI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LmWLAMZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfHTLzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:55:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTLzZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 07:55:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B99CF608FF; Tue, 20 Aug 2019 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566302124;
        bh=Y2rU2d6q6MWwJstvhzKxo56Z5gKFJ7BHKuyQbjStoII=;
        h=From:To:Cc:Subject:Date:From;
        b=LmWLAMZIVj7Dl6FMi8IfPXgRyiE8H2PkkaOS9Knvzk+3R3B+FZvUl+Q+RrwPDqzHW
         aj5/+Cxh1Pg1aggT140lu9bhlDimRUKCzat5XfqBX0b0L8U1IN3bpJCrcFbVJsxlQS
         waylKDnKbolv4kxi455t2oj8Kc1O7/1YGn9yn0Yw=
Received: from wgong-HP-Z240-SFF-Workstation.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A227608CC;
        Tue, 20 Aug 2019 11:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566302124;
        bh=Y2rU2d6q6MWwJstvhzKxo56Z5gKFJ7BHKuyQbjStoII=;
        h=From:To:Cc:Subject:Date:From;
        b=LmWLAMZIVj7Dl6FMi8IfPXgRyiE8H2PkkaOS9Knvzk+3R3B+FZvUl+Q+RrwPDqzHW
         aj5/+Cxh1Pg1aggT140lu9bhlDimRUKCzat5XfqBX0b0L8U1IN3bpJCrcFbVJsxlQS
         waylKDnKbolv4kxi455t2oj8Kc1O7/1YGn9yn0Yw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A227608CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] ath10k: improve throughout of tcp/udp TX/RX of sdio
Date:   Tue, 20 Aug 2019 19:55:01 +0800
Message-Id: <1566302108-18219-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The bottleneck of throughout on sdio chip is the bus bandwidth, to the
patches are all to increase the use ratio of sdio bus.

                      udp-rx    udp-tx    tcp-rx    tcp-tx
without patches(Mbps)  320        180       170       151
with patches(Mbps)     450        410       400       320

These patches only affect sdio bus chip, explanation is mentioned in each
patch's commit log.

Alagu Sankar (1):
  ath10k: enable RX bundle receive for sdio

Wen Gong (6):
  ath10k: change max RX bundle size from 8 to 32 for sdio
  ath10k: add workqueue for RX path of sdio
  ath10k: disable TX complete indication of htt for sdio
  ath10k: add htt TX bundle for sdio
  ath10k: enable alt data of TX path for sdio
  ath10k: enable napi on RX path for sdio

 drivers/net/wireless/ath/ath10k/core.c   |  36 ++-
 drivers/net/wireless/ath/ath10k/core.h   |   4 +-
 drivers/net/wireless/ath/ath10k/hif.h    |   9 +
 drivers/net/wireless/ath/ath10k/htc.c    | 375 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htc.h    |  37 ++-
 drivers/net/wireless/ath/ath10k/htt.c    |  15 ++
 drivers/net/wireless/ath/ath10k/htt.h    |  21 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  85 ++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  37 ++-
 drivers/net/wireless/ath/ath10k/hw.h     |   2 +-
 drivers/net/wireless/ath/ath10k/sdio.c   | 281 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/sdio.h   |  31 ++-
 12 files changed, 846 insertions(+), 87 deletions(-)

-- 
1.9.1

