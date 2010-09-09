Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47900 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab0IIFtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:49:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:49:50 -0700
Date: Wed, 8 Sep 2010 22:49:58 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: warning at rate_control_send_low+0xd3/0x140
Message-ID: <20100909054958.GA9045@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing the following warning while roaming to APs operating on
different bands.

[ 9033.238676] Call Trace:
[ 9033.238684]  [<ffffffff81064f8b>] warn_slowpath_common+0x7b/0xc0
[ 9033.238688]  [<ffffffff81064fe4>] warn_slowpath_null+0x14/0x20
[ 9033.238697]  [<ffffffffa0558233>] rate_control_send_low+0xd3/0x140 [mac80211]
[ 9033.238704]  [<ffffffffa059a9e8>] ath_get_rate+0x48/0x570 [ath9k]
[ 9033.238709]  [<ffffffff812b3a9c>] ? put_dec+0x10c/0x110
[ 9033.238712]  [<ffffffff812b3d8e>] ? number+0x2ee/0x320
[ 9033.238721]  [<ffffffffa055805e>] rate_control_get_rate+0x8e/0x190 [mac80211]
[ 9033.238730]  [<ffffffffa056191c>] invoke_tx_handlers+0xa4c/0x1220 [mac80211]
[ 9033.238735]  [<ffffffff812b6000>] ? vsnprintf+0x1d0/0x5f0
[ 9033.238744]  [<ffffffffa0562175>] ieee80211_tx+0x85/0x240 [mac80211]
[ 9033.238749]  [<ffffffff814680d0>] ? skb_release_data+0xd0/0xe0
[ 9033.238752]  [<ffffffff81469fa2>] ? pskb_expand_head+0x152/0x1e0
[ 9033.238762]  [<ffffffffa05623e0>] ieee80211_xmit+0xb0/0x1c0 [mac80211]
[ 9033.238765]  [<ffffffff81468210>] ? __alloc_skb+0x80/0x190
[ 9033.238774]  [<ffffffffa0562544>] ieee80211_tx_skb+0x54/0x70 [mac80211]
[ 9033.238782]  [<ffffffffa054d26d>] ieee80211_send_delba+0x11d/0x190 [mac80211]
[ 9033.238791]  [<ffffffffa054e779>] ___ieee80211_stop_rx_ba_session+0x119/0x140 [mac80211]
[ 9033.238799]  [<ffffffffa054e7f0>] __ieee80211_stop_rx_ba_session+0x50/0x70 [mac80211]
[ 9033.238807]  [<ffffffffa054d583>] ieee80211_sta_tear_down_BA_sessions+0x43/0x50 [mac80211]
[ 9033.238815]  [<ffffffffa055276b>] ieee80211_set_disassoc+0x10b/0x220 [mac80211]
[ 9033.238820]  [<ffffffff811520c6>] ? pollwake+0x56/0x60
[ 9033.238829]  [<ffffffffa0553e1d>] ieee80211_mgd_assoc+0x8d/0x360 [mac80211]
[ 9033.238838]  [<ffffffffa055a34f>] ieee80211_assoc+0x4f/0x80 [mac80211]
[ 9033.238855]  [<ffffffffa0521186>] __cfg80211_mlme_assoc+0x206/0x290 [cfg80211]
[ 9033.238863]  [<ffffffffa052129f>] cfg80211_mlme_assoc+0x8f/0xc0 [cfg80211]
[ 9033.238869]  [<ffffffffa050e0a0>] ? cfg80211_get_dev_from_ifindex+0x70/0x80 [cfg80211]
[ 9033.238877]  [<ffffffffa0517924>] nl80211_associate+0x224/0x240 [cfg80211]
[ 9033.238882]  [<ffffffff814978c6>] genl_rcv_msg+0x1e6/0x220
[ 9033.238886]  [<ffffffff814976e0>] ? genl_rcv_msg+0x0/0x220
[ 9033.238890]  [<ffffffff814965f9>] netlink_rcv_skb+0xa9/0xd0
[ 9033.238893]  [<ffffffff814976cc>] genl_rcv+0x2c/0x40
[ 9033.238896]  [<ffffffff8149625e>] netlink_unicast+0x2de/0x2f0
[ 9033.238900]  [<ffffffff8149704e>] netlink_sendmsg+0x1fe/0x2e0
[ 9033.238903]  [<ffffffff814961c9>] ? netlink_unicast+0x249/0x2f0
[ 9033.238908]  [<ffffffff8146121b>] sock_sendmsg+0x10b/0x140
[ 9033.238912]  [<ffffffff81083580>] ? autoremove_wake_function+0x0/0x40
[ 9033.238917]  [<ffffffff81059422>] ? default_wake_function+0x12/0x20
[ 9033.238922]  [<ffffffff81049f29>] ? __wake_up_common+0x59/0x90
[ 9033.238925]  [<ffffffff81460774>] ? move_addr_to_kernel+0x64/0x70
[ 9033.238929]  [<ffffffff8146b969>] ? verify_iovec+0x69/0xc0
[ 9033.238932]  [<ffffffff81461683>] sys_sendmsg+0x233/0x3a0
[ 9033.238935]  [<ffffffff810517d3>] ? __wake_up+0x53/0x70
[ 9033.238939]  [<ffffffff81140132>] ? vfs_write+0x132/0x1a0
[ 9033.238942]  [<ffffffff81140951>] ? sys_write+0x51/0x80
[ 9033.238947]  [<ffffffff810131f2>] system_call_fastpath+0x16/0x1b
[ 9033.238950] ---[ end trace 5655896580a8ccea ]---

This happens because the station tries to close its BACK negotiation
with the existing AP but on a channel where it got authenticated
with a newer AP. ieee80211_work_work() configures the station back
to its operating channel after the authentication with the new AP,
but sometimes we get assoc req before this. One (may be not good)fix
can be making sure if station is in operating channel before
cleaning up its BACK state. Not quite sure about a clean fix here.

Thanks,

Vasanth
