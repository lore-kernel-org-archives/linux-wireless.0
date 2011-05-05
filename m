Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14409 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1EEF3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 01:29:33 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 22:29:05 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Larry.Finger@lwfinger.net>, <yogeshp@marvell.com>,
	<rossi.f@inwind.it>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] mac80211: Fix a warning due to skipping tailroom reservation for IV
Date: Thu, 5 May 2011 10:59:24 +0530
Message-ID: <1304573364-11581-1-git-send-email-mshajakhan@atheros.com> (sfid-20110505_072937_179915_A073F9B8)
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

WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x56/0xf3()
Hardware name: 64756D6
Modules linked in: ath9k ath9k_common ath9k_hw
Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc5-wl
 Call Trace:
[<c102fd29>] warn_slowpath_common+0x65/0x7a
[<c1465c4e>] ? ieee80211_wep_add_iv+0x56/0xf3
[<c102fd4d>] warn_slowpath_null+0xf/0x13
[<c1465c4e>] ieee80211_wep_add_iv+0x56/0xf3
[<c1466007>] ieee80211_crypto_wep_encrypt+0x63/0x88
[<c1478bf3>] ieee80211_tx_h_encrypt+0x2f/0x63
[<c1478cba>] invoke_tx_handlers+0x93/0xe1
[<c1478eda>] ieee80211_tx+0x4b/0x6d
[<c147907c>] ieee80211_xmit+0x180/0x188
[<c147779d>] ? ieee80211_skb_resize+0x95/0xd9
[<c1479edf>] ieee80211_subif_start_xmit+0x64f/0x668
[<c13956fc>] dev_hard_start_xmit+0x368/0x48c
[<c13a8bd6>] sch_direct_xmit+0x4d/0x101
[<c1395ae1>] dev_queue_xmit+0x2c1/0x43f
[<c13a74a2>] ? eth_header+0x1e/0x90
[<c13a7400>] ? eth_type_trans+0x91/0xc2
[<c13a7484>] ? eth_rebuild_header+0x53/0x53
[<c139f079>] neigh_resolve_output+0x223/0x27e
[<c13c6b23>] ip_finish_output2+0x1d4/0x1fe
[<c13c6bc6>] ip_finish_output+0x79/0x7d
[<c13c6cbe>] T.1075+0x43/0x48
[<c13c6e6e>] ip_output+0x75/0x7b
[<c13c4970>] dst_output+0xc/0xe
[<c13c62c9>] ip_local_out+0x17/0x1a
[<c13c67bb>] ip_queue_xmit+0x2aa/0x2f8
[<c138b742>] ? sk_setup_caps+0x21/0x92
[<c13d95ea>] ? __tcp_v4_send_check+0x7e/0xb7
[<c13d5d2e>] tcp_transmit_skb+0x6a1/0x6d7
[<c13d533b>] ? tcp_established_options+0x20/0x8b
[<c13d6f28>] tcp_retransmit_skb+0x43a/0x527
[<c13d8d6d>] tcp_retransmit_timer+0x32e/0x45d
[<c13d8f23>] tcp_write_timer+0x87/0x16c
[<c103a030>] run_timer_softirq+0x156/0x1f9
[<c13d8e9c>] ? tcp_retransmit_timer+0x45d/0x45d
[<c1034d65>] __do_softirq+0x97/0x14a
[<c1034cce>] ? irq_enter+0x4d/0x4d

Cc: Yogesh Powar <yogeshp@marvell.com>
Reported-by: Fabio Rossi <rossi.f@inwind.it>
Tested-by: Fabio Rossi <rossi.f@inwind.it>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/key.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ca3c626..b510721 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -102,7 +102,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
 			key->local->crypto_tx_tailroom_needed_cnt--;
 
 		return 0;
@@ -161,7 +162,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
 		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
-- 
1.7.0.4

