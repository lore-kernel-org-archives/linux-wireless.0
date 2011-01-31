Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37902 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1AaU3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:29:23 -0500
Received: by wyb28 with SMTP id 28so5916278wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 12:29:22 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] mac80211: do not calc frame duration when using HW rate-control
Date: Mon, 31 Jan 2011 22:29:12 +0200
Message-Id: <1296505753-29594-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rate-control is performed in HW, we cannot calculate frame
duration as we do not have the skb transmission rate in SW.

ieee80211_tx_h_calculate_duration() should only be called when
ieee80211_tx_h_rate_ctrl() has been called before to initialize data
in skb->cb. This doesn't happen for drivers with HW rate-control.

Fixes the following warning when operating in AP-mode
in a driver with HW rate-control.

WARNING: at net/mac80211/tx.c:57 ieee80211_duration+0x54/0x1d8 [mac80211]()
Modules linked in: wl1271_sdio wl1271 firmware_class crc7 mac80211 cfg80211
[<c0046090>] (unwind_backtrace+0x0/0x124) from [<c0064c10>] (warn_slowpath_common+0x4c/0x64)
[<c0064c10>] (warn_slowpath_common+0x4c/0x64) from [<c0064c40>] (warn_slowpath_null+0x18/0x1c)
[<c0064c40>] (warn_slowpath_null+0x18/0x1c) from [<bf040e34>] (ieee80211_duration+0x54/0x1d8 [mac80211])
[<bf040e34>] (ieee80211_duration+0x54/0x1d8 [mac80211]) from [<bf04200c>] (invoke_tx_handlers+0xfa0/0x1088 [mac80211])
[<bf04200c>] (invoke_tx_handlers+0xfa0/0x1088 [mac80211]) from [<bf042178>] (ieee80211_tx+0x84/0x248 [mac80211])
[<bf042178>] (ieee80211_tx+0x84/0x248 [mac80211]) from [<bf042f44>] (ieee80211_tx_pending+0x12c/0x278 [mac80211])
[<bf042f44>] (ieee80211_tx_pending+0x12c/0x278 [mac80211]) from [<c0069a9c>] (tasklet_action+0x68/0xbc)
[<c0069a9c>] (tasklet_action+0x68/0xbc) from [<c006a044>] (__do_softirq+0x84/0x114)
[<c006a044>] (__do_softirq+0x84/0x114) from [<c006a1b8>] (do_softirq+0x48/0x54)
[<c006a1b8>] (do_softirq+0x48/0x54) from [<c006a4f8>] (local_bh_enable+0x98/0xcc)
[<c006a4f8>] (local_bh_enable+0x98/0xcc) from [<bf074e60>] (wl1271_rx+0x2e8/0x3a4 [wl1271])
[<bf074e60>] (wl1271_rx+0x2e8/0x3a4 [wl1271]) from [<bf071ae4>] (wl1271_irq_work+0x230/0x310 [wl1271])
[<bf071ae4>] (wl1271_irq_work+0x230/0x310 [wl1271]) from [<c0076864>] (process_one_work+0x208/0x350)
[<c0076864>] (process_one_work+0x208/0x350) from [<c0076e14>] (worker_thread+0x1cc/0x300)
[<c0076e14>] (worker_thread+0x1cc/0x300) from [<c007bb88>] (kthread+0x84/0x8c)
[<c007bb88>] (kthread+0x84/0x8c) from [<c0041494>] (kernel_thread_exit+0x0/0x8)

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e46c801..8c477a9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1394,7 +1394,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	/* handlers after fragment must be aware of tx info fragmentation! */
 	CALL_TXH(ieee80211_tx_h_stats);
 	CALL_TXH(ieee80211_tx_h_encrypt);
-	CALL_TXH(ieee80211_tx_h_calculate_duration);
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+		CALL_TXH(ieee80211_tx_h_calculate_duration);
 #undef CALL_TXH
 
  txh_done:
-- 
1.7.1

