Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37041 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdLUJBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 04:01:15 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 00/10] *** HTT/CE changes for WCN3990 ***
Date: Thu, 21 Dec 2017 14:30:49 +0530
Message-Id: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com> (sfid-20171221_100120_383362_D4D7D120)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds HTT/CE layer support for WCN3990 target.
WCN3990 is the integrated chipset using System NOC
interconnect. This chipset uses 37 bit addressing mode,
due to this 64bit rx ring desc, tx desc and ce desc
support is added to enable extended addressing range.

These changes are validated on QCA6174 and WCN3990 target.

Govind Singh (9):
  ath10k: Update rx descriptor for WCN3990 target
  ath10k: Add support for 64 bit HTT in-order indication msg
  ath10k: Add support for 64 bit htt rx ring cfg
  ath10k: Add support for 64 bit HTT frag descriptor
  ath10k: Add support for htt_data_tx_desc_64 descriptor
  ath10k: Add hw param for rx ring size support
  ath10k: Add paddrs_ring_64 support for 64bit target
  ath10k: Use dma_addr_t for ce buffers to support 64bit target
  ath10k: Add support for 64 bit ce descriptor

Rakesh Pillai (1):
  ath10k: Add hw param for 64-bit address support

 drivers/net/wireless/ath/ath10k/ce.c      | 634 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/ce.h      |  58 ++-
 drivers/net/wireless/ath/ath10k/core.c    |  26 ++
 drivers/net/wireless/ath/ath10k/htt.c     |   7 +-
 drivers/net/wireless/ath/ath10k/htt.h     | 142 ++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 182 +++++++--
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 598 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/hw.h      |   6 +
 drivers/net/wireless/ath/ath10k/mac.c     |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c     |  10 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |  50 +++
 11 files changed, 1507 insertions(+), 208 deletions(-)

-- 
1.9.1
