Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18725 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0I1W3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 18:29:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 15:29:40 -0700
Date: Tue, 28 Sep 2010 15:29:45 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <stable@kernel.org>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
Message-ID: <20100928222945.GB10932@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following two patches:

9c87ba6 - mac80211: Fix reassociation processing (within ESS roaming)
e1dd33f - cfg80211: Allow reassociation in associated state

$ git describe --contains 9c87ba6
v2.6.34-rc2~48^2~77^2~6
$ git describe --contains 9c87ba6
v2.6.34-rc2~48^2~77^2~6

Added support for cfg80211/mac80211 to cleanly roam between two BSSes
on an ESS by allowing the station to reassociate to an old AP and
only when that is done drop the old association. What we forgot to
take into consideration is that when we disassociate with the older
AP we may need to transmit frames to that AP and those frames may
actually be intended to go under a different channel and even sometimes
a completely separate band than the new APs. When we TX a frame we
assume the frame we want to TX however will be on the current hardware
configured channel. The channel we would try to send a frame on can
be different than the channel we prepared the bitrates for the peer
on though. What this meant is that upon tearing down a BA agreement
we would try to send a frame to a peer but not find a valid rate for
that peer and generate warnings like the following:

WARNING: at include/net/mac80211.h:2677 rate_control_send_low+0xd3/0x140 [mac80211]()
Hardware name: 6460DWU
Modules linked in: ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 <etc>
Pid: 898, comm: wpa_supplicant Tainted: G        W   2.6.36-rc5-wl+ #254
Call Trace:
 [<ffffffff8105fddf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8105fe3a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa03b8573>] rate_control_send_low+0xd3/0x140 [mac80211]
 [<ffffffffa0192fa8>] ath_get_rate+0x48/0x570 [ath9k]
 [<ffffffff812b8d19>] ? put_dec+0x59/0x60
 [<ffffffffa03b839e>] rate_control_get_rate+0x8e/0x190 [mac80211]
 [<ffffffffa03c27e8>] ieee80211_tx_h_rate_ctrl+0x1a8/0x4e0 [mac80211]
 [<ffffffffa03c2ec0>] invoke_tx_handlers+0x100/0x140 [mac80211]
 [<ffffffffa03c2f85>] ieee80211_tx+0x85/0x240 [mac80211]
 [<ffffffff81479c70>] ? skb_release_data+0xd0/0xe0
 [<ffffffff8147bb0d>] ? pskb_expand_head+0x10d/0x1a0
 [<ffffffffa03c31f6>] ieee80211_xmit+0xb6/0x1d0 [mac80211]
 [<ffffffff81479db3>] ? __alloc_skb+0x83/0x170
 [<ffffffffa03c3364>] ieee80211_tx_skb+0x54/0x70 [mac80211]
 [<ffffffffa03ac0dd>] ieee80211_send_delba+0x11d/0x190 [mac80211]
 [<ffffffffa03adcf0>] ___ieee80211_stop_rx_ba_session+0xf0/0x110 [mac80211]
 [<ffffffffa03add60>] __ieee80211_stop_rx_ba_session+0x50/0x70 [mac80211]
 [<ffffffffa03ac3f3>] ieee80211_sta_tear_down_BA_sessions+0x43/0x50 [mac80211]
 [<ffffffffa03b23c3>] ieee80211_set_disassoc+0x103/0x240 [mac80211]
 [<ffffffffa03b3b2d>] ieee80211_mgd_assoc+0x8d/0x3a0 [mac80211]
 [<ffffffffa03ba66f>] ieee80211_assoc+0x4f/0x80 [mac80211]
 [<ffffffffa011e5b6>] __cfg80211_mlme_assoc+0x1f6/0x240 [cfg80211]
 [<ffffffffa011e68f>] cfg80211_mlme_assoc+0x8f/0xc0 [cfg80211]
 [<ffffffffa010afd0>] ? cfg80211_get_dev_from_ifindex+0x70/0x80 [cfg80211]
 [<ffffffffa011489a>] nl80211_associate+0x23a/0x260 [cfg80211]
 [<ffffffff812c6c6f>] ? nla_parse+0xef/0x110
 [<ffffffff814ad738>] genl_rcv_msg+0x1d8/0x210
 [<ffffffff81475cf4>] ? sock_alloc_send_pskb+0x1d4/0x330
 [<ffffffff814ad560>] ? genl_rcv_msg+0x0/0x210
 [<ffffffff814ac179>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff814ad545>] genl_rcv+0x25/0x40
 [<ffffffff814abdd8>] netlink_unicast+0x2c8/0x2e0
 [<ffffffff814acc30>] netlink_sendmsg+0x250/0x360
 [<ffffffff81472643>] sock_sendmsg+0xf3/0x120
 [<ffffffff81562dbe>] ? _raw_spin_lock+0xe/0x20
 [<ffffffff81471105>] ? move_addr_to_kernel+0x65/0x70
 [<ffffffff8147d168>] ? verify_iovec+0x88/0xe0
 [<ffffffff81472d70>] sys_sendmsg+0x240/0x3a0
 [<ffffffff81151b0a>] ? do_readv_writev+0x1aa/0x1f0
 [<ffffffff815604b0>] ? schedule+0x3c0/0xa00
 [<ffffffff81151b98>] ? vfs_writev+0x48/0x60
 [<ffffffff81151cc1>] ? sys_writev+0x51/0xb0
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b

This can be easily reproduced with the test-roam script [1] and
statically defining the ESS variable with the BSSes of an AP
in 2.4 GHz band and another one on the 5 GHz band.

Since we end up associated to two different APs at the same
time to transmit to either AP consists of an offchannel
operation but today we just lack the state machine to be able
to do this properly so for now just drop those frames. To be
able to detect what frames to drop we keep track of the
peer's channel upon creation and whenever that differs from
the currently operating channel we simply drop the frame
and increment a new debugfs counter:

/sys/kernel/debug/ieee80211/phy0/statistics/tx_handlers_drop_wrong_channel

This should have no impact on existing functionality for frames
we were already dropping but it also does mean we'll drop some more
frames upon disassociation if the AP we are moving away from is on
a different channel on the same band. We now suppress the warning
and acknowledge it, understand the the issue, and understand what
we need to fix in the long run to properly address this.

For more information refer to:

http://code.google.com/p/chromium-os/issues/detail?id=6348
http://marc.info/?l=linux-wireless&m=128401139730423

This patch has a fix for kernels >= v2.6.34. The fix is to supress
the warnings from spewing all over the logs and prevent trying to
send frames on a separate channel on the same band right after
re-association.

[1] http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/test-roam

Cc: stable@kernel.org
Cc: Jouni Malinen <j@w1.fi>
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h     |    2 ++
 net/mac80211/cfg.c         |    7 +++++++
 net/mac80211/debugfs.c     |    2 ++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/tx.c          |   10 ++++++++++
 5 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fe8b9da..bfe4344 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -888,6 +888,7 @@ enum set_key_cmd {
  * or you must take good care to not use such a pointer after a
  * call to your sta_remove callback that removed it.
  *
+ * @channel: the channel this sta belongs to
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
@@ -896,6 +897,7 @@ enum set_key_cmd {
  *	sizeof(void *), size is determined in hw information.
  */
 struct ieee80211_sta {
+	struct ieee80211_channel *channel;
 	u32 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..bfe91a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -584,7 +584,14 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 mask, set;
 
+	/*
+	 * TODO: userspace should pass the band, there is no
+	 * guarantee userspace will have sent this in synch with
+	 * the STA's own same band. For now we assume the currently
+	 * operating channel is on the STA's own band and channel.
+	 */
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sta->sta.channel = local->oper_channel;
 
 	spin_lock_irqsave(&sta->flaglock, flags);
 	mask = params->sta_flags_mask;
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index ebd5b69..6f05921 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -414,6 +414,8 @@ void debugfs_hw_add(struct ieee80211_local *local)
 		local->tx_handlers_drop_wep);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_not_assoc,
 		local->tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_wrong_channel,
+		local->tx_handlers_drop_wrong_channel);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port,
 		local->tx_handlers_drop_unauth_port);
 	DEBUGFS_STATS_ADD(rx_handlers_drop, local->rx_handlers_drop);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 945fbf2..36a2e80 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -854,6 +854,7 @@ struct ieee80211_local {
 	unsigned int tx_handlers_drop_fragment;
 	unsigned int tx_handlers_drop_wep;
 	unsigned int tx_handlers_drop_not_assoc;
+	unsigned int tx_handlers_drop_wrong_channel;
 	unsigned int tx_handlers_drop_unauth_port;
 	unsigned int rx_handlers_drop;
 	unsigned int rx_handlers_queued;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1733dc..f3ac6dd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1174,6 +1174,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	tx->skb = skb;
 	tx->local = local;
 	tx->sdata = sdata;
+	/*
+	 * TODO: This should use tx->sta->sta.channel once we can
+	 * actually rely on the information being accurate.
+	 */
 	tx->channel = local->hw.conf.channel;
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
@@ -1213,6 +1217,12 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	if (!tx->sta)
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
+	if (tx->sta && tx->sta->sta.channel &&
+	    tx->sta->sta.channel->center_freq != tx->channel->center_freq) {
+		I802_DEBUG_INC(local->tx_handlers_drop_wrong_channel);
+		return TX_DROP;
+	}
+
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
 		struct tid_ampdu_tx *tid_tx;
-- 
1.7.0.4

