Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48360 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3LZMCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Dec 2013 07:02:19 -0500
Received: by mail-wi0-f169.google.com with SMTP id j9so4864603wiv.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Dec 2013 04:02:18 -0800 (PST)
From: Peter Wu <lekensteyn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com
Subject: [rt2x00usb] sleeping function called from invalid context at kernel/locking/mutex.c:616
Date: Thu, 26 Dec 2013 13:00:50 +0100
Message-ID: <11195731.87o6OySWVz@al> (sfid-20131226_130223_329708_E7A24D18)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just found this BUG in my kernel log[2]. This Ralink RT5372 USB
adapter (148f:5372) was in AP mode with wireshark (dumpcap) enabled.
Four seconds hereafter, a DHCP client connected so I guess it occurred
during association or authentication. This is almost 3.13-rc5,
v3.13-rc4-256-gb7000ad. .config is available in this repo[1].

Let me know if you need more information. Happy holidays!

Regards,
Peter

PS. the git tree item in MAINTAINERS is broken.

 [1]: https://github.com/Lekensteyn/aur/blob/d8c591b/linux-custom/config
 [2]:

[29055.180376] device wlan1 entered promiscuous mode
[30017.470835] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
[30017.470840] in_atomic(): 0, irqs_disabled(): 0, pid: 432, name: wpa_supplicant
[30017.470843] 4 locks held by wpa_supplicant/432:
[30017.470845]  #0:  (cb_lock){++++++}, at: [<ffffffff8151c3f9>] genl_rcv+0x19/0x40
[30017.470856]  #1:  (genl_mutex){+.+.+.}, at: [<ffffffff8151df02>] genl_rcv_msg+0xc2/0xd0
[30017.470861]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814fdc97>] rtnl_lock+0x17/0x20
[30017.470870]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffffa038efd5>] ieee80211_get_key+0x5/0x2f0 [mac80211]
[30017.470895] CPU: 2 PID: 432 Comm: wpa_supplicant Tainted: G           O 3.13.0-rc4-custom-00256-gb7000ad #1
[30017.470897] Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
[30017.470899]  0000000000000000 ffff880037b87870 ffffffff815da1f9 ffff88019630ea00
[30017.470903]  ffff880037b87880 ffffffff81076a7d ffff880037b878f0 ffffffff815dde6c
[30017.470907]  ffff880037b878b0 ffffffff815e2152 ffff880197cc25c0 0000000000000292
[30017.470911] Call Trace:
[30017.470917]  [<ffffffff815da1f9>] dump_stack+0x4e/0x7a
[30017.470923]  [<ffffffff81076a7d>] __might_sleep+0xed/0x120
[30017.470928]  [<ffffffff815dde6c>] mutex_lock_nested+0x3c/0x400
[30017.470931]  [<ffffffff815e2152>] ? _raw_write_unlock_irqrestore+0x42/0x70
[30017.470936]  [<ffffffff8117a40c>] ? create_object+0x23c/0x2f0
[30017.470940]  [<ffffffffa05d832c>] rt2x00usb_vendor_request_buff+0x3c/0xd0 [rt2x00usb]
[30017.470972]  [<ffffffffa05f61a3>] rt2x00usb_register_multiread+0x33/0x40 [rt2800usb]
[30017.470983]  [<ffffffffa05e1638>] rt2800_get_tkip_seq+0x48/0x80 [rt2800lib]
[30017.471004]  [<ffffffffa038f22b>] ieee80211_get_key+0x25b/0x2f0 [mac80211]
[30017.471024]  [<ffffffffa038efd5>] ? ieee80211_get_key+0x5/0x2f0 [mac80211]
[30017.471034]  [<ffffffff81518f4c>] ? __nlmsg_put+0x6c/0x80
[30017.471062]  [<ffffffffa023c15e>] nl80211_get_key+0x22e/0x380 [cfg80211]
[30017.471075]  [<ffffffffa022c440>] ? cfg80211_testmode_alloc_event_skb+0x30/0x30 [cfg80211]
[30017.471085]  [<ffffffffa0228866>] ? __cfg80211_wdev_from_attrs+0x36/0x1a0 [cfg80211]
[30017.471091]  [<ffffffff8151dc5d>] genl_family_rcv_msg+0x18d/0x370
[30017.471096]  [<ffffffff8151de40>] ? genl_family_rcv_msg+0x370/0x370
[30017.471099]  [<ffffffff8151dece>] genl_rcv_msg+0x8e/0xd0
[30017.471104]  [<ffffffff8151bee9>] netlink_rcv_skb+0xa9/0xc0
[30017.471109]  [<ffffffff8151c408>] genl_rcv+0x28/0x40
[30017.471113]  [<ffffffff8151b88a>] netlink_unicast+0x14a/0x200
[30017.471118]  [<ffffffff8151bc1e>] netlink_sendmsg+0x2de/0x3f0
[30017.471125]  [<ffffffff814d553b>] sock_sendmsg+0x8b/0xc0
[30017.471131]  [<ffffffff8114370f>] ? might_fault+0x5f/0xb0
[30017.471135]  [<ffffffff81143758>] ? might_fault+0xa8/0xb0
[30017.471140]  [<ffffffff8114370f>] ? might_fault+0x5f/0xb0
[30017.471148]  [<ffffffff814e37ae>] ? verify_iovec+0x5e/0xe0
[30017.471156]  [<ffffffff814d5991>] ___sys_sendmsg+0x3d1/0x3e0
[30017.471166]  [<ffffffff81093ebd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[30017.471175]  [<ffffffff811a06f7>] ? mntput_no_expire+0x17/0x160
[30017.471180]  [<ffffffff811a0750>] ? mntput_no_expire+0x70/0x160
[30017.471185]  [<ffffffff811a06f7>] ? mntput_no_expire+0x17/0x160
[30017.471190]  [<ffffffff811a0866>] ? mntput+0x26/0x40
[30017.471197]  [<ffffffff81180c48>] ? __fput+0x178/0x240
[30017.471205]  [<ffffffff814d6bc2>] __sys_sendmsg+0x42/0x80
[30017.471211]  [<ffffffff814d6c12>] SyS_sendmsg+0x12/0x20
[30017.471218]  [<ffffffff815e9bd6>] system_call_fastpath+0x1a/0x1f
[30095.438944] device wlan1 left promiscuous mode

