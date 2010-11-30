Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0K3Op5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 09:45:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 06:45:42 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>, <johannes.berg@intel.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable <stable@kernel.org>
Subject: [PATCH 1/2] mac80211: Fix STA disconnect due to MIC failure
Date: Tue, 30 Nov 2010 20:15:38 +0530
Message-ID: <1291128339-2670-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Th commit titled "mac80211: clean up rx handling wrt. found_sta"
removed found_sta variable which caused a MIC failure event
to be reported twice for a single failure to supplicant resulted
in STA disconnect.

This should fix WPA specific countermeasures WiFi test case (5.2.17)
issues with mac80211 based drivers which report MIC failure events in
rx status.

Cc: Stable <stable@kernel.org> (2.6.37)
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 net/mac80211/rx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fdeabb1..b5f57ca 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2748,6 +2748,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
 				return;
+			goto out;
 		}
 	}
 
@@ -2787,6 +2788,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			return;
 	}
 
+ out:
 	dev_kfree_skb(skb);
 }
 
-- 
1.7.2.1

