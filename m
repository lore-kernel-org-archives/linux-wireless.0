Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:55666 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3GRGdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 02:33:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: fixes
Date: Thu, 18 Jul 2013 08:33:10 +0200
Message-ID: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com> (sfid-20130718_083326_600090_9457468A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are some fixes for ath10k. The rts threshold
patch addresses my mistake in commit
9aeb6fe53d1f0d6e58658484ce9ad7b59f0ef16b which
caused rts to be always enabled causing throughput
issues in some cases.


Michal Kazior (3):
  ath10k: prevent HTC from being used after stopping
  ath10k: fix memleak in mac setup
  ath10k: fix rts/fragmentation threshold setup

 drivers/net/wireless/ath/ath10k/htc.c |   28 ++++++------
 drivers/net/wireless/ath/ath10k/htc.h |    4 +-
 drivers/net/wireless/ath/ath10k/mac.c |   80 ++++++++++++++++++---------------
 3 files changed, 58 insertions(+), 54 deletions(-)

-- 
1.7.9.5

