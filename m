Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2EFXbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 19:31:04 -0400
Received: by yenm10 with SMTP id m10so3297568yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 16:31:03 -0700 (PDT)
Message-ID: <4FA709B3.4030404@lwfinger.net> (sfid-20120507_013142_770353_2222358C)
Date: Sun, 06 May 2012 18:30:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: WARNING: at net/mac80211/iface.c:162
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am getting the following warning from the latest wireless-testing system:

  ------------[ cut here ]------------
  WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130 
[mac80211]()
  Hardware name: MS-7309
  Modules linked in: nouveau ttm drm_kms_helper drm hwmon mxm_wmi video wmi 
ipt_REJECT iptable_raw iptable_filter nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables 
x_tables ext3 jbd arc4 b43legacy rng_core rtl8187 acx_mac80211(O+) mac80211 fuse 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm cfg80211 ssb mmc_core 
eeprom_93cx6 sr_mod cdrom ata_generic snd_timer snd pata_amd soundcore rfkill 
pcmcia snd_page_alloc pcmcia_core powernow_k8 i2c_nforce2 button i2c_core mperf 
forcedeth ipv6 autofs4 ext4 mbcache jbd2 crc16 ohci_hcd ehci_hcd sata_nv usbcore 
usb_common processor scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh
  Pid: 2299, comm: NetworkManager Tainted: G           O 3.4.0-rc5-wl+ #39
  Call Trace:
   [<ffffffff81037f6a>] warn_slowpath_common+0x7a/0xb0
   [<ffffffff81037fb5>] warn_slowpath_null+0x15/0x20
   [<ffffffffa038c169>] ieee80211_check_queues+0x119/0x130 [mac80211]
   [<ffffffffa038ed79>] ieee80211_do_open+0x179/0x1200 [mac80211]
   [<ffffffff810657c4>] ? notifier_call_chain+0x54/0x110
   [<ffffffffa038fe6d>] ieee80211_open+0x6d/0x80 [mac80211]
   [<ffffffff8132f397>] __dev_open+0x97/0xe0
   [<ffffffff8132f61c>] __dev_change_flags+0x9c/0x180
   [<ffffffff8132f7b3>] dev_change_flags+0x23/0x70
   [<ffffffff8133d99f>] do_setlink+0x25f/0x9b0
   [<ffffffff8120e420>] ? nla_parse+0x30/0xe0
   [<ffffffff8133eaa5>] rtnl_newlink+0x345/0x550
   [<ffffffff810975f1>] ? mark_held_locks+0x61/0x140
   [<ffffffff81043c44>] ? ns_capable+0x44/0x80
   [<ffffffff8133e344>] rtnetlink_rcv_msg+0x114/0x2e0
   [<ffffffff8133d532>] ? rtnl_lock+0x12/0x20
   [<ffffffff8133e230>] ? __rtnl_unlock+0x20/0x20
   [<ffffffff813519e9>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff8133d560>] rtnetlink_rcv+0x20/0x30
   [<ffffffff813513ff>] netlink_unicast+0x19f/0x1f0
   [<ffffffff813517cd>] netlink_sendmsg+0x2bd/0x320
   [<ffffffff813191c6>] ? sock_update_classid+0x86/0x3a0
   [<ffffffff81312b52>] sock_sendmsg+0xe2/0x120
   [<ffffffff81113817>] ? might_fault+0x57/0xb0
   [<ffffffff81113860>] ? might_fault+0xa0/0xb0
   [<ffffffff81113817>] ? might_fault+0x57/0xb0
   [<ffffffff81321a86>] ? verify_iovec+0x56/0xd0
   [<ffffffff81312fe6>] __sys_sendmsg+0x376/0x380
   [<ffffffff8113f773>] ? fget_light+0x43/0x4e0
   [<ffffffff8113f7fd>] ? fget_light+0xcd/0x4e0
   [<ffffffff8113f773>] ? fget_light+0x43/0x4e0
   [<ffffffff81316204>] sys_sendmsg+0x44/0x80
   [<ffffffff813d70e2>] system_call_fastpath+0x16/0x1b
  ---[ end trace 415685f07ec6c955 ]---

This warning seems to be the same as the one reported at

https://bugzilla.redhat.com/show_bug.cgi?id=817490

The line in question is

      if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))

The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.

Larry
