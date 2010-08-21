Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3696 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0HUUjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 16:39:54 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: log descriptor chains at a new debug level
Date: Sat, 21 Aug 2010 16:39:03 -0400
Message-Id: <1282423143-4121-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1282423143-4121-1-git-send-email-me@bobcopeland.com>
References: <1282423143-4121-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Descriptors are currently logged with ATH5K_DEBUG_RESET,
which isn't really apt, and also means we can't see just
the descriptor setup or just the resets.  Add a new
debug level just for that.

Acked-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/debug.c |    5 +++--
 drivers/net/wireless/ath/ath5k/debug.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 4cccc29..1b7c6d7 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -312,6 +312,7 @@ static const struct {
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
 	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
+	{ ATH5K_DEBUG_DESC,	"desc",		"descriptor chains" },
 	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
 };
 
@@ -955,7 +956,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 	struct ath5k_rx_status rs = {};
 	int status;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
+	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
 		return;
 
 	printk(KERN_DEBUG "rxdp %x, rxlink %p\n",
@@ -997,7 +998,7 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct ath5k_tx_status ts = {};
 	int done;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
+	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
 		return;
 
 	done = sc->ah->ah_proc_tx_desc(sc->ah, bf->desc, &ts);
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 606ae94..9b22722 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -95,6 +95,7 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
  * @ATH5K_DEBUG_DUMPBANDS: dump bands
  * @ATH5K_DEBUG_TRACE: trace function calls
+ * @ATH5K_DEBUG_DESC: descriptor setup
  * @ATH5K_DEBUG_ANY: show at any debug level
  *
  * The debug level is used to control the amount and type of debugging output
@@ -117,6 +118,7 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
 	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
 	ATH5K_DEBUG_ANI		= 0x00002000,
+	ATH5K_DEBUG_DESC	= 0x00004000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
 };
 
-- 
1.7.1.1


