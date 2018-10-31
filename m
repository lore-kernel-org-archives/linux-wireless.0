Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F79ECDE47
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B7020685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4B7020685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbeJaRzz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:55 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23737 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbeJaRzz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:55 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418120"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:27 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147920"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:26 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 00/16] wil6210 patches
Date:   Wed, 31 Oct 2018 10:52:08 +0200
Message-Id: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches include various wil6210 fixes.

Ahmad Masri (5):
  wil6210: refactor disconnect flow
  wil6210: notify cqm packet loss on disable_ap_sme
  wil6210: fix debugfs memory access alignment
  wil6210: remove unnecessary alignment code from rx flow
  wil6210: fix freeing of rx buffers in EDMA mode

Alexei Avshalom Lazar (2):
  wil6210: fix reset flow for Talyn-mb
  wil6210: add general initialization/size checks

Dedy Lansky (2):
  wil6210: make sure Rx ring sizes are correlated
  wil6210: add recovery for FW error while in AP mode

Hamad Kadmany (1):
  wil6210: remove fake support for RXHASH

Lior David (2):
  wil6210: fix memory leak in wil_find_tx_bcast_2
  wil6210: fix locking in wmi_call

Maya Erez (4):
  wil6210: increase RX rings and RX buff array size
  wil6210: fix L2 RX status handling
  wil6210: fix RGF_CAF_ICR address for Talyn-MB
  wil6210: ignore HALP ICR if already handled

 drivers/net/wireless/ath/wil6210/cfg80211.c  | 104 +++++++++++-
 drivers/net/wireless/ath/wil6210/debugfs.c   |  17 +-
 drivers/net/wireless/ath/wil6210/interrupt.c |  10 +-
 drivers/net/wireless/ath/wil6210/main.c      | 230 ++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/netdev.c    |   5 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |  14 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c |  92 +++++------
 drivers/net/wireless/ath/wil6210/txrx_edma.h |   4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  22 ++-
 drivers/net/wireless/ath/wil6210/wmi.c       |  56 ++++---
 10 files changed, 386 insertions(+), 168 deletions(-)

-- 
1.9.1

