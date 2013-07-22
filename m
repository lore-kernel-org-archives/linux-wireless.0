Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:53669 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3GVMFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:05:19 -0400
Received: from jahnavil.jahnavil ([192.168.40.41])
	(authenticated user jahnavi.meher@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 22 Jul 2013 17:35:16 +0530
Message-ID: <51ED6D4E.1010303@redpinesignals.com> (sfid-20130722_140529_971103_7CC2E11E)
Date: Mon, 22 Jul 2013 23:05:10 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Disassociation immediately after joining AP - mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I am working in the station mode, using mac80211 in kernel 3.5.4. When I 
am trying to connect to the AP, station sends disassociation request 
with reason code 3 (deauthenticated because sending station is leaving) 
immediately after receiving association response.
Initially I received some IPv6 packets from mac80211 to transmit. I then 
disabled IPv6 by adding the line net.ipv6.conf.all.disable_ipv6 = 1 in 
/etc/sysctl.conf file. Then no packets are received from mac80211, only 
disassociation request is received.
This behaviour is persistent across channels in 2.4ghz.

The call trace when the disassociation request is received is as follows:

/// dump start ///
wlan2: RX AssocResp from 00:16:b6:d1:2c:16 (capab=0x401 status=0 aid=3)
wlan2: disassociating from 00:16:b6:d1:2c:16 by local choice (reason=3)

Call Trace:
  [<f985234d>] __ieee80211_tx+0x18d/0x300 [mac80211]
  [<f985423b>] ieee80211_tx+0xbb/0xf0 [mac80211]
  [<f98542fc>] ieee80211_xmit+0x8c/0xf0 [mac80211]
  [<f98552c1>] ieee80211_tx_skb_tid+0x51/0x60 [mac80211]
  [<f9869fd1>] ieee80211_send_deauth_disassoc+0x101/0x110 [mac80211]
  [<f986b54c>] ieee80211_set_disassoc+0x2cc/0x440 [mac80211]
  [<c094fcbe>] ? printk+0x4d/0x4f
  [<f986f530>] ieee80211_mgd_disassoc+0xd0/0x140 [mac80211]
  [<f9848fde>] ieee80211_disassoc+0x2e/0x40 [mac80211]
  [<f81e873f>] cfg80211_mlme_disassoc+0xaf/0xe0 [cfg80211]
  [<f81db468>] nl80211_disassociate+0xc8/0xf0 [cfg80211]
  [<f81dbec0>] ? nl80211_set_wiphy+0x630/0x630 [cfg80211]
  [<c088c784>] genl_rcv_msg+0x1e4/0x260
  [<c053d215>] ? __kmalloc_track_caller+0x185/0x1e0
  [<c088c5a0>] ? genl_rcv+0x30/0x30
  [<c088c01e>] netlink_rcv_skb+0x8e/0xb0
  [<c088c58c>] genl_rcv+0x1c/0x30
  [<c088ba54>] netlink_unicast+0x174/0x1f0
  [<c088bcb8>] netlink_sendmsg+0x1e8/0x310
  [<c0854e7f>] sock_sendmsg+0xff/0x120
  [<c04ffad7>] ? __generic_file_aio_write+0x257/0x4d0
  [<c06718e2>] ? _copy_from_user+0x42/0x60
  [<c08604f4>] ? verify_iovec+0x44/0xb0
  [<c08562d2>] __sys_sendmsg+0x262/0x270
  [<c05ac560>] ? ext4_file_write+0xb0/0x270
  [<c0545bc4>] ? do_sync_write+0xb4/0xf0
  [<c057c748>] ? fsnotify+0x198/0x250
  [<c08570eb>] sys_sendmsg+0x3b/0x60
  [<c0857793>] sys_socketcall+0x283/0x2e0
  [<c04b8484>] ? __audit_syscall_entry+0xb4/0x2b0
  [<c095fc9f>] sysenter_do_call+0x12/0x28

/// dump end ///


Thanks in advance.

Regards,
Jahnavi

