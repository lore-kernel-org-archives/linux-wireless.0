Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZFJUfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:35:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Subject: [PATCH] mac80211: disassociate when switching bands and not scanning
Date: Wed, 10 Jun 2009 16:35:31 -0400
Message-Id: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we're associated to an AP and we manually decide to switch
bands we have no guarantee we can communicate with that AP
on the new band and our current bss parameters may change
completely so disassociate.

This fixes this warning (which is not specific to iwlwifi!):

[25612.559460] ------------[ cut here ]------------
[25612.559500] WARNING: at include/net/mac80211.h:2127 rate_control_send_low+0xcf/0xe0 [mac80211]()
[25612.559508] Hardware name: VGN-N170G
[25612.559513] Modules linked in: ath9k ath mac80211 cfg80211 <bleh line cut>
[25612.559807] Pid: 14492, comm: iwconfig Not tainted 2.6.30-rc8-wl #11
[25612.559814] Call Trace:
[25612.559829]  [<c03b2cd9>] ? printk+0x18/0x1f
[25612.559865]  [<f831072f>] ? rate_control_send_low+0xcf/0xe0 [mac80211]
[25612.559878]  [<c0134f4c>] warn_slowpath_common+0x6c/0xc0
[25612.559912]  [<f831072f>] ? rate_control_send_low+0xcf/0xe0 [mac80211]
[25612.559923]  [<c0134fb5>] warn_slowpath_null+0x15/0x20
[25612.559957]  [<f831072f>] rate_control_send_low+0xcf/0xe0 [mac80211]
[25612.559985]  [<f84129c3>] ath_get_rate+0x33/0x520 [ath9k]
[25612.559998]  [<c015cb73>] ? mark_held_locks+0x63/0x80
[25612.560064]  [<f831057d>] rate_control_get_rate+0xbd/0xd0 [mac80211]
[25612.560102]  [<f8318b6f>] invoke_tx_handlers+0x5df/0xfa0 [mac80211]
[25612.560115]  [<c015cb73>] ? mark_held_locks+0x63/0x80
[25612.560152]  [<f8317854>] ? __ieee80211_tx_prepare+0x194/0x3b0 [mac80211]
[25612.560190]  [<f8319796>] ieee80211_tx+0xd6/0x280 [mac80211]
[25612.560227]  [<f831972f>] ? ieee80211_tx+0x6f/0x280 [mac80211]
[25612.560265]  [<f8319e39>] ieee80211_master_start_xmit+0x1f9/0x400 [mac80211]
[25612.560280]  [<c032347b>] dev_hard_start_xmit+0x2ab/0x340
[25612.560292]  [<c0323230>] ? dev_hard_start_xmit+0x60/0x340
[25612.560304]  [<c0335675>] __qdisc_run+0x1e5/0x240
[25612.560316]  [<c03245d7>] dev_queue_xmit+0x377/0x4e0
[25612.560328]  [<c0324298>] ? dev_queue_xmit+0x38/0x4e0
[25612.560365]  [<f831c1d2>] ieee80211_tx_skb+0x52/0x60 [mac80211]
[25612.560400]  [<f83079d0>] ieee80211_send_delba+0xf0/0x150 [mac80211]
[25612.560413]  [<c013f931>] ? del_timer_sync+0x81/0xb0
[25612.560447]  [<f830903a>] __ieee80211_stop_rx_ba_session+0xea/0x1d0 [mac80211]
[25612.560476]  [<f8409310>] ? ath9k_ampdu_action+0x0/0x130 [ath9k]
[25612.560511]  [<f8307a63>] ieee80211_sta_tear_down_BA_sessions+0x33/0x40 [mac80211]
[25612.560548]  [<f830afd8>] ieee80211_set_disassoc+0xc8/0x370 [mac80211]
[25612.560583]  [<f830af10>] ? ieee80211_set_disassoc+0x0/0x370 [mac80211]
[25612.560597]  [<c01ace6b>] ? might_fault+0x4b/0xa0
[25612.560632]  [<f830b580>] ieee80211_sta_req_auth+0xa0/0xc0 [mac80211]
[25612.560665]  [<f8303fde>] ieee80211_ioctl_siwessid+0xbe/0xd0 [mac80211]
[25612.560679]  [<c02749c5>] ? copy_from_user+0x35/0x130
[25612.560694]  [<c039d819>] ioctl_standard_call+0x199/0x3a0
[25612.560707]  [<c032358d>] ? __dev_get_by_name+0x7d/0xa0
[25612.560720]  [<c039d31f>] wext_handle_ioctl+0x14f/0x230
[25612.560753]  [<f8303f20>] ? ieee80211_ioctl_siwessid+0x0/0xd0 [mac80211]
[25612.560766]  [<c0324114>] dev_ioctl+0x474/0x540
[25612.560780]  [<c019f685>] ? __pagevec_free+0x25/0x30
[25612.560794]  [<c0312350>] ? sock_ioctl+0x0/0x270
[25612.560806]  [<c0312445>] sock_ioctl+0xf5/0x270
[25612.560817]  [<c0312350>] ? sock_ioctl+0x0/0x270
[25612.560831]  [<c01d9018>] vfs_ioctl+0x28/0x90
[25612.560843]  [<c01d90f2>] do_vfs_ioctl+0x72/0x590
[25612.560856]  [<c015ce8b>] ? trace_hardirqs_on+0xb/0x10
[25612.560868]  [<c01b2a16>] ? remove_vma+0x56/0x70
[25612.560879]  [<c01b2a16>] ? remove_vma+0x56/0x70
[25612.560890]  [<c01b38f7>] ? do_munmap+0x237/0x290
[25612.560902]  [<c0103021>] ? sysenter_exit+0xf/0x1a
[25612.560914]  [<c01d9673>] sys_ioctl+0x63/0x70
[25612.560925]  [<c0102fec>] sysenter_do_call+0x12/0x38
[25612.560934] ---[ end trace 05e1ecc810d6b568 ]---
[25612.561114] ------------[ cut here ]------------

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Mohamed Abbas <mohamed.abbas@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/util.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 66ce96a..8e66556 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -791,9 +791,24 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 
 		if (local->sw_scanning || local->hw_scanning)
 			ret = 0;
-		else
+		else {
+			struct ieee80211_channel *cur_chan;
+
+			cur_chan = local->hw.conf.channel;
+
+			/*
+			 * If we're switching bands and not scanning we
+			 * could potentially be moving to a band our AP
+			 * does not understand so give up on it
+			 */
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+			    (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) &&
+			    cur_chan->band != chan->band)
+				ieee80211_sta_deauthenticate(sdata,
+					WLAN_REASON_DEAUTH_LEAVING);
 			ret = ieee80211_hw_config(
 				local, IEEE80211_CONF_CHANGE_CHANNEL);
+		}
 	}
 
 	return ret;
-- 
1.5.6.3

