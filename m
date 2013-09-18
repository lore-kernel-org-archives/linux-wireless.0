Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46998 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3IRMna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:43:30 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: tx performance patches
Date: Wed, 18 Sep 2013 14:43:17 +0200
Message-ID: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com> (sfid-20130918_144333_487478_A6277BA2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset reduces CPU load and improves
improves TX performance on AP135 by additional
30mbps (give or take; 560mbps -> 590mbps), at
least on my testbed.


Michal Kazior (5):
  ath10k: use num_pending_tx instead of msdu id bitmap
  ath10k: avoid needless memset on TX path
  ath10k: decouple HTT TX completions
  ath10k: cleanup HTT TX functions
  ath10k: use msdu headroom to store txfrag

 drivers/net/wireless/ath/ath10k/core.h   |   12 +-
 drivers/net/wireless/ath/ath10k/htc.c    |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  249 ++++++++++++------------------
 drivers/net/wireless/ath/ath10k/mac.c    |    9 +-
 drivers/net/wireless/ath/ath10k/txrx.c   |   65 +++-----
 drivers/net/wireless/ath/ath10k/txrx.h   |    5 +-
 7 files changed, 131 insertions(+), 215 deletions(-)

-- 
1.7.9.5

