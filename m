Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46890 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab2EII4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 04:56:19 -0400
Received: by eaaq12 with SMTP id q12so13137eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 01:56:17 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Fix race between tx path and ___ieee80211_stop_tx_ba_session
Date: Wed,  9 May 2012 10:56:12 +0200
Message-Id: <1336553772-7519-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120509_105625_368943_44F734A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

___ieee80211_stop_tx_ba_session first deletes the tx aggregation session
timer and afterwards clears HT_AGG_STATE_OPERATIONAL. Hence, there is a
small time window where the tx path can call mod_timer after
del_timer_sync.

When ieee80211_start_tx_ba_session runs before the timer the call to
init_timer will cause a BUG_ON:

[ 97.760000] Kernel bug detected[001]:
[ 97.760000] Cpu 0
[ 97.760000] $ 0 : 00000000 00000000 00000001 000000e6
[ 97.760000] $ 4 : 8035791c 80f96008 ffffb100 00000001
[ 97.760000] $ 8 : 00000000 2e310000 00000002 89130205
[ 97.760000] $12 : ccdc43e0 00000000 80f30000 00000000
[ 97.760000] $16 : 803571e0 8189398c 00000031 81823e18
[ 97.760000] $20 : fffffffe 801da144 801da154 80203b38
[ 97.760000] $24 : 00000000 8000d1ac
[ 97.760000] $28 : 81822000 81823e08 80204110 8001e3f8
[ 97.760000] Hi : 0000000a
[ 97.760000] Lo : 0000000c
[ 97.760000] epc : 8001e3ec cascade+0x6c/0xac
[ 97.760000] Not tainted
[ 97.760000] ra : 8001e3f8 cascade+0x78/0xac
[ 97.760000] Status: 1000e402 KERNEL EXL
[ 97.760000] Cause : 10800034
[ 97.760000] PrId : 0001964c (MIPS 24Kc)
[ 97.760000] Modules linked in: rt2800pci rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 crc_itu_t crc_ccitt cfg80211 compat arc4 button_hotplug gpio_buttons input_polldev input_core
[ 97.760000] Process ksoftirqd/0 (pid: 3, threadinfo=81822000, task=81818860, tls=00000000)
[ 97.760000] Stack : 0000000c 8000d1ac 00802000 00000005 818939b8 8189398c 803571e0 00000000
[ 97.760000] 00000001 80360000 80200000 8001e53c 80200000 00000100 00000009 80350000
[ 97.760000] 80350000 80203b38 80204110 800197e4 80357084 00000025 00000001 00000100
[ 97.760000] 00000008 80350000 80350000 80019b94 80201760 801a1e58 00000000 8000f958
[ 97.760000] 1000e403 00000000 80350000 80350000 00000000 00000001 00000000 00000000
[ 97.760000] ...
[ 97.760000] Call Trace:
[ 97.760000] [<8001e3ec>] cascade+0x6c/0xac
[ 97.760000] [<8001e53c>] run_timer_softirq+0x80/0x1ec
[ 97.760000] [<80019b94>] __do_softirq+0xac/0x15c
[ 97.760000] [<80019cbc>] run_ksoftirqd+0x78/0x110
[ 97.760000] [<8002ba7c>] kthread+0x80/0x88
[ 97.760000] [<800032f0>] kernel_thread_helper+0x10/0x18
[ 97.760000]
[ 97.760000]
[ 97.760000] Code: 00541024 02021026 0002102b
[ 97.760000] 0c00788c 02002021 02202821 8e310000 54b3fff7

With kernel object debugging enabled:

ODEBUG: init active (active state 0) object type: timer_list hint: ieee80211_stop_tx_ba_session+0xc0/0x110 [mac80211]

Fix this by first clearing HT_AGG_STATE_OPERATIONAL and then deleting
the session timer.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Johannes, I'm not 100% sure if the fix is correct but I wasn't able to
reproduce the BUG_ON anymore with it.

Thanks,
Helmut

 net/mac80211/agg-tx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5b7053c..c44410a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -189,9 +189,6 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	del_timer_sync(&tid_tx->addba_resp_timer);
-	del_timer_sync(&tid_tx->session_timer);
-
 	/*
 	 * After this packets are no longer handed right through
 	 * to the driver but are put onto tid_tx->pending instead,
@@ -199,6 +196,9 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+	del_timer_sync(&tid_tx->session_timer);
+
 	/*
 	 * There might be a few packets being processed right now (on
 	 * another CPU) that have already gotten past the aggregation
-- 
1.7.7

