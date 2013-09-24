Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46909 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3IXNJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 09:09:40 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: improve RX performance
Date: Tue, 24 Sep 2013 15:09:13 +0200
Message-ID: <1380028158-861-1-git-send-email-michal.kazior@tieto.com> (sfid-20130924_150944_169850_28AFFB53)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset gives clear RX performance
improvement on AP135. Throughput is at least
doubled (300mbps -> 600mbps, UDP RX, 2x2).

This contains a workaround for
retransmission/duplication recovery.

There's a pending patch for mac80211 that will
allow proper individiual A-MSDU subframe
reporting.

Changes since RFC:
 * comments fixes (Kalle)
 * one patch extracted/split (Kalle)
 * commit message adjustments


Michal Kazior (5):
  ath10k: report A-MSDU subframes individually
  ath10k: document decap modes
  ath10k: cleanup RX decap handling
  ath10k: fix Native Wifi decap mode RX
  ath10k: align RX frames properly

 drivers/net/wireless/ath/ath10k/htt_rx.c  |  273 ++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/hw.h      |    6 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |   24 ++-
 drivers/net/wireless/ath/ath10k/txrx.c    |    2 +
 4 files changed, 158 insertions(+), 147 deletions(-)

-- 
1.7.9.5

