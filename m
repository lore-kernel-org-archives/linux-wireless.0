Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34058 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbcKVFod (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 00:44:33 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Mon, 21 Nov 2016 21:44:24 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] mac80211: Remove unused 'struct ieee80211_rx_status' ptr
Message-ID: <20161122054424.GA31927@google.com> (sfid-20161122_064441_855368_D2FE09EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 554891e63a29 introduced 'struct ieee80211_rx_status' in
ieee80211_rx_h_defragment but did not use it. Compiling with W=1
gives the following warning, fix it.

net/mac80211/rx.c: In function ‘ieee80211_rx_h_defragment’:
net/mac80211/rx.c:1911:30: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]

Fixes: 554891e63a29 ("mac80211: move packet flags into packet")
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 net/mac80211/rx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eeab725..d2a00f2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1908,7 +1908,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
-	struct ieee80211_rx_status *status;

 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
@@ -2034,9 +2033,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		dev_kfree_skb(skb);
 	}

-	/* Complete frame has been reassembled - process it now */
-	status = IEEE80211_SKB_RXCB(rx->skb);
-
  out:
 	ieee80211_led_rx(rx->local);
  out_no_led:
--
2.8.0.rc3.226.g39d4020
