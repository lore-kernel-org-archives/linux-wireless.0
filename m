Return-Path: <SRS0=82ey=XA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBB1C3A5A5
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 10:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 537DA22CF5
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 10:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lt1ZZi1Q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lt1ZZi1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbfIEKis (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Sep 2019 06:38:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37674 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfIEKis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Sep 2019 06:38:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EC67D61156; Thu,  5 Sep 2019 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567679926;
        bh=ahDJR09kgY7mmeLd6I+Uh8j9JcbA9RHbYa6BrWd3Efw=;
        h=From:To:Cc:Subject:Date:From;
        b=lt1ZZi1QcatJlr/y3vpei0aJ1Q70vY5T1Mw5ErxBqCUhLzYaJJH8YA67Wpzo4gz9V
         onJpViM/t+02NiQpJLi2WdMzeL4VMg9hTh311TCNVhGTz7fO3tGj9rOkdNS5MTiWHg
         aSVeUce7yYipZhmAOIxatVOx/1i0UqxcCxPU362o=
Received: from wgong-HP-Z240-SFF-Workstation.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CECC36058E;
        Thu,  5 Sep 2019 10:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567679926;
        bh=ahDJR09kgY7mmeLd6I+Uh8j9JcbA9RHbYa6BrWd3Efw=;
        h=From:To:Cc:Subject:Date:From;
        b=lt1ZZi1QcatJlr/y3vpei0aJ1Q70vY5T1Mw5ErxBqCUhLzYaJJH8YA67Wpzo4gz9V
         onJpViM/t+02NiQpJLi2WdMzeL4VMg9hTh311TCNVhGTz7fO3tGj9rOkdNS5MTiWHg
         aSVeUce7yYipZhmAOIxatVOx/1i0UqxcCxPU362o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CECC36058E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v5 0/8] ath10k: improve throughout of tcp/udp TX/RX of sdio
Date:   Thu,  5 Sep 2019 18:38:05 +0800
Message-Id: <1567679893-14029-1-git-send-email-wgong@codeaurora.org>
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
v2: fix incorrect skb tail of rx bundle in ath10k_sdio_mbox_rx_process_packet
v3: change some code style
split fix incorrect skb tail of rx bundle to patch "adjust skb length in ath10k_sdio_mbox_rx_packet"
v4: add err handle in ath10k_sdio_mbox_rx_fetch_bundle
v5: no change

Nicolas Boichat (1):
  ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet
v2: no this patch
v3: new added
v4: change commit log
v5: no change

Wen Gong (6):
  ath10k: change max RX bundle size from 8 to 32 for sdio
v2: change macro HTC_GET_BUNDLE_COUNT
v3: change some code style
v4: add macro ATH10K_HTC_FLAG_BUNDLE_MASK
v5: no change

  ath10k: add workqueue for RX path of sdio
v2: no change
v3: change some code style
v4: no change
v5: no change

  ath10k: disable TX complete indication of htt for sdio
v2: change some code style
v3: change some code style
v4: no change
v5: no change

  ath10k: add htt TX bundle for sdio
v2: no change
v3: change some code style
v4: no change
v5: change ath10k_htc_setup_tx_req to add check bundle_tx
to forbidden init 2 times

  ath10k: enable alt data of TX path for sdio
v2: no change
v3: change some code style
v4: add macro ATH10K_HTC_MSG_READY_EXT_ALT_DATA_MASK
v5: no change

  ath10k: enable napi on RX path for sdio
v2: no change
v3: change some code style
v4: change some code style
v5: move skb_queue_head_init(&ar->htt.rx_indication_head)
from ath10k_htt_connect to ath10k_core_create to forbidden 
init 2 times

 drivers/net/wireless/ath/ath10k/core.c   |  44 +++-
 drivers/net/wireless/ath/ath10k/core.h   |   4 +-
 drivers/net/wireless/ath/ath10k/hif.h    |   9 +
 drivers/net/wireless/ath/ath10k/htc.c    | 378 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htc.h    |  49 +++-
 drivers/net/wireless/ath/ath10k/htt.c    |  13 ++
 drivers/net/wireless/ath/ath10k/htt.h    |  20 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  80 ++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  38 +++-
 drivers/net/wireless/ath/ath10k/hw.h     |   2 +-
 drivers/net/wireless/ath/ath10k/sdio.c   | 281 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/sdio.h   |  31 ++-
 12 files changed, 852 insertions(+), 97 deletions(-)

-- 
1.9.1

