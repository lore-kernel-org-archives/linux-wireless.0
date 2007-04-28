Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41812 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965959AbXD1QmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/7] mac80211: move radiotap removal code to right function
Date: Sat, 28 Apr 2007 12:36:01 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

A chunk from the radiotap patch landed in the wrong function when the patch
was being updated. This moves it to the right function.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e4aa4aa..851400a 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -3280,6 +3280,9 @@ ieee80211_rx_h_monitor(struct ieee80211_txrx_data *rx)
 		return TXRX_QUEUED;
 	}
 
+	if (rx->u.rx.status->flag & RX_FLAG_RADIOTAP)
+		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb));
+
 	return TXRX_CONTINUE;
 }
 
@@ -3472,9 +3475,6 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 		return TXRX_QUEUED;
 	}
 
-	if (rx->u.rx.status->flag & RX_FLAG_RADIOTAP)
-		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb));
-
 	return TXRX_CONTINUE;
 }
 

