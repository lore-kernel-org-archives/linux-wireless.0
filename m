Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbeITRp4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:45:56 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [RFCv3 0/2] ath10k: Add support to update tx rate to mac80211
Date: Thu, 20 Sep 2018 17:35:14 +0530
Message-Id: <1537445116-10780-1-git-send-email-akolli@codeaurora.org> (sfid-20180920_140250_443934_EB183848)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx rate was updated to nl80211/user using sta_statistics callback.
This rate can not be used for mac80211 mesh and ATF.

This patch adds support to update tx rate to mac80211

Anilkumar Kolli (2):
  mac80211: implement ieee80211_tx_rate_update to update rate
  ath10k: report tx rate using ieee80211_tx_rate_update()

 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   66 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 include/net/mac80211.h                   |   14 +++++++
 net/mac80211/status.c                    |   24 +++++++++++
 5 files changed, 102 insertions(+), 4 deletions(-)

-- 
1.7.9.5
