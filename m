Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17679 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:52:49 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/9] ath10k: improve throughput performance
Date: Tue, 22 Mar 2016 17:22:10 +0530
Message-ID: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125252_651901_4CD5BB47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

In order to reuse HTT Rx descriptor (copy engine 5), HTT response
processing should be decoupled from txrx data processing. This change also
helps to reduce rx ring lock contention. As txrx tasklet's work load is
reduced, rx replenish task can be combined with txrx_task. Refilling
complete rx ring from txrx tasket is affecting UDP UL traffic in AP135
platform. Hence existing refill threshold is updated to meet peak
throughput in both AP135 and AP148 platforms. Instead of tasklet existing
refill timer is used to reschedule replenish work at an interval of 5 ms
incase of more deficit.

This series are experimented in both AP148(QCA99x0) & IPQ4019 platforms.
Below are consolidated report alongwith CPU usage. Thanks Tamizh for helping 
to verify the changes.

        IPQ4019(TOT)  IPQ4019(+rework)   AP148(TOT)     AP148(+rework)
        ===========   ===============    ==========     =============
TCP DL   639 (40%)       646 (42%)       1134 (71%)      1134 (71%)
TCP UL   661 (31%)       663 (30%)       1244 (71%)      1270 (72%)
UDP DL   670 (50%)       682 (49%)       1240 (73%)      1244 (75%)

        AP135 (OpenWrt TOT)     AP135 (+changes)
        ==================      ===============

TCP DL          603             620
TCP UL          430             428
UDP DL          758             803
UDP UL          420             450

-Rajkumar

Rajkumar Manoharan (9):
  ath10k: speedup htt rx descriptor processing for tx completion
  ath10k: copy tx fetch indication message
  ath10k: remove unused fw_desc processing
  ath10k: cleanup amsdu processing for rx indication
  ath10k: speedup htt rx descriptor processing for rx_ind
  ath10k: register ath10k_htt_htc_t2h_msg_handler
  ath10k: cleanup copy engine receive next completion
  ath10k: reuse copy engine 5 (htt rx) descriptors
  ath10k: combine txrx and replenish task

 drivers/net/wireless/ath/ath10k/ce.c     |  44 ++---
 drivers/net/wireless/ath/ath10k/ce.h     |  13 +-
 drivers/net/wireless/ath/ath10k/htt.c    |   2 +-
 drivers/net/wireless/ath/ath10k/htt.h    |  25 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 301 ++++++++++++-------------------
 drivers/net/wireless/ath/ath10k/htt_tx.c |  14 +-
 drivers/net/wireless/ath/ath10k/pci.c    | 106 ++++++++---
 drivers/net/wireless/ath/ath10k/txrx.c   |  12 +-
 8 files changed, 260 insertions(+), 257 deletions(-)

-- 
2.7.4

