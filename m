Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46997 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GGNet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 09:34:49 -0400
Received: by werb14 with SMTP id b14so7028700wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 06:34:48 -0700 (PDT)
Message-Id: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com> (sfid-20120707_153542_897799_93455353)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 7 Jul 2012 15:07:13 +0200
Subject: [PATCH 1/2] mac80211: fix read outside array bounds
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee802_1d_to_ac is defined as a const int[8],
but the tid parameter has a range from 0 to 15.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
IMHO the patch should be correct, although it's been a while.
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d2e8159..3e974f2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2717,7 +2717,7 @@ EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid)
 {
-	int ac = ieee802_1d_to_ac[tid];
+	int ac = ieee802_1d_to_ac[tid & 7];
 
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
-- 
1.7.10

