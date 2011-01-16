Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51176 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1APFm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:28 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so4401170wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:27 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/10] mac80211: do not calc frame duration when using HW rate-control
Date: Sun, 16 Jan 2011 07:42:08 +0200
Message-Id: <1295156534-4178-5-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rate-control is performed in HW, we cannot calculate frame
duration as we do not have the skb transmission rate in SW.

ieee80211_tx_h_calculate_duration() should only be called when
ieee80211_tx_h_rate_ctrl() has been called before to initialize data
in skb->cb. This doesn't happen for drivers with HW rate-control.

Fixes the following warning when operating in AP-mode
in a driver with HW rate-control.

<4>[16747.586029] WARNING: at net/mac80211/tx.c:57 ieee80211_duration
+0x54/0x1d8 [mac80211]()
<4>[16747.594085] Modules linked in: wl12xx_sdio wl12xx firmware_class crc7
mac80211 cfg80211 [last unloaded: crc7]
<4>[16747.604095] [<c004707c>] (unwind_backtrace+0x0/0x124) from [<c006644c>]
(warn_slowpath_common+0x4c/0x64)
<4>[16747.613616] [<c006644c>] (warn_slowpath_common+0x4c/0x64) from
[<c006647c>] (warn_slowpath_null+0x18/0x1c)
<4>[16747.623382] [<c006647c>] (warn_slowpath_null+0x18/0x1c) from [<bf1aa8e8>]
(ieee80211_duration+0x54/0x1d8 [mac80211])
<4>[16747.634124] [<bf1aa8e8>] (ieee80211_duration+0x54/0x1d8 [mac80211]) from
[<bf1aacec>] (ieee80211_tx_h_calculate_duration+0x3c/0x5c [mac80211])
<4>[16747.647094] [<bf1aacec>] (ieee80211_tx_h_calculate_duration+0x3c/0x5c
[mac80211]) from [<bf1ab21c>] (invoke_tx_handlers+0xdc/0x118 [mac80211])
<4>[16747.660064] [<bf1ab21c>] (invoke_tx_handlers+0xdc/0x118 [mac80211])
from [<bf1ab2dc>] (ieee80211_tx+0x84/0x248 [mac80211])
<4>[16747.671295] [<bf1ab2dc>] (ieee80211_tx+0x84/0x248 [mac80211]) from
[<bf1abe3c>] (ieee80211_tx_pending+0x12c/0x278 [mac80211])
<4>[16747.682739] [<bf1abe3c>] (ieee80211_tx_pending+0x12c/0x278 [mac80211])
from [<c006b3bc>] (tasklet_action+0x68/0xc0)

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..e0d6d5c 100644
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

