Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37765 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3CYS1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 14:27:53 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, parag.lkml@gmail.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	stable@vger.kernel.org
Subject: [PATCH] ath9k: avoid queueing hw check work when suspended
Date: Mon, 25 Mar 2013 11:27:46 -0700
Message-Id: <1364236066-11811-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130325_192758_968284_B40DC160)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The following issue was reported.

WARNING: at net/mac80211/util.c:599 ieee80211_can_queue_work.isra.7+0x32/0x40 [mac80211]()
Hardware name: iMac12,1
queueing ieee80211 work while going to suspend
Pid: 0, comm: swapper/0 Tainted: PF          O 3.8.2-206.fc18.x86_64 #1
Call Trace: Mar 16 09:39:17 Parags-iMac kernel: [ 3993.642992]  <IRQ>
[<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[<ffffffffa0581420>] ? ath_start_rx_poll+0x70/0x70 [ath9k]
<ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
[<ffffffffa045b542>] ieee80211_can_queue_work.isra.7+0x32/0x40

Fix this by avoiding to queue the work if our device has
already been marked as suspended or stopped.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
Tested-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath9k/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 39c84ec..7fdac6c 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -170,7 +170,8 @@ void ath_rx_poll(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 
-	ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
+		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 }
 
 /*
-- 
1.7.10.4

