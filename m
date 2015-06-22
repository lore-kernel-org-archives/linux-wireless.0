Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbFVOwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:52:50 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 0/8] add beacon and htt msg support for 10.4 firmware
Date: Mon, 22 Jun 2015 20:22:19 +0530
Message-ID: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_165254_043972_7E5863F6)
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

v2 changes:
       - rebased on top of "introduce wmi support for qca99x0" patch series.
       - updated htt msg definitions as per stable 10.4 firmware.
       - synced scan related info as per stable 10.4 firmware.

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
 drivers/net/wireless/ath/ath10k/htt.c     |  45 ++++++
 drivers/net/wireless/ath/ath10k/htt.h     |  47 +++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   4 +
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  76 ++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |   2 +
 drivers/net/wireless/ath/ath10k/mac.c     |  30 ++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  18 ++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 220 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h     |  90 ++++++++++--
 11 files changed, 519 insertions(+), 32 deletions(-)

-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
