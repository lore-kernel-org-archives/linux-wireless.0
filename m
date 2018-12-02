Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D266C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28DAD2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28DAD2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbeLBJom (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 04:44:42 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:60218 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbeLBJom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 04:44:42 -0500
X-IronPort-AV: E=Sophos;i="5.56,306,1539640800"; 
   d="scan'208";a="1585236"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 02 Dec 2018 10:43:40 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9094"; a="6502868"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 02 Dec 2018 10:43:40 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 00/12] wil6210 patches
Date:   Sun,  2 Dec 2018 11:43:25 +0200
Message-Id: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches include:
- Use platform specific configuration instead of wil6210 module parameters
- Various wil6210 fixes.

Ahmad Masri (5):
  wil6210: support ndo_select_queue in net_device_ops
  wil6210: add support for AC queues per station
  wil6210: support up to 20 stations in AP mode
  wil6210: accessing 802.3 addresses via utility functions
  wil6210: prevent device memory access while in reset or suspend

Alexei Avshalom Lazar (2):
  wil6210: check null pointer in _wil_cfg80211_merge_extra_ies
  wil6210: align to latest auto generated wmi.h

Dedy Lansky (2):
  wil6210: add option to drop Tx packets when tx ring is full
  wil6210: fix invalid sta statistics update

Maya Erez (3):
  wil6210: remove rtap_include_phy_info module param
  wil6210: use platform specific configuration
  wil6210: ignore HALP ICR if already handled

 drivers/net/wireless/ath/wil6210/cfg80211.c       |  41 ++-
 drivers/net/wireless/ath/wil6210/debugfs.c        |  46 ++-
 drivers/net/wireless/ath/wil6210/interrupt.c      |  10 +-
 drivers/net/wireless/ath/wil6210/main.c           | 160 +++++----
 drivers/net/wireless/ath/wil6210/netdev.c         |  75 +++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |  31 +-
 drivers/net/wireless/ath/wil6210/pm.c             |  29 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c     |   8 +-
 drivers/net/wireless/ath/wil6210/trace.h          |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c           | 405 +++++++++++++++-------
 drivers/net/wireless/ath/wil6210/txrx.h           |  49 ++-
 drivers/net/wireless/ath/wil6210/txrx_edma.c      |  12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  68 ++--
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  16 +-
 drivers/net/wireless/ath/wil6210/wil_platform.h   |  28 ++
 drivers/net/wireless/ath/wil6210/wmi.c            | 109 ++++--
 drivers/net/wireless/ath/wil6210/wmi.h            |  48 ++-
 17 files changed, 793 insertions(+), 344 deletions(-)

-- 
1.9.1

