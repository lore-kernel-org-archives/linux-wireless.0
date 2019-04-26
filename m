Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1CBC4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C02205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfDZPtz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:49:55 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21643 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbfDZPtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:55 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367515"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:40 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889763"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:39 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 0/9] wil6210 patches
Date:   Fri, 26 Apr 2019 18:43:28 +0300
Message-Id: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following patches include;
- Various wil6210 bug fixes
- Support handling of multiple section in board file

Ahmad Masri (1):
  wil6210: fix overwriting max_assoc_sta module param

Alexei Avshalom Lazar (1):
  wil6210: fix _desc access in __wil_tx_vring_tso

Dedy Lansky (3):
  wil6210: add printout of platform capabilities
  wil6210: enhancements for descriptor and status ring debugfs
  wil6210: check rx_buff_mgmt before accessing it

Maya Erez (4):
  wil6210: fix spurious interrupts in 3-msi
  wil6210: add support for multiple sections in brd file
  wil6210: fix missed MISC mbox interrupt
  wil6210: remove HALP for Talyn devices

 drivers/net/wireless/ath/wil6210/cfg80211.c   |   4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  70 ++++++++----
 drivers/net/wireless/ath/wil6210/fw.h         |  11 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c     | 148 +++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/interrupt.c  |  67 +++++++-----
 drivers/net/wireless/ath/wil6210/main.c       |  18 +++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |   2 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  25 +++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  10 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  33 ++++--
 drivers/net/wireless/ath/wil6210/wmi.c        |  14 +--
 12 files changed, 275 insertions(+), 129 deletions(-)

-- 
1.9.1

