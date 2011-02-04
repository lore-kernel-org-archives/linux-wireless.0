Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58497 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1BDSUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 13:20:14 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: do not send duplicate data frames to the cooked monitor interface
Date: Fri,  4 Feb 2011 19:20:08 +0100
Message-Id: <1296843608-90133-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't think of a valid use case for this aside from debugging (which can
also be done with a real monitor interface), and dropping these frames saves
some precious CPU cycles.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7185c93..65bc1f4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -815,7 +815,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
-			return RX_DROP_MONITOR;
+			return RX_DROP_UNUSABLE;
 		} else
 			rx->sta->last_seq_ctrl[rx->queue] = hdr->seq_ctrl;
 	}
-- 
1.7.3.2

