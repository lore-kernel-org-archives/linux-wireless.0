Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1I0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 04:26:42 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 0/2] ath10k: Enable pktlog for WCN3990 chipset
Date: Tue, 28 Aug 2018 10:06:40 +0530
Message-Id: <20180828043642.14890-1-govinds@codeaurora.org> (sfid-20180828_063706_454497_290C85DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 target uses separate htc service(ATH10K_HTC_SVC_ID_HTT_LOG_MSG)
for pktlog. Add pktlog service request and support for pktlog
rx path handling.

Tested HW: WCN3990 and QCA6174.
Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1,
           WLAN.RM.4.4.1-00109-QCARMSWPZ-1

Govind Singh (2):
  ath10k: Introduce CE_ATTR_POLL attribute for polling pipe
  ath10k: Enable pktlog for WCN3990 target

 drivers/net/wireless/ath/ath10k/ce.c   | 18 ++++++--
 drivers/net/wireless/ath/ath10k/ce.h   | 11 +++--
 drivers/net/wireless/ath/ath10k/htc.c  | 63 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/pci.c  |  4 +-
 drivers/net/wireless/ath/ath10k/snoc.c | 13 +++++-
 5 files changed, 96 insertions(+), 13 deletions(-)

-- 
2.17.0
