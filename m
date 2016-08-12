Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37088 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbcHLOgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 10:36:03 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 5F87440AC0B
	for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 07:36:01 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: ath10k crash due to bad memory access in 4.7
Message-ID: <57ADDED1.1090502@candelatech.com> (sfid-20160812_163655_262241_F4447D7D)
Date: Fri, 12 Aug 2016 07:36:01 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am seeing this in my 4.7 kernel while debugging QCA 9884 firmware that
is crashing very often.  Looks like this must exacerbate some race condition,
as ar->txqs appears to have entries in it that have been deleted already.

Just in case someone has already worked on this, please let me know.  I'll
keep hacking on the problem in the meantime...

(gdb) l *(ath10k_mac_tx_push_pending+0x143)
0x147e3 is in ath10k_mac_tx_push_pending (/home/greearb/git/linux-4.7.dev.y/drivers/net/wireless/ath/ath10k/mac.c:4230).
4225			return true;
4226	
4227		if (ar->htt.num_pending_tx < ar->htt.tx_q_state.num_push_allowed)
4228			return true;
4229	
4230		if (artxq->num_fw_queued < artxq->num_push_allowed)
4231			return true;
4232	
4233		return false;
4234	}


==================================================================
BUG: KASAN: use-after-free in ath10k_mac_tx_push_pending+0x143/0x310 [ath10k_core] at addr ffff8801d3137130
Read of size 8 by task ksoftirqd/0/3
=============================================================================
BUG kmalloc-2048 (Tainted: G        W      ): kasan: bad access detected
-----------------------------------------------------------------------------
INFO: Allocated in sta_info_alloc+0x33c/0x820 [mac80211] age=12766 cpu=1 pid=3548
	___slab_alloc+0x480/0x4b0
	__slab_alloc.isra.62+0x26/0x40
	__kmalloc+0x17c/0x1e0
	sta_info_alloc+0x33c/0x820 [mac80211]
	ieee80211_prep_connection+0x140/0xf80 [mac80211]
	ieee80211_mgd_auth+0x3d2/0x670 [mac80211]
	ieee80211_auth+0x13/0x20 [mac80211]
	cfg80211_mlme_auth+0x1db/0x380 [cfg80211]
	nl80211_authenticate+0x54b/0x5f0 [cfg80211]
	genl_family_rcv_msg+0x3b7/0x600
	genl_rcv_msg+0xbf/0xf0
	netlink_rcv_skb+0x14d/0x180
	genl_rcv+0x23/0x40
	netlink_unicast+0x2ce/0x390
	netlink_sendmsg+0x54c/0x680
	sock_sendmsg+0x6f/0x80
INFO: Freed in sta_info_free+0xbb/0x120 [mac80211] age=409 cpu=4 pid=291
	__slab_free+0x17a/0x2d0
	kfree+0x18d/0x1a0
	sta_info_free+0xbb/0x120 [mac80211]
	__sta_info_destroy_part2+0x1eb/0x2b0 [mac80211]
	__sta_info_flush+0x1fb/0x2f0 [mac80211]
	ieee80211_set_disassoc+0x103/0x480 [mac80211]
	ieee80211_sta_connection_lost+0x8b/0xe0 [mac80211]
	ieee80211_sta_work+0xb3a/0x22e0 [mac80211]
	ieee80211_iface_work+0x466/0x500 [mac80211]
	process_one_work+0x2b8/0x7f0
	worker_thread+0x87/0x820
	kthread+0x164/0x190
	ret_from_fork+0x1f/0x40

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

