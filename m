Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC583C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8896920700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfBVOVZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:25 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbfBVOVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:25 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017366"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:22 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285573"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:22 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 00/21] wil6210 patches
Date:   Fri, 22 Feb 2019 16:20:58 +0200
Message-Id: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches include:
- support up to 20 stations in AP mode
- add support for ucode tracing
- various wil6210 fixes

Ahmad Masri (6):
  wil6210: support up to 20 stations in AP mode
  wil6210: accessing 802.3 addresses via utility functions
  wil6210: prevent device memory access while in reset or suspend
  wil6210: check mid is valid
  wil6210: fix report of rx packet checksum in edma mode
  wil6210: add support for ucode tracing

Alexei Avshalom Lazar (2):
  wil6210: check null pointer in _wil_cfg80211_merge_extra_ies
  wil6210: align to latest auto generated wmi.h

Dedy Lansky (4):
  wil6210: add option to drop Tx packets when Tx ring is full
  wil6210: fix invalid sta statistics update
  wil6210: use OEM MAC address from OTP
  wil6210: free edma_rx_swtail upon reset

Lior David (1):
  wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext

Maya Erez (8):
  wil6210: remove rtap_include_phy_info module param
  wil6210: ignore HALP ICR if already handled
  wil6210: increase PCP stop command timeout
  wil6210: do not set BIT_USER_SUPPORT_T_POWER_ON_0 in Talyn-MB
  wil6210: update WIL_MCS_MAX to 15
  wil6210: prevent access to RGF_CAF_ICR in Talyn
  wil6210: reset buff id in status message after completion
  wil6210: print error in FW and board files load failures

 drivers/net/wireless/ath/wil6210/cfg80211.c       |  31 ++-
 drivers/net/wireless/ath/wil6210/debugfs.c        |  61 ++++--
 drivers/net/wireless/ath/wil6210/fw_inc.c         |   6 +-
 drivers/net/wireless/ath/wil6210/interrupt.c      |  12 +-
 drivers/net/wireless/ath/wil6210/main.c           |  91 +++++---
 drivers/net/wireless/ath/wil6210/netdev.c         |  10 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |   4 +-
 drivers/net/wireless/ath/wil6210/pm.c             |  35 +--
 drivers/net/wireless/ath/wil6210/rx_reorder.c     |  10 +-
 drivers/net/wireless/ath/wil6210/trace.h          |   3 +-
 drivers/net/wireless/ath/wil6210/txrx.c           | 254 ++++++++++++----------
 drivers/net/wireless/ath/wil6210/txrx.h           |  51 ++++-
 drivers/net/wireless/ath/wil6210/txrx_edma.c      |  85 ++++----
 drivers/net/wireless/ath/wil6210/txrx_edma.h      |  47 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  27 ++-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  18 +-
 drivers/net/wireless/ath/wil6210/wmi.c            | 107 ++++++---
 drivers/net/wireless/ath/wil6210/wmi.h            |  91 +++++++-
 18 files changed, 641 insertions(+), 302 deletions(-)

-- 
1.9.1

