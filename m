Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D31C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AE68206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o0fFlGcu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o0fFlGcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfDZGlR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:41:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDZGlR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 02:41:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CB11B60736; Fri, 26 Apr 2019 06:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260876;
        bh=YxM8a2Axn5bd3t8bulDvrmgrLmF4s7wqtqrZlsznt8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=o0fFlGcuoaO3rwWYUC7zSf4xhgQAVs/d23tEWHb0CXGlctHQS7jflvEfxxaOFZUJH
         duLgT2fbRo4mow5yT43reuDjX0ofPkyaj7CJEeu+pV/8Nxkk8fdb2hb+dmtmu3UJr4
         3wTe+XSw4HbrVryTMlZJgCVtPGf0VqDvxCujUeME=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A42EC602F5;
        Fri, 26 Apr 2019 06:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260876;
        bh=YxM8a2Axn5bd3t8bulDvrmgrLmF4s7wqtqrZlsznt8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=o0fFlGcuoaO3rwWYUC7zSf4xhgQAVs/d23tEWHb0CXGlctHQS7jflvEfxxaOFZUJH
         duLgT2fbRo4mow5yT43reuDjX0ofPkyaj7CJEeu+pV/8Nxkk8fdb2hb+dmtmu3UJr4
         3wTe+XSw4HbrVryTMlZJgCVtPGf0VqDvxCujUeME=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A42EC602F5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] ath10k: implement PN replay protection for SDIO
Date:   Fri, 26 Apr 2019 09:41:06 +0300
Message-Id: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

HTT High Latency devices (SDIO and USB) need PN replay protection in
host driver, implemented in this patchset. Also support for QCA6174
hw3.2 SDIO devices is enabled as now all the necessary pieces have now
been implemented.

For replay protection of TKIP, CCMP and GCMP
ath10k_htt_rx_pn_check_replay_hl() will check PN to see if the frame
is received before. This is implemented in patch "ath10k: add PN
replay protection for high latency devices"

The replay protection on fragmented MSDU with CCMP and GCMP is done by
ath10k_htt_rx_proc_rx_frag_ind_hl(), implemented in patch "ath10k: add
fragment packet handler for high latency". The fragments will be
reassembled by mac80211 in ieee80211_rx_h_defragment(). Also mac80211
will verify the Michael MIC in ieee80211_rx_h_michael_mic_verify().

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Wen Gong (5):
  ath10k: add struct for high latency PN replay protection
  ath10k: add handler for HTT_T2H_MSG_TYPE_SEC_IND event
  ath10k: add PN replay protection for high latency devices
  ath10k: add fragmentation handler for high latency devices
  ath10k: enable QCA6174 hw3.2 SDIO hardware

 drivers/net/wireless/ath/ath10k/core.c   |  27 +++
 drivers/net/wireless/ath/ath10k/core.h   |   8 +
 drivers/net/wireless/ath/ath10k/htt.h    |  56 ++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 373 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h     |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c   |   2 +-
 6 files changed, 460 insertions(+), 7 deletions(-)

-- 
2.7.4

