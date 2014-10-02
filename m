Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43637 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJBRIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:08:09 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 0/4] ath10k: Add pktlog support
Date: Thu, 2 Oct 2014 22:39:34 +0530
Message-ID: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_190812_948645_C8138DEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the Packet log feature for ath10k.
All tx and rx events and rx descriptor details are
posted to user space by tracepoints.

v2: Addressed review comments and based on discussion with Michal
    dropped tx_msdu_id patch and added tx info changes

Rajkumar Manoharan (4):
  ath10k: Add support to configure pktlog filter
  ath10k: add tracing for ath10k_htt_pktlog
  ath10k: add tracing for rx descriptor
  ath10k: add tracing for tx msdu pktlog event

 drivers/net/wireless/ath/ath10k/core.h   |  2 +
 drivers/net/wireless/ath/ath10k/debug.c  | 80 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h  | 15 +++++-
 drivers/net/wireless/ath/ath10k/htt.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 47 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h     | 35 +++++++++++++
 drivers/net/wireless/ath/ath10k/trace.h  | 89 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c    | 33 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |  6 +++
 9 files changed, 306 insertions(+), 3 deletions(-)

-- 
2.1.1

