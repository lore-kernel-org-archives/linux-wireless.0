Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0JAVFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:05:22 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 0/3] mac80211: fix rate_control_send_low warnings for delbas
Date: Fri,  1 Oct 2010 17:05:18 -0400
Message-Id: <1285967121-16665-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this v3 is the same as v2, I just trimmed the CC list as I was
not seeing the patches posted to linux-wireless. Please use the v3
thread for comments.

The following two patches:

9c87ba6 - mac80211: Fix reassociation processing (within ESS roaming)
e1dd33f - cfg80211: Allow reassociation in associated state

$ git describe --contains 9c87ba6
v2.6.34-rc2~48^2~77^2~6
$ git describe --contains 9c87ba6
v2.6.34-rc2~48^2~77^2~6

Added support for cfg80211/mac80211 to cleanly roam between two BSSes
on an ESS by allowing the station to authenticate to two APS at the
same time, and when an association comes in for the new AP we first
disassociate from the old AP and then associate with the new one.

What we forgot to take into consideration is that when we disassociate
with the older AP we may need to transmit frames to that AP and those
frames may actually be intended to go under a different channel and
even sometimes a completely separate band than the new APs. When we
TX a frame we assume the frame we want to TX however will be on the
current hardware configured channel. The channel we would try to
send a frame on can be different than the channel we prepared the
bitrates for the peer on though. What this meant is that upon tearing
down a BA agreement we would try to send a frame to a peer but not
find a valid rate for that peer and generate warnings like the
following:

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

Since we end up authenticate to two different APs at the same
time to transmit to the new AP consists of an offchannel
operation and while mac80211 does have a state machine for this
it assumes we don't transmit on our operating channel within
each work item. If we do need to transmit to on the operating
channel each work item needs to put us on the home channel for
that operation as we also use the operatin channel as the target
channel for the skb we are going to transmit. This series
addresses this by addressing a series of possible races on the
frame's set channel, prevening us from associating to a new AP
if we were previously associated and haven't yet associated,
and ensuring we transmit the disassocation on the operating
channel.

For more information refer to:

http://code.google.com/p/chromium-os/issues/detail?id=6348
http://marc.info/?l=linux-wireless&m=128401139730423

This patch series has a fix for kernels >= v2.6.34. The fix will
actually cure the warnings correctly, it ensures we tear down our
BA agreements with our old APs prior to moving away from them and
ensures we transmit those frames on the intended channel.

[1] http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/test-roam

Luis R. Rodriguez (3):
  mac80211: fix channel assumption for association done work
  mac80211: wait until completely disassociated before new association
  mac80211: move to the home channel for disassociation when roaming

 net/mac80211/mlme.c |   18 ++++++++++++++----
 net/mac80211/work.c |   14 ++++++++++++++
 2 files changed, 28 insertions(+), 4 deletions(-)

