Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54111 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3CSBVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 21:21:22 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	stable@vger.kernel.org
Subject: [PATCH] ath9k: skip rearming rx_poll_timer when quiescing
Date: Mon, 18 Mar 2013 18:14:26 -0700
Message-Id: <1363655666-1217-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130319_022127_291793_F6F43AAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

When mac80211 goes to suspend we disarm our timers
but users of mod_timer() must ensure to use
mod_timer_pending() where appropriate to avoid
re-arming them before coming up after suspend. This
is one case that was reported by Parag.

Issue reported:

WARNING: at net/mac80211/util.c:599 ieee80211_can_queue_work.isra.7+0x32/0x40 [mac80211]()
Hardware name: iMac12,1
queueing ieee80211 work while going to suspend
Pid: 0, comm: swapper/0 Tainted: PF          O 3.8.2-206.fc18.x86_64 #1
Call Trace: Mar 16 09:39:17 Parags-iMac kernel: [ 3993.642992]  <IRQ>
[<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[<ffffffffa0581420>] ? ath_start_rx_poll+0x70/0x70 [ath9k]
<ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
[<ffffffffa045b542>] ieee80211_can_queue_work.isra.7+0x32/0x40

Other timers on 802.11 drivers, mac80211 and cfg80211
should be groomed to verify the same is avoided.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
Tested-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath9k/link.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 39c84ec..25aa894 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -162,8 +162,8 @@ void ath_start_rx_poll(struct ath_softc *sc, u8 nbeacon)
 	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
 		return;
 
-	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies
-		  (nbeacon * sc->cur_beacon_conf.beacon_interval));
+	mod_timer_pending(&sc->rx_poll_timer, jiffies + msecs_to_jiffies
+			  (nbeacon * sc->cur_beacon_conf.beacon_interval));
 }
 
 void ath_rx_poll(unsigned long data)
-- 
1.7.10.4

