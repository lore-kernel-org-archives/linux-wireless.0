Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbeGZIgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 04:36:55 -0400
From: Wen Gong <wgong@codeaurora.org>
To: ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Change sk_pacing_shift in ieee80211_hw for best tx throughput
Date: Thu, 26 Jul 2018 15:21:15 +0800
Message-Id: <1532589677-16428-1-git-send-email-wgong@codeaurora.org> (sfid-20180726_092128_790656_025B0A38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a field for ath10k to adjust the sk_pacing_shift, mac80211 set
the default value to 8, and ath10k will change it to 6. Then mac80211
will use the changed value 6 as sk_pacing_shift since 6 is the best
value for tx throughput by test result.

Wen Gong (2):
  mac80211: Change sk_pacing_shift saved to ieee80211_hw
  ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips

 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 include/net/mac80211.h                | 1 +
 net/mac80211/main.c                   | 2 ++
 net/mac80211/tx.c                     | 2 +-
 4 files changed, 6 insertions(+), 1 deletion(-)

-- 
1.9.1
