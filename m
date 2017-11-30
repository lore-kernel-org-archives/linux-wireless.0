Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:14342 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbdK3M5r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 07:57:47 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 0/2] ath10k: tx stats for 10.2.4 
Date: Thu, 30 Nov 2017 18:28:19 +0530
Message-ID: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20171130_135751_419947_C2EB221A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Add tx stats supoort for QCA988X.
Parse peer stats from pktlog packets and update the tx rate
information per STA.
This way user space can query about transmit rate with iw.

Anilkumar Kolli (2):
  ath10k: move pktlog_filter out of ath10k_debug
  ath10k: add per peer tx stats support for 10.2.4

 drivers/net/wireless/ath/ath10k/core.h   |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c  |   16 ++++----
 drivers/net/wireless/ath/ath10k/debug.h  |   18 ++++++++-
 drivers/net/wireless/ath/ath10k/htt.h    |   17 +++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   60 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c    |   10 +++++
 6 files changed, 113 insertions(+), 10 deletions(-)

-- 
1.7.9.5
