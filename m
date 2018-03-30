Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbeC3DOJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 23:14:09 -0400
From: Carl Huang <cjhuang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ath10k: support MAC address randomization in scan
Date: Fri, 30 Mar 2018 11:13:58 +0800
Message-Id: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org> (sfid-20180330_051415_686180_1CB872C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The feature MAC address randomization depends on the firmware
capability, if the firmware indicates WMI_SERVICE_SPOOF_MAC_SUPPORT
service the host driver will report it to upper layer. The service
bit is above the 128 bit limit so a new service check macro is needed.

Carl Huang (2):
  ath10k: Add WMI_SERVICE_AVAILABLE_EVENT support
  ath10k: support MAC address randomization in scan

 drivers/net/wireless/ath/ath10k/mac.c     |  17 ++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  46 ++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  63 ++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 357 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c     |  26 ++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  18 +-
 6 files changed, 520 insertions(+), 7 deletions(-)

-- 
2.7.4
