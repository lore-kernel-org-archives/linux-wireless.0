Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56554 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754825AbeBOIrY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:47:24 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 00/13] ***Set4: Add support of WCN3990 bus layer support ***
Date: Thu, 15 Feb 2018 14:17:15 +0530
Message-Id: <1518684435-5288-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_094727_973828_F4D70B35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds support for integrated wcn3990 chipset on
MSM platforms. WCN3990 is 2x2 802.11ac chipset where wlan
subsystem is interfaced over system interconnect.
Wlan fw runs in Q6 DSP. WCN3990 chipset uses 12 copy engine
for host to target and target to host communication. It has
extra 2 copy engine in rx data path and packet log capability
is exposed via new HTC service over dedicated copy engine.
Each CE has dedicated interrupt of rx path and tx completion.

    [CE0] :host->target control and raw streams
    [CE1] :target->host HTT
    [CE2] :target->host WMI
    [CE3] :host->target WMI
    [CE4] :host->target HTT
    [CE5] :reserved
    [CE6] :Target autonomous HIF_memcpy
    [CE7] :reserved
    [CE8] :reserved
    [CE9] :target->host HTT
    [CE10] :target->host HTT
    [CE11] :target -> host PKTLOG



Govind Singh (11):
  ath10k: platform driver for WCN3990 SNOC WLAN module
  ath10k: add resource init and deinit for WCN3990
  ath10k: Add hif start/stop methods for wcn3990 snoc layer
  ath10k: Add HTC services for WCN3990
  ath10k: Map HTC services to tx/rx pipes for wcn3990
  ath10k: Add hif power-up/power-down methods
  ath10k: Add hif tx methods for wcn3990
  ath10k: Add hif rx methods for wcn3990
  ath10k: Modify hif tx paddr to dma_addr_t type
  ath10k: Vote for hardware resources for WCN3990
  dt: bindings: add bindings for wcn3990 wifi block

Rakesh Pillai (2):
  ath10k: Add support to get target info from hif ops
  ath10k: Check all CE for data if irq summary is not retained

 .../bindings/net/wireless/qcom,ath10k.txt          |   35 +
 drivers/net/wireless/ath/ath10k/Kconfig            |    8 +
 drivers/net/wireless/ath/ath10k/Makefile           |    4 +
 drivers/net/wireless/ath/ath10k/ce.h               |   10 +-
 drivers/net/wireless/ath/ath10k/core.c             |   21 +
 drivers/net/wireless/ath/ath10k/hif.h              |   15 +-
 drivers/net/wireless/ath/ath10k/htc.c              |    6 +
 drivers/net/wireless/ath/ath10k/htc.h              |    4 +
 drivers/net/wireless/ath/ath10k/hw.h               |    3 +
 drivers/net/wireless/ath/ath10k/pci.c              |    8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             | 1450 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h             |   95 ++
 12 files changed, 1651 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.c
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.h

-- 
1.9.1
