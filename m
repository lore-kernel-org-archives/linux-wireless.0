Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14426 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1ECQFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 12:05:23 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 09:04:55 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Yogesh Powar <yogeshp@marvell.com>
Subject: [RFC] mac80211: Fix a warning due to skipping tailroom reservation for IV
Date: Tue, 3 May 2011 21:35:16 +0530
Message-ID: <1304438716-18800-1-git-send-email-mshajakhan@atheros.com> (sfid-20110503_180529_715967_D9CCADBE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The devices that require IV generation in software need tailroom
reservation  for ICVs used in TKIP or WEP encryptions.
Currently, decision to skip the tailroom reservation in the tx
path was taken only on whether driver wants MMIC to be generated
in software or not. Following patch appends IV generation check for
such decisions and fixes the following warning.

[   76.544132] WARNING: at net/mac80211/wep.c:101
ieee80211_wep_add_iv+0x56/0xf3()
[   76.544135] Hardware name: 64756D6
[   76.544137] Modules linked in: ath9k ath9k_common ath9k_hw
[   76.544145] Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc5-wl
[   76.544148] Call Trace:
[   76.544154]  [<c102fd29>] warn_slowpath_common+0x65/0x7a
[   76.544159]  [<c1465c4e>] ? ieee80211_wep_add_iv+0x56/0xf3
[   76.544163]  [<c102fd4d>] warn_slowpath_null+0xf/0x13
[   76.544167]  [<c1465c4e>] ieee80211_wep_add_iv+0x56/0xf3
[   76.544171]  [<c1466007>] ieee80211_crypto_wep_encrypt+0x63/0x88
[   76.544176]  [<c1478bf3>] ieee80211_tx_h_encrypt+0x2f/0x63
[   76.544180]  [<c1478cba>] invoke_tx_handlers+0x93/0xe1
[   76.544184]  [<c1478eda>] ieee80211_tx+0x4b/0x6d
[   76.544189]  [<c147907c>] ieee80211_xmit+0x180/0x188
[   76.544193]  [<c147779d>] ? ieee80211_skb_resize+0x95/0xd9
[   76.544197]  [<c1479edf>] ieee80211_subif_start_xmit+0x64f/0x668
[   76.544204]  [<c13956fc>] dev_hard_start_xmit+0x368/0x48c
[   76.544208]  [<c13a8bd6>] sch_direct_xmit+0x4d/0x101
[   76.544212]  [<c1395ae1>] dev_queue_xmit+0x2c1/0x43f
[   76.544218]  [<c13a74a2>] ? eth_header+0x1e/0x90
[   76.544222]  [<c13a7400>] ? eth_type_trans+0x91/0xc2
[   76.544226]  [<c13a7484>] ? eth_rebuild_header+0x53/0x53
[   76.544231]  [<c139f079>] neigh_resolve_output+0x223/0x27e
[   76.544237]  [<c13c6b23>] ip_finish_output2+0x1d4/0x1fe
[   76.544241]  [<c13c6bc6>] ip_finish_output+0x79/0x7d
[   76.544245]  [<c13c6cbe>] T.1075+0x43/0x48
[   76.544249]  [<c13c6e6e>] ip_output+0x75/0x7b
[   76.544253]  [<c13c4970>] dst_output+0xc/0xe
[   76.544257]  [<c13c62c9>] ip_local_out+0x17/0x1a
[   76.544261]  [<c13c67bb>] ip_queue_xmit+0x2aa/0x2f8
[   76.544266]  [<c138b742>] ? sk_setup_caps+0x21/0x92
[   76.544271]  [<c13d95ea>] ? __tcp_v4_send_check+0x7e/0xb7
[   76.544276]  [<c13d5d2e>] tcp_transmit_skb+0x6a1/0x6d7
[   76.544280]  [<c13d533b>] ? tcp_established_options+0x20/0x8b
[   76.544284]  [<c13d6f28>] tcp_retransmit_skb+0x43a/0x527
[   76.544289]  [<c13d8d6d>] tcp_retransmit_timer+0x32e/0x45d
[   76.544293]  [<c13d8f23>] tcp_write_timer+0x87/0x16c
[   76.544298]  [<c103a030>] run_timer_softirq+0x156/0x1f9
[   76.544303]  [<c13d8e9c>] ? tcp_retransmit_timer+0x45d/0x45d
[   76.544307]  [<c1034d65>] __do_softirq+0x97/0x14a
[   76.544311]  [<c1034cce>] ? irq_enter+0x4d/0x4d
[   76.544313]  <IRQ>  [<c1034bb4>] ? irq_exit+0x32/0x7d
[   76.544320]  [<c1003175>] ? do_IRQ+0x7c/0x90
[   76.544325]  [<c14ad429>] ? common_interrupt+0x29/0x30
[   76.544330]  [<c104007b>] ? call_usermodehelper_exec+0x5f/0xa6
[   76.544335]  [<c11dab7d>] ? acpi_idle_enter_bm+0x22a/0x25e
[   76.544341]  [<c132f796>] ? cpuidle_idle_call+0xdb/0x169
[   76.544345]  [<c1001b1b>] ? cpu_idle+0x44/0x61
[   76.544349]  [<c148b5f4>] ? rest_init+0x58/0x5a
[   76.544354]  [<c170178a>] ? start_kernel+0x2bc/0x2c1
[   76.544358]  [<c17010ba>] ? i386_start_kernel+0xba/0xc1
[   76.544361] ---[ end trace 3fa4a780a476018f ]---

Cc: Yogesh Powar <yogeshp@marvell.com>
Reported-by: "Fabio Rossi" <rossi.f@inwind.it>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/key.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ca3c626..0037905 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -102,7 +102,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+				(key->conf.flags &
+				 IEEE80211_KEY_FLAG_GENERATE_IV)))
 			key->local->crypto_tx_tailroom_needed_cnt--;
 
 		return 0;
@@ -161,7 +163,9 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+				(key->conf.flags &
+				 IEEE80211_KEY_FLAG_GENERATE_IV)))
 		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
-- 
1.7.0.4

