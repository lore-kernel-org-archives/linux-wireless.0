Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbeIXNH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 09:07:59 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [RFC v4 0/2]  ath10k: Add support to update tx rate to mac80211
Date: Mon, 24 Sep 2018 12:39:58 +0530
Message-Id: <1537773000-2587-1-git-send-email-akolli@codeaurora.org> (sfid-20180924_090722_566988_80DBD0EB)
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
 include/net/mac80211.h                   |   15 +++++++
 net/mac80211/status.c                    |   22 ++++++++++
 5 files changed, 101 insertions(+), 4 deletions(-)

-- 
1.7.9.5
