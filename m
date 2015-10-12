Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24559 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbbJLM5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:57:44 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 0/7] ath10k: add copy engine fast path support
Date: Mon, 12 Oct 2015 18:26:59 +0530
Message-ID: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145748_127105_6B998150)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below patchset adds fast path support for uplink traffic by bypassing
HTC layer processing. This is enabled by making use of unused copy
engine 5 to receive HTT messages directly from HIF layer. From initial
validation in VHT80/5G mode TCP UL is improved to 900Mbps from ~840Mbps
in conducted test.

-Rajkumar

v2:
 * fix invalid dma memory access (ATH10K_SKB_RXCB is used instead of
   ATH10K_SKB_CB in htt_tx_cb)
 * register either send_cb or recv_cb callback not both for
   appropriate CE.
 * Process CE 4 send completion first before processing rx
 
Rajkumar Manoharan (7):
  ath10k: export htc tx rx handlers
  ath10k: register per copy engine send completion callbacks
  ath10k: register per copy engine receive callbacks
  ath10k: export htt tx rx handlers
  ath10k: Configure copy engine 5 for HTT messages
  ath10k: remove unused dl_is_polled
  ath10k: remove htc polling for tx completion

 drivers/net/wireless/ath/ath10k/ce.c     |   8 +--
 drivers/net/wireless/ath/ath10k/ce.h     |   7 +-
 drivers/net/wireless/ath/ath10k/hif.h    |  26 +------
 drivers/net/wireless/ath/ath10k/htc.c    |  51 ++-----------
 drivers/net/wireless/ath/ath10k/htc.h    |   4 +-
 drivers/net/wireless/ath/ath10k/htt.h    |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |   6 ++
 drivers/net/wireless/ath/ath10k/pci.c    | 119 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h    |   2 -
 10 files changed, 98 insertions(+), 127 deletions(-)

-- 
2.6.0

