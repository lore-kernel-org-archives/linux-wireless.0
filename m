Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23418 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbFPFxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:53:49 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 0/8] add beacon and htt msg support for 10.4 firmware
Date: Tue, 16 Jun 2015 11:23:07 +0530
Message-ID: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_075353_376731_4339F15A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the continuation of earlier patch set posted for adding 10.4 wmi support.
This patch series covers following items w.r.t 10.4 firmware,

        - Enhance existing swba event handler to handle variable size tim bitmap
          and add support to handle 10.4 swba event.
        - Enable pdev, vdev, peer related wmi operations like create, delete, etc.
        - Includes scan support.
        - Add 10.4 specific htt msg.
        - Advertise 10.4 iface combination to mac80211.
        - Adjust max ss and initialize continuous frag descriptor memory

Raja Mani (8):
  ath10k: enhance swba event handler to adapt different size tim bitmap
  ath10k: handle 10.4 firmware wmi swba event
  ath10k: enable vdev and peer related operations for 10.4 fw
  ath10k: add scan support for 10.4 fw
  ath10k: add 10.4 fw specific htt msg definitions
  ath10k: advertise 10.4 fw ap and sta iface combination to mac80211
  ath10k: set max spatial stream to 4 for 10.4 fw
  ath10k: configure frag desc memory to target for qca99X0

 drivers/net/wireless/ath/ath10k/core.c    |   8 ++
 drivers/net/wireless/ath/ath10k/core.h    |  11 +-
 drivers/net/wireless/ath/ath10k/htt.c     |  39 ++++++
 drivers/net/wireless/ath/ath10k/htt.h     |  41 ++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   3 +
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  76 ++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |   2 +
 drivers/net/wireless/ath/ath10k/mac.c     |  30 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  18 ++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 213 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h     |  68 +++++++++-
 11 files changed, 486 insertions(+), 23 deletions(-)

-- 
1.8.1.2

