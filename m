Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:59761 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0DKUbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 16:31:23 -0400
Received: from basil.firstfloor.org (p5B3C956C.dip0.t-ipconnect.de [91.60.149.108])
	by one.firstfloor.org (Postfix) with ESMTP id 5300C20C80B4
	for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 22:31:19 +0200 (CEST)
Date: Sun, 11 Apr 2010 22:31:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-wireless@vger.kernel.org
Subject: rtl8185 regression in 2.6.34-rc3 + git vs 2.6.33
Message-ID: <20100411203118.GA12888@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Seeing this in recent git with a 

06:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 IEEE 802.11a/b/g Wireless LAN Controller (rev 20)

First (sorry this a bit vague) -- the card seems to have
trouble now to associate on first try at boot. The SUSE network
init script doesn't get an IP address because it doesn't
associate. After booting when I restart the interface
manually this works. 

I haven't seen that in 2.6.33 with the same setup, so it 
could be a regression?

Log: (I'm not sure why it says deauthenticating, this
is the first output with "wlan0" at boot so it really should not be 
authenticated in the first place)

ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: deauthenticating from 00:1f:3f:1d:54:46 by local choice (reason=3)
wlan0: authenticate with 00:1f:3f:1d:54:46 (try 1)
wlan0: authenticate with 00:1f:3f:1d:54:46 (try 2)
wlan0: authenticate with 00:1f:3f:1d:54:46 (try 3)
wlan0: authentication with 00:1f:3f:1d:54:46 timed out
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 1)
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 2)
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 3)
wlan0: direct probe to 00:1f:3f:1d:54:46 timed out
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 1)
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 2)
wlan0: direct probe to 00:1f:3f:1d:54:46 (try 3)
wlan0: direct probe to 00:1f:3f:1d:54:46 timed out

...
only works after manual interface restart.

Then after some time I've also seen this WARN_ON.
This was shortly after the restart

ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
wlan0: authenticate with 00:1f:3f:1d:54:46 (try 1)
wlan0: authenticated
wlan0: associate with 00:1f:3f:1d:54:46 (try 1)
wlan0: associate with 00:1f:3f:1d:54:46 (try 2)
wlan0: associate with 00:1f:3f:1d:54:46 (try 3)
wlan0: association with 00:1f:3f:1d:54:46 timed out
------------[ cut here ]------------
WARNING: at /home/lsrc/linux-2.6.34-rc3-git/net/wireless/mlme.c:340 cfg80211_send_assoc_timeout+0xf4/0x10a [cfg80211]()
Hardware name: Studio XPS 8000
Modules linked in: sha256_generic snd_pcm_oss snd_mixer_oss autofs4 netconsole binfmt_misc snd_seq snd_seq_device cpufreq_conservative cryptd aes_x86_64 aes_generic ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables fuse dm_crypt usblp pl2303 snd_hda_codec_atihdmi arc4 snd_hda_codec_realtek ecb snd_hda_intel snd_hda_codec rtl8180 mac80211 usbserial eeprom_93cx6 kvm_intel snd_hwdep cfg80211 i2c_i801 snd_pcm snd_timer rfkill snd snd_page_alloc kvm
Pid: 3304, comm: phy0 Tainted: G        W  2.6.34-rc3-BASIL #2
Call Trace:
 [<ffffffffa00bab01>] ? cfg80211_send_assoc_timeout+0xf4/0x10a [cfg80211]
 [<ffffffffa00bab01>] ? cfg80211_send_assoc_timeout+0xf4/0x10a [cfg80211]
 [<ffffffff81036b41>] ? warn_slowpath_common+0x77/0xa3
 [<ffffffffa00bab01>] ? cfg80211_send_assoc_timeout+0xf4/0x10a [cfg80211]
 [<ffffffffa010fbe1>] ? ieee80211_assoc_done+0x65/0x94 [mac80211]
 [<ffffffffa0111cae>] ? ieee80211_work_work+0xde8/0xe4a [mac80211]
 [<ffffffff8103048f>] ? finish_task_switch+0x3d/0xb1
 [<ffffffff8104a6be>] ? worker_thread+0x181/0x20f
 [<ffffffffa0110ec6>] ? ieee80211_work_work+0x0/0xe4a [mac80211]
 [<ffffffff8104dc08>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8104a53d>] ? worker_thread+0x0/0x20f
 [<ffffffff8104d805>] ? kthread+0x79/0x81
 [<ffffffff81003694>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8104d78c>] ? kthread+0x0/0x81
 [<ffffffff81003690>] ? kernel_thread_helper+0x0/0x10
---[ end trace b691569fa3a65330 ]---
wlan0: deauthenticating from 00:1f:3f:1d:54:46 by local choice (reason=3)
wlan0: authenticate with 00:1f:3f:1d:54:46 (try 1)
wlan0: authenticated
wlan0: associate with 00:1f:3f:1d:54:46 (try 1)
wlan0: RX AssocResp from 00:1f:3f:1d:54:46 (capab=0x431 status=0 aid=3)
wlan0: associated


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
