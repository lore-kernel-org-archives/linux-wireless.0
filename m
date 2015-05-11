Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35960 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbbEKJbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 05:31:51 -0400
Received: by lagv1 with SMTP id v1so89035542lag.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 02:31:49 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211: WEP, move tailroom size check
Date: Mon, 11 May 2015 11:31:15 +0200
Message-Id: <1431336675-15944-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150511_113156_802544_4672D683)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove checking tailroom when adding IV, while
this goes to headroom. Move this check to the function
that will generate/put ICV for WEP.

In other case I hit such warning and datapath don't work,
when testing:
- IBSS + WEP
- ath9k with hw crypt enabled
- IPv6 data (ping6)

WARNING: CPU: 3 PID: 13301 at net/mac80211/wep.c:102 ieee80211_wep_add_iv+0x129/0x190 [mac80211]()
CPU: 3 PID: 13301 Comm: ping6 Tainted: G        W  OE   4.1.0-rc1master-2015-05-07-00-wl-ath+ #20
Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A13 09/02/2013
ffffffffc0a24602 ffff88020b4475b8 ffffffff817bf491 0000000000000000
0000000000000000 ffff88020b4475f8 ffffffff8107746a ffff880209c666a0
ffff88020b95e800 ffff88020b447710 0000000000000005 ffff88020b95e800
Call Trace:
[<ffffffff817bf491>] dump_stack+0x45/0x57
[<ffffffff8107746a>] warn_slowpath_common+0x8a/0xc0
[<ffffffff8107755a>] warn_slowpath_null+0x1a/0x20
[<ffffffffc09ae109>] ieee80211_wep_add_iv+0x129/0x190 [mac80211]
[<ffffffffc09ae7ab>] ieee80211_crypto_wep_encrypt+0x6b/0xd0 [mac80211]
[<ffffffffc09d3fb1>] invoke_tx_handlers+0xc51/0xf30 [mac80211]
[<ffffffff813ba8f0>] ? find_next_bit+0x20/0x30
[<ffffffff813a5854>] ? cpumask_next_and+0x44/0x50
[<ffffffffc09d4446>] ieee80211_tx+0x76/0xf0 [mac80211]
[<ffffffffc09d46c1>] ieee80211_xmit+0xa1/0x100 [mac80211]
[<ffffffffc09d562b>] __ieee80211_subif_start_xmit+0x5db/0x770 [mac80211]
[<ffffffffc09d57d0>] ieee80211_subif_start_xmit+0x10/0x20 [mac80211]
[<ffffffff816b91d5>] dev_hard_start_xmit+0x235/0x3c0
[<ffffffff816db932>] sch_direct_xmit+0xf2/0x200
[<ffffffff816b95a2>] __dev_queue_xmit+0x242/0x580
[<ffffffff816b98f3>] dev_queue_xmit_sk+0x13/0x20
[<ffffffff8175e5f8>] ip6_finish_output2+0x398/0x490
[<ffffffff8175f34c>] ? __ip6_append_data.isra.35+0x92c/0xcc0
[<ffffffff81760c2f>] ip6_finish_output+0x8f/0xf0
[<ffffffff81760cd4>] ip6_output+0x44/0xe0
[<ffffffff817610b8>] ? __ip6_make_skb+0x348/0x4d0
[<ffffffff8175f78d>] ? ip6_append_data+0xad/0x140
[<ffffffff8179a1dd>] ip6_local_out_sk+0x2d/0x40
[<ffffffff8179a205>] ip6_local_out+0x15/0x20
[<ffffffff8176125d>] ip6_send_skb+0x1d/0x70
[<ffffffff817612e9>] ip6_push_pending_frames+0x39/0x40
[<ffffffff8177ef30>] rawv6_sendmsg+0x8e0/0xba0
[<ffffffff816aa100>] ? datagram_poll+0x110/0x110
[<ffffffff8172e7c4>] inet_sendmsg+0x64/0xa0
[<ffffffff8169b63d>] sock_sendmsg+0x3d/0x50
[<ffffffff8169bfee>] ___sys_sendmsg+0x29e/0x2c0
[<ffffffff8118a2db>] ? lru_cache_add_active_or_unevictable+0x2b/0xa0
[<ffffffff811ab394>] ? handle_mm_fault+0xfb4/0x17d0
[<ffffffff811d3f72>] ? kmem_cache_alloc_trace+0x1e2/0x220
[<ffffffff8134b327>] ? aa_alloc_task_context+0x27/0x40
[<ffffffff8169c912>] __sys_sendmsg+0x42/0x80
[<ffffffff8169c962>] SyS_sendmsg+0x12/0x20
[<ffffffff817c7232>] system_call_fastpath+0x16/0x75
 ---[ end trace 4c04533cea0d0a46 ]---

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/wep.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index a4220e9..efa3f48 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -98,8 +98,7 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
-	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN ||
-		    skb_headroom(skb) < IEEE80211_WEP_IV_LEN))
+	if (WARN_ON(skb_headroom(skb) < IEEE80211_WEP_IV_LEN))
 		return NULL;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -167,6 +166,9 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	size_t len;
 	u8 rc4key[3 + WLAN_KEY_LEN_WEP104];
 
+	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN))
+		return -1;
+
 	iv = ieee80211_wep_add_iv(local, skb, keylen, keyidx);
 	if (!iv)
 		return -1;
-- 
1.9.1

