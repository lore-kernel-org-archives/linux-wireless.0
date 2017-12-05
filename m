Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55650 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752811AbdLENal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 08:30:41 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCHv2 0/3] ath10k: tx stats for 10.2.4 
Date: Tue, 5 Dec 2017 19:01:22 +0530
Message-ID: <1512480685-28471-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20171205_143109_609538_940FC7D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Add tx stats supoort for QCA988X.
Parse peer stats from pktlog packets and update the tx rate
information per STA.
This way user space can query about transmit rate with iw.

V2:
  - Added  patch ath10k: remove MAC80211_DEBUGFS dependency on ath10k_sta_statistics
  - No other changes
 
Anilkumar Kolli (3):
  ath10k: remove MAC80211_DEBUGFS dependency on ath10k_sta_statistics
  ath10k: move pktlog_filter out of ath10k_debug
  ath10k: add per peer tx stats support for 10.2.4

 drivers/net/wireless/ath/ath10k/core.h        |    4 +-
 drivers/net/wireless/ath/ath10k/debug.c       |   16 +++----
 drivers/net/wireless/ath/ath10k/debug.h       |   21 +++++++--
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   27 -----------
 drivers/net/wireless/ath/ath10k/htt.h         |   17 +++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c      |   60 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |   40 ++++++++++++++++-
 7 files changed, 143 insertions(+), 42 deletions(-)

-- 
1.7.9.5
