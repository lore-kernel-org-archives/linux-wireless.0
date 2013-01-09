Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f177.google.com ([209.85.210.177]:53073 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3AIRhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:37:02 -0500
Received: by mail-ia0-f177.google.com with SMTP id h8so1127182iaa.36
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 09:37:01 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] mac80211: add encrypt headroom to PERR frames
Date: Wed,  9 Jan 2013 12:34:56 -0500
Message-Id: <1357752896-17497-2-git-send-email-me@bobcopeland.com> (sfid-20130109_183709_341747_55752604)
In-Reply-To: <1357752896-17497-1-git-send-email-me@bobcopeland.com>
References: <1357752896-17497-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh PERR action frames are robust and thus may be encrypted, so add
proper head/tailroom to allow this.  Fixes this warning when operating
a Mesh STA on ath5k:

[  220.838908] WARNING: at
/devel/compat-drivers-3.7-rc1-6-noHT5Gig/net/mac80211/wpa.c:427
ccmp_encrypt_skb.isra.5+0x7b/0x1a0 [mac80211]()
[  221.532067] Call Trace:
[  221.546693]  [<c011c5e7>] warn_slowpath_common+0x63/0x78
[  221.578517]  [<e090621d>] ? ccmp_encrypt_skb.isra.5+0x7b/0x1a0 [mac80211]
[  221.619159]  [<c011c60b>] warn_slowpath_null+0xf/0x13
[  221.649433]  [<e090621d>] ccmp_encrypt_skb.isra.5+0x7b/0x1a0 [mac80211]
[  221.689055]  [<e092a3f7>] ? minstrel_ht_get_rate+0x23/0x276 [mac80211]
[  221.728134]  [<c034dc3c>] ? kfree_skb+0x24/0x26
[  221.755296]  [<e090e151>] ? rate_control_get_rate+0x8d/0x202 [mac80211]
[  221.794907]  [<e090685c>] ieee80211_crypto_ccmp_encrypt+0x1f/0x37
[mac80211]
[  221.837127]  [<e0917113>] invoke_tx_handlers+0xcad/0x10bd [mac80211]
[  221.875186]  [<e0915335>] ? ieee80211_prepare_and_rx_handle+0x7dd/0x85b
[mac80211]
[  221.920523]  [<e0917665>] ieee80211_tx+0x87/0xb3 [mac80211]
[  221.953904]  [<e0918932>] ieee80211_tx_pending+0xcc/0x170 [mac80211]
[  221.991939]  [<c0121c43>] tasklet_action+0x3e/0x65
[  222.020635]  [<c0121e0d>] __do_softirq+0x75/0x104
[  222.048786]  [<c0121d98>] ? send_remote_softirq+0x22/0x22
[  222.081096]  <IRQ>  [<c0121f4c>] ? irq_exit+0x34/0x8a
[  222.111410]  [<c010349f>] ? do_IRQ+0x76/0x89
[  222.136939]  [<c03f8f2c>] ? common_interrupt+0x2c/0x31
[  222.167668]  [<c015007b>] ? audit_receive+0x20e/0x834
[  222.197927]  [<c01073cb>] ? default_idle+0x21/0x3b
[  222.226623]  [<c0107a5b>] ? cpu_idle+0x3f/0x72
[  222.253197]  [<c03ed717>] ? rest_init+0x63/0x65
[  222.280332]  [<c05288bc>] ? start_kernel+0x297/0x29c
[  222.310017]  [<c05282ae>] ? i386_start_kernel+0x78/0x7d
[  222.341261] ---[ end trace 958482fcd072de83 ]---

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_hwmp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 4cdf286..040418a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -250,11 +250,13 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		return -EAGAIN;
 
 	skb = dev_alloc_skb(local->tx_headroom +
+			    IEEE80211_ENCRYPT_HEADROOM +
+			    IEEE80211_ENCRYPT_TAILROOM +
 			    hdr_len +
 			    2 + 15 /* PERR IE */);
 	if (!skb)
 		return -1;
-	skb_reserve(skb, local->tx_headroom);
+	skb_reserve(skb, local->tx_headroom + IEEE80211_ENCRYPT_HEADROOM);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
 	memset(mgmt, 0, hdr_len);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-- 
1.7.10.4

