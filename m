Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BECC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 329262073D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nxm2OTtd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W2fvMfT+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfBFMOq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:14:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:14:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00811607F4; Wed,  6 Feb 2019 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455285;
        bh=xIZG6tB6lwjd99zst8xlGgoVSpvs2WMWCOcW2tQLEzw=;
        h=From:To:Cc:Subject:Date:From;
        b=nxm2OTtdcngPbQCgKXqULItTGw4hokE2s7dhZaeJEeCRDfYZWdfUCM5ZDft9WbRC+
         KnPsUBrRee9DtA5eUTzkor4/RBbtuYnhgiTa8LF/CtT0wpafor773MUIFJKC3bpun1
         llGoS2vqJInl3gfZA+VRPM7wvWWxyFZO9TT/d+kY=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7809C60734;
        Wed,  6 Feb 2019 12:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455284;
        bh=xIZG6tB6lwjd99zst8xlGgoVSpvs2WMWCOcW2tQLEzw=;
        h=From:To:Cc:Subject:Date:From;
        b=W2fvMfT+Louu+Cwn2pFXLxPcAdH5GQ5Lnpmo4wug0YIw1kN8xyIU4Ri14lmcB5H0u
         Y6ga8WSyPFFHOnEmPqFzgRZVTa5w/b2eWM3cbz5TjIX5VfvK1bgnZHs7cwqTDxDp2D
         xbnKf4+ZbTlR6hMyzqTGYp7FDiZ1JrUI3XObqFcg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7809C60734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 0/3] Add support for suspend/resume and WOW for WCN3990 chipset
Date:   Wed,  6 Feb 2019 17:44:30 +0530
Message-Id: <20190206121433.11606-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series adds support for driver suspend/resume and wake over wlan support
for WCN3990 chipset. CE2 is configured as wakeup source before driver suspend
and FW can wake up application processor on Magic packet/Deauth/AP lost.

Changes since v2:
  * Removed BUS TYPE check and introduced bus param at struct ath10k level
    for scalability.

Changes since v1:
  * dropped ath10k: configure the vdev listen interval before wow suspend patch
    from the series. This can be send later after refactoring/tuning.
  * updated commit text in ath10k: Disable interface pause wow config for
    integrated chipset patch.


Govind Singh (3):
  ath10k: Enable bus layer suspend/resume for WCN3990
  ath10k: Disable interface pause wow config for integrated chipset
  ath10k: Request credit report if flow control enabled on ep

 drivers/net/wireless/ath/ath10k/core.c     |  5 ++-
 drivers/net/wireless/ath/ath10k/core.h     |  2 +
 drivers/net/wireless/ath/ath10k/coredump.c |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c    |  4 +-
 drivers/net/wireless/ath/ath10k/htc.c      |  9 +++--
 drivers/net/wireless/ath/ath10k/htt_rx.c   | 10 ++---
 drivers/net/wireless/ath/ath10k/htt_tx.c   |  6 +--
 drivers/net/wireless/ath/ath10k/pci.c      |  3 +-
 drivers/net/wireless/ath/ath10k/snoc.c     | 45 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c     |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  |  7 ++++
 12 files changed, 78 insertions(+), 19 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

