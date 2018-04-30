Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeD3G1U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 02:27:20 -0400
From: Sriram R <srirrama@codeaurora.org>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Sriram R <srirrama@codeaurora.org>
Subject: [PATCH 0/2 linux-stable-4.4] ath10k: rebuild crypto header in rx data frames 
Date: Mon, 30 Apr 2018 11:56:25 +0530
Message-Id: <1525069587-19281-1-git-send-email-srirrama@codeaurora.org> (sfid-20180430_082725_874756_DA116BA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k has a replay detection issue which was fixed in v4.14 and we would
like to get this security fix also to linux-stable-4.4.But for that it
depends on 3 mac80211 patches so the below mac80211 commits needs to be
picked first in the same order and then apply this patchset.

f980ebc058c2 : mac80211: allow not sending MIC up from driver for HW crypto
f631a77ba920 : mac80211: allow same PN for AMSDU sub-frames  
cef0acd4d7d4 : mac80211: Add RX flag to indicate ICV stripped

These patches should be applied in that order(commit f980ebc058c2 first)
and they should apply cleanly with 3-way merge.

Sriram R (2):
  ath10k: Add new hw param to identify alignment for different chipsets
  ath10k: rebuild crypto header in rx data frames

 drivers/net/wireless/ath/ath10k/core.c    |   8 +++
 drivers/net/wireless/ath/ath10k/core.h    |   4 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 108 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/rx_desc.h |   3 +
 4 files changed, 107 insertions(+), 16 deletions(-)

-- 
2.7.4
