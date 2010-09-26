Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0I0R7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:05 -0400
Received: by bwz11 with SMTP id 11so3540044bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:03 -0700 (PDT)
Message-Id: <5b1d0835820619c19e291a9c39895b0df9310bc6.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Sep 2010 21:28:51 +0200
Subject: [PATCH 1/6] carl9170: remove non-standard ba session teardown
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11n-2009 demands in 11.2.1: "
When a STA enters normal (non-APSD) PS mode, any downlink
Block ACK agreement without an associated schedule is
suspended for the duration of this PS mode."

The operative word is "suspended" and not terminated.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 43de9df..d28b4ff 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1453,9 +1453,6 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 				while ((skb = __skb_dequeue(&tid_info->queue)))
 					__skb_queue_tail(&free, skb);
 				spin_unlock_bh(&tid_info->lock);
-
-				ieee80211_stop_tx_ba_session(sta,
-					tid_info->tid);
 			}
 			rcu_read_unlock();
 		}
-- 
1.7.1

