Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbeH3G3n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 02:29:43 -0400
From: Carl Huang <cjhuang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] ath10k: download firmware via diag ce for qca6174 and qca9377
Date: Thu, 30 Aug 2018 10:29:39 +0800
Message-Id: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org> (sfid-20180830_042957_154027_0C3E3C35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Downloading firmware via diag ce can greatly reduce the downloading
time to ~40ms from ~500ms for a 700k bytes firmware.

Carl Huang (3):
  ath10k: optimize pci diag mem read & write operations
  ath10k: support to access target space below 1M for qca6174 and
    qca9377
  ath10k: download firmware via diag Copy Engine for QCA6174 and
    QCA9377.

 drivers/net/wireless/ath/ath10k/bmi.c  |  23 ++++
 drivers/net/wireless/ath/ath10k/bmi.h  |  31 ++++++
 drivers/net/wireless/ath/ath10k/core.c |  36 +++++--
 drivers/net/wireless/ath/ath10k/hw.c   | 185 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  19 ++++
 drivers/net/wireless/ath/ath10k/pci.c  |  59 +++++++----
 drivers/net/wireless/ath/ath10k/pci.h  |   3 +-
 7 files changed, 329 insertions(+), 27 deletions(-)

-- 
2.7.4
