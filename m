Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeHFPVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 11:21:34 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] Add support to dump tx stats histogram
Date: Mon,  6 Aug 2018 18:43:39 +0530
Message-Id: <1533561223-342-1-git-send-email-akolli@codeaurora.org> (sfid-20180806_151235_084674_0FA0300F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support to dump per station tx stats histogram.

These stats can be enabled through ath10k/enable_extd_tx_stats debugfs entry,
enabling this may impact in cpu usage and throughput.

ath10k/enable_extd_tx_stats is disabled by default.

Tx histogram has Per station tx stats which includes,
 - pkts/bytes transmitted at all possible rates(mcs/nss/bw/gi).
 - ACK fails count
 - ampdu bytes/pkts transmitted at all possible rates(mcs/nss/bw/gi).
 - BA fails count
 - tx duration

Tested on QCA9984/QCA4019/QCA988x
Firmware: 10.4-3.5.3-00057
	  10.2.4-1.0-00037

Example output format:
# cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/stations/8c\:
fd\:f0\:0a\:8c\:14/tx_stats

succ_pkts
 VHT MCS packets
  0 0 0 0 0 138 26 18 23 38747 
 HT MCS packets
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW packets (20,40,80,160 MHz)
  41 337 38574 0
 NSS packets (1x1,2x2,3x3,4x4)
  38952 0 0 0
 GI packets (LGI,SGI)
  38 38914
 legacy rate packets (1,2 ... Mbps)
  0 0 0 0 68 0 0 0 0 0 0 0 
succ_bytes
 VHT MCS bytes
  0 0 0 0 0 16407 3288 2360 2703 4651892 
 HT MCS bytes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW bytes (20,40,80,160 MHz)
  5163 40962 4630525 0
 NSS bytes (1x1,2x2,3x3,4x4)
  4676650 0 0 0
 GI bytes (LGI,SGI)
  4471 4672179
 legacy rate bytes (1,2 ... Mbps)
  0 0 0 0 3270 0 0 0 0 0 0 0 
ampdu_pkts
 VHT MCS packets
  0 0 0 8 20 7872 34 21 33 39730 
 HT MCS packets
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW packets (20,40,80,160 MHz)
  72 567 47079 0
 NSS packets (1x1,2x2,3x3,4x4)
  40035 7683 0 0
 GI packets (LGI,SGI)
  7698 40020
 legacy rate packets (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 

ampdu_bytes
 VHT MCS bytes
  0 0 0 896 2579 941417 4222 2666 3857 4774284 
 HT MCS bytes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW bytes (20,40,80,160 MHz)
  9262 70052 5650607 0
 NSS bytes (1x1,2x2,3x3,4x4)
  4811265 918656 0 0
 GI bytes (LGI,SGI)
  920650 4809271
 legacy rate bytes (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 
fail_pkts
 VHT MCS packets
  0 0 0 0 0 0 0 0 0 0 
 HT MCS packets
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW packets (20,40,80,160 MHz)
  0 0 0 0
 NSS packets (1x1,2x2,3x3,4x4)
  0 0 0 0
 GI packets (LGI,SGI)
  0 0
 legacy rate packets (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 
fail_bytes
 VHT MCS bytes
  0 0 0 0 0 0 0 0 0 0 
 HT MCS bytes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW bytes (20,40,80,160 MHz)
  0 0 0 0
 NSS bytes (1x1,2x2,3x3,4x4)
  0 0 0 0
 GI bytes (LGI,SGI)
  0 0
 legacy rate bytes (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 
retry_pkts
 VHT MCS packets
  0 0 0 8 20 7734 8 3 10 983 
 HT MCS packets
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW packets (20,40,80,160 MHz)
  31 230 8505 0
 NSS packets (1x1,2x2,3x3,4x4)
  1083 7683 0 0
 GI packets (LGI,SGI)
  7660 1106
 legacy rate packets (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 
retry_bytes
 VHT MCS bytes
  0 0 0 896 2579 925010 934 306 1154 122392 
 HT MCS bytes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 BW bytes (20,40,80,160 MHz)
  4099 29090 1020082 0
 NSS bytes (1x1,2x2,3x3,4x4)
  134615 918656 0 0
 GI bytes (LGI,SGI)
  916179 137092
 legacy rate bytes (1,2 ... Mbps)
  0 0 0 0 0 0 0 0 0 0 0 0 
TX duration
 6639098 usecs
BA fails
 8610
ack fails
 0

Anilkumar Kolli (4):
  ath10k: get the legacy rate index to update the txrate
  ath10k: add debugfs entry to enable extended tx stats
  ath10k: add extended per sta tx statistics
  ath10k: add debugfs support to dump per sta tx stats

 drivers/net/wireless/ath/ath10k/core.h        |   32 ++++++
 drivers/net/wireless/ath/ath10k/debug.c       |   62 +++++++++++-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  100 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c      |  133 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/mac.c         |    7 ++
 drivers/net/wireless/ath/ath10k/wmi.h         |   13 ++-
 6 files changed, 328 insertions(+), 19 deletions(-)

-- 
1.7.9.5
