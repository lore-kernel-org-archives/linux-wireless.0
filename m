Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60338 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbbAWMcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 07:32:00 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 0477A236A61
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 13:31:59 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3kTKbf5vq5z5vMp
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 13:31:58 +0100 (CET)
Message-ID: <1422016318.1212.22.camel@posteo.de> (sfid-20150123_133204_361815_363026D4)
Subject: brcmfmac: kernel panic in brcmf_cfg80211_del_key
From: =?ISO-8859-1?Q?J=F6rg?= Krause <jkrause@posteo.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 Jan 2015 13:31:58 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm running an wireless device with Linux kernel 3.18.3 and the brcmfmac
driver. When connection the device to my network, I see from time to
time these messages in the kernel log:

[  899.624759] brcmfmac: brcmf_cfg80211_del_key: invalid key index (4)
[  899.649874] brcmfmac: brcmf_cfg80211_del_key: invalid key index (5)
[  899.678066] cfg80211: Calling CRDA to update world regulatory domain

I'm not sure about the meaning of the 'invalid key index' messages and
if it may cause some trouble. However the system is running fine.

Now I had a test case with two wireless devices having the same hostname
and MAC address in the same network.

The first wireless devices connects to the network and starts receiving
an audio stream via UDP. Another device with same hostname and MAC is
started after this and repeatedly reboots after 30 seconds.

The first device gets disconnected after the second device connects to
the network. The device is running with the network tools tools
wpa_supplicant, a wpa_action script, udhcpc, avahi, and crda. The device
tries to reconnect to the network. It successfully connects, but
authentification fails. This step produces a lot of the kernel messages
from above.

Okay, nothing wrong until here I think. But after some time the brcmfmac
driver is dying:

[  901.799454] ------------[ cut here ]------------
[  901.804332] WARNING: CPU: 0 PID: 104 at
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:1076
brcmf_netdev_wait_pend8021x+0xe0/0xf4 [brcmfmac]()
[  901.866565] Modules linked in:
[  901.907705] 	brcmfmac brcmutil
[  901.909298] CPU: 0 PID: 104 Comm: wpa_supplicant Not tainted 3.18.3
#1
[  901.959287] [<c000de40>] (unwind_backtrace) from [<c000c1f4>]
(show_stack+0x10/0x14)
[  901.993628] [<c000c1f4>] (show_stack) from [<c0016400>]
(warn_slowpath_common+0x68/0x88)
[  902.016243] [<c0016400>] (warn_slowpath_common) from [<c00164bc>]
(warn_slowpath_null+0x1c/0x24)
[  902.040249] [<c00164bc>] (warn_slowpath_null) from [<bf016304>]
(brcmf_netdev_wait_pend8021x+0xe0/0xf4 [brcmfmac])
[  902.067408] [<bf016304>] (brcmf_netdev_wait_pend8021x [brcmfmac])
from [<bf0061d8>] (brcmf_cfg80211_get_key+0x1a8/0x374 [brcmfmac])
[  902.098434] [<bf0061d8>] (brcmf_cfg80211_get_key [brcmfmac]) from
[<bf00770c>] (brcmf_cfg80211_del_key+0x1d8/0x2e0 [brcmfmac])
[  902.164527] [<bf00770c>] (brcmf_cfg80211_del_key [brcmfmac]) from
[<bf0078ec>] (brcmf_cfg80211_add_key+0xd8/0x248 [brcmfmac])
[  902.213096] [<bf0078ec>] (brcmf_cfg80211_add_key [brcmfmac]) from
[<c037f368>] (nl80211_new_key+0x108/0x144)
[  902.253581] [<c037f368>] (nl80211_new_key) from [<c02ccb98>]
(genl_rcv_msg+0x22c/0x39c)
[  902.290997] [<c02ccb98>] (genl_rcv_msg) from [<c02cc12c>]
(netlink_rcv_skb+0xb4/0xd8)
[  902.325813] [<c02cc12c>] (netlink_rcv_skb) from [<c02cc958>]
(genl_rcv+0x20/0x34)
[  902.363540] [<c02cc958>] (genl_rcv) from [<c02cbaa8>]
(netlink_unicast+0x14c/0x1cc)
[  902.399402] [<c02cbaa8>] (netlink_unicast) from [<c02cbe98>]
(netlink_sendmsg+0x2b8/0x39c)
[  902.435798] [<c02cbe98>] (netlink_sendmsg) from [<c0297860>]
(sock_sendmsg+0x84/0xa8)
[  902.477184] [<c0297860>] (sock_sendmsg) from [<c0298d28>]
(___sys_sendmsg.part.32+0x284/0x290)
[  902.486197] [<c0298d28>] (___sys_sendmsg.part.32) from [<c0299d34>]
(__sys_sendmsg+0x4c/0x7c)
[  902.555011] [<c0299d34>] (__sys_sendmsg) from [<c0009620>]
(ret_fast_syscall+0x0/0x44)
[  902.591178] ---[ end trace 93a9f5360e80c5ca ]---

I'm not sure if I should worry about this issue.

Best regards
Jörg Krause

