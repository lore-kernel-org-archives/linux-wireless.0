Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:56777 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945976Ab3BHPJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 10:09:18 -0500
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: fix band for supported channels
Date: Fri,  8 Feb 2013 16:07:25 +0100
Message-Id: <1360336045-5501-1-git-send-email-jogo@openwrt.org> (sfid-20130208_163813_681181_CA587F9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The band field for the supported channels were left unpopulated, making
them default to 0 == IEEE80211_BAND_2GHZ, even for the 5GHz channels.

This resulted in null pointer accesses if anything tries to access
wiphy->bands[channel->band] of a 5GHz channel on 5GHz only cards, since
wiphy->bands[2GHZ] is NULL for them (e.g. cfg80211_chandef_usable does).

Example kernel OOPS:

[  665.669993] Unable to handle kernel NULL pointer dereference at virtual address 00000016
[  665.678194] pgd = c6d58000
[  665.680941] [00000016] *pgd=06f8a831, *pte=00000000, *ppte=00000000
[  665.687303] Internal error: Oops: 17 [#1]
(...)
[  666.116373] Backtrace:
[  666.118866] [<bf0368dc>] (cfg80211_chandef_usable+0x0/0x1bc [cfg80211]) from [<bf025e64>] (nl80211_leave_mesh+0x244/0x264 [cfg80211])
[  666.130919]  r7:c6d12100 r6:0000143c r5:c0611c48 r4:c0611b98
[  666.136668] [<bf025d84>] (nl80211_leave_mesh+0x164/0x264 [cfg80211]) from [<bf02634c>] (nl80211_remain_on_channel+0x2a0/0x358 [cfg80211])
[  666.149074]  r7:c6d12000 r6:c6d12000 r5:c6f4f368 r4:00000003
[  666.154814] [<bf0262ec>] (nl80211_remain_on_channel+0x240/0x358 [cfg80211]) from [<bf02ddb0>] (nl80211_set_wiphy+0x264/0x560 [cfg80211])
[  666.167150] [<bf02db4c>] (nl80211_set_wiphy+0x0/0x560 [cfg80211]) from [<c01f94e0>] (genl_rcv_msg+0x1b8/0x1f8)
[  666.177205] [<c01f9328>] (genl_rcv_msg+0x0/0x1f8) from [<c01f89a0>] (netlink_rcv_skb+0x58/0xb4)
[  666.185949] [<c01f8948>] (netlink_rcv_skb+0x0/0xb4) from [<c01f931c>] (genl_rcv+0x20/0x2c)
[  666.194251]  r6:c6f70780 r5:0000002c r4:c6f70780 r3:00000001
[  666.199973] [<c01f92fc>] (genl_rcv+0x0/0x2c) from [<c01f8418>] (netlink_unicast+0x154/0x1f4)
[  666.208449]  r4:c785ea00 r3:c01f92fc
[  666.212057] [<c01f82c4>] (netlink_unicast+0x0/0x1f4) from [<c01f8790>] (netlink_sendmsg+0x230/0x2b0)
[  666.221240] [<c01f8560>] (netlink_sendmsg+0x0/0x2b0) from [<c01cccf8>] (sock_sendmsg+0x90/0xa4)
[  666.229986] [<c01ccc68>] (sock_sendmsg+0x0/0xa4) from [<c01cdcb0>] (__sys_sendmsg+0x290/0x298)
[  666.238637]  r9:00000000 r8:c0611ec8 r6:0000002c r5:c0610000 r4:c0611f64
[  666.245411] [<c01cda20>] (__sys_sendmsg+0x0/0x298) from [<c01cf52c>] (sys_sendmsg+0x44/0x6c)
[  666.253897] [<c01cf4e8>] (sys_sendmsg+0x0/0x6c) from [<c00090a0>] (ret_fast_syscall+0x0/0x2c)
[  666.262460]  r6:00000000 r5:beeff96c r4:00000005

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
I abbreviated the OOPS to the (IMHO) important parts, to keep it short
and readable.

 drivers/net/wireless/mwl8k.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 51634f2..3437670 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -334,20 +334,20 @@ struct mwl8k_sta {
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
 static const struct ieee80211_channel mwl8k_channels_24[] = {
-	{ .center_freq = 2412, .hw_value = 1, },
-	{ .center_freq = 2417, .hw_value = 2, },
-	{ .center_freq = 2422, .hw_value = 3, },
-	{ .center_freq = 2427, .hw_value = 4, },
-	{ .center_freq = 2432, .hw_value = 5, },
-	{ .center_freq = 2437, .hw_value = 6, },
-	{ .center_freq = 2442, .hw_value = 7, },
-	{ .center_freq = 2447, .hw_value = 8, },
-	{ .center_freq = 2452, .hw_value = 9, },
-	{ .center_freq = 2457, .hw_value = 10, },
-	{ .center_freq = 2462, .hw_value = 11, },
-	{ .center_freq = 2467, .hw_value = 12, },
-	{ .center_freq = 2472, .hw_value = 13, },
-	{ .center_freq = 2484, .hw_value = 14, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412, .hw_value = 1, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417, .hw_value = 2, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422, .hw_value = 3, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427, .hw_value = 4, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432, .hw_value = 5, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437, .hw_value = 6, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442, .hw_value = 7, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447, .hw_value = 8, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452, .hw_value = 9, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457, .hw_value = 10, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462, .hw_value = 11, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467, .hw_value = 12, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472, .hw_value = 13, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484, .hw_value = 14, },
 };
 
 static const struct ieee80211_rate mwl8k_rates_24[] = {
@@ -368,10 +368,10 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 };
 
 static const struct ieee80211_channel mwl8k_channels_50[] = {
-	{ .center_freq = 5180, .hw_value = 36, },
-	{ .center_freq = 5200, .hw_value = 40, },
-	{ .center_freq = 5220, .hw_value = 44, },
-	{ .center_freq = 5240, .hw_value = 48, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5180, .hw_value = 36, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
 };
 
 static const struct ieee80211_rate mwl8k_rates_50[] = {
-- 
1.7.10.4

