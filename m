Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58597 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZDVHcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 03:32:25 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240348792.17388.46.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 08:32:22 +0100
Message-Id: <1240385542.3404.5.camel@localhost.localdomain> (sfid-20090422_093231_598757_D89D2AC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I also updated wpa_supplicant and iw to the latest code and assume that
> > no fix in there silently fixed it for me.
> 
> I wouldn't suspect any significant changes there -- for sure not iw :)
> 
> > So we are suspecting that this issue was because of me having 3GB of RAM
> > and running on a 64-bit kernel. Does this makes sense and could be the
> > problem why it kept failing until I unload the iwlagn driver?
> 
> I couldn't say. Nothing here makes much sense to me, unfortunately.

one other weird thing happens now (except wireless-testing tree and
suspend/resume is broken). The first connection attempt fails horribly:

CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
Trying to associate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
Associated with 00:23:ab:xx:xx:xx
CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (auth) [id=2 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
l2_packet_receive - recvfrom: Network is down
Failed to initiate AP scan.
Failed to initiate AP scan.
^CCTRL-EVENT-TERMINATING - signal 2 received

So starting wpa_supplicant does its job fine, then running dhclient I
end up in the disconnect and network down and after that scanning fails.

Killing wpa_supplicant and dhclient and then trying again works fine. So
far I have seen that only after a fresh boot.

Found this one in dmesg:

------------[ cut here ]------------
WARNING: at net/wireless/nl80211.c:205 nl80211_send_wiphy+0x4b/0x988
[cfg80211]()
Hardware name: 7454CTO
Modules linked in: fuse rfcomm sco bnep l2cap binfmt_misc
snd_hda_codec_conexant iwlagn iwlcore snd_hda_intel i2400m_usb
snd_hda_codec i2400m mac80211 uvcvideo snd_pcm btusb snd_timer snd wimax
cfg80211 soundcore bluetooth snd_page_alloc uhci_hcd ehci_hcd [last
unloaded: microcode]
Pid: 3274, comm: wpa_supplicant Tainted: G        W  2.6.30-rc2-wl #1
Call Trace:
 [<ffffffff80236604>] warn_slowpath+0xb1/0xe5
 [<ffffffff8039a44a>] ? extract_buf+0x84/0xe4
 [<ffffffffa0055e04>] nl80211_send_wiphy+0x4b/0x988 [cfg80211]
 [<ffffffff8039a193>] ? mix_pool_bytes_extract+0x147/0x156
 [<ffffffffa004d9f3>] ? __cfg80211_drv_from_info+0x6d/0xe5 [cfg80211]
 [<ffffffffa00569cf>] nl80211_get_wiphy+0x56/0xa2 [cfg80211]
 [<ffffffff804b8582>] genl_rcv_msg+0x198/0x1b9
 [<ffffffff804b83ea>] ? genl_rcv_msg+0x0/0x1b9
 [<ffffffff804b7cad>] netlink_rcv_skb+0x3e/0x91
 [<ffffffff804b83da>] genl_rcv+0x27/0x37
 [<ffffffff804b7759>] netlink_unicast+0x1fe/0x274
 [<ffffffff804b7a66>] netlink_sendmsg+0x297/0x2aa
 [<ffffffff80498c7c>] sock_sendmsg+0xfd/0x120
 [<ffffffff8022da05>] ? enqueue_task_fair+0x145/0x1a2
 [<ffffffff8051cfb5>] ? _spin_unlock_irqrestore+0x2e/0x30
 [<ffffffff8024972a>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8051b16b>] ? schedule+0x18/0x3b
 [<ffffffff8051b2f7>] ? preempt_schedule+0x35/0x5c
 [<ffffffff8051d045>] ? _spin_unlock+0x2c/0x2e
 [<ffffffff8051b77f>] ? __mutex_unlock_slowpath+0x3a/0x3f
 [<ffffffff8051b714>] ? mutex_unlock+0x16/0x18
 [<ffffffff804b03e3>] ? __rtnl_unlock+0x10/0x12
 [<ffffffff80499888>] ? move_addr_to_kernel+0x40/0x49
 [<ffffffff804a16ae>] ? verify_iovec+0x4f/0x8d
 [<ffffffff80498e71>] sys_sendmsg+0x1d2/0x23c
 [<ffffffff804e46ae>] ? inet_ioctl+0x92/0xaa
 [<ffffffff804981de>] ? sock_ioctl+0x1f1/0x21b
 [<ffffffff802a73a0>] ? vfs_ioctl+0x2a/0x78
 [<ffffffff802a782a>] ? do_vfs_ioctl+0x43c/0x478
 [<ffffffff8026d4a1>] ? audit_syscall_entry+0x149/0x175
 [<ffffffff8020af6b>] system_call_fastpath+0x16/0x1b
---[ end trace 414e84dc46400d98 ]---

Regards

Marcel


