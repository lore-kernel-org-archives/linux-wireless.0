Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54417 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab3CEENJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 23:13:09 -0500
Received: by mail-ob0-f178.google.com with SMTP id wd20so2375880obb.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 20:13:07 -0800 (PST)
Message-ID: <513570D0.4070302@lwfinger.net> (sfid-20130305_051313_561214_7DA3237F)
Date: Mon, 04 Mar 2013 22:13:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: WARNING from net/wireless/mlme.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With 3.9-rc1 from wireless-testing, I get a warning from the line
         if (WARN(!wdev->current_bss, "sme_state=%d\n", wdev->sme_state))

[ 4250.226882] ------------[ cut here ]------------
[ 4250.226929] WARNING: at net/wireless/mlme.c:517 
cfg80211_mlme_disassoc+0x192/0x3a0 [cfg80211]()
[ 4250.226933] Hardware name: HP Pavilion dv2700 Notebook PC
[ 4250.226936] sme_state=2
[ 4250.226938] Modules linked in: fuse af_packet rfcomm bnep rtl8723ae b43 
rtlwifi mac80211 cfg80211 btusb bluetooth ipv6 snd_hda_codec_conexant 
snd_hda_intel snd_hda_codec snd_pcm snd_seq kvm_amd bcma rng_core kvm snd_timer 
ssb mmc_core snd_seq_device snd sg pcmcia sr_mod cdrom k8temp soundcore 
snd_page_alloc pcmcia_core i2c_nforce2 hwmon forcedeth i2c_core serio_raw joydev 
video battery ac wmi button autofs4 ext4 mbcache jbd2 crc16 thermal processor 
scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh ata_generic 
pata_acpi pata_amd
[ 4250.227022] Pid: 3018, comm: wpa_supplicant Tainted: G        W 
3.9.0-rc1-wl+ #122
[ 4250.227025] Call Trace:
[ 4250.227047]  [<ffffffffa0545200>] ? cfg80211_mlme_disassoc+0x180/0x3a0 [cfg80211]
[ 4250.227055]  [<ffffffff810408fa>] warn_slowpath_common+0x7a/0xc0
[ 4250.227060]  [<ffffffff810409e1>] warn_slowpath_fmt+0x41/0x50
[ 4250.227082]  [<ffffffffa0545212>] cfg80211_mlme_disassoc+0x192/0x3a0 [cfg80211]
[ 4250.227101]  [<ffffffffa053a87c>] ? nl80211_pre_doit+0x2ec/0x3e0 [cfg80211]
[ 4250.227120]  [<ffffffffa052d542>] nl80211_disassociate+0xb2/0xf0 [cfg80211]
[ 4250.227131]  [<ffffffff813e1dd4>] genl_rcv_msg+0x274/0x2b0
[ 4250.227136]  [<ffffffff813e1b60>] ? genl_rcv+0x30/0x30
[ 4250.227141]  [<ffffffff813e1069>] netlink_rcv_skb+0xa9/0xc0
[ 4250.227146]  [<ffffffff813e1b50>] genl_rcv+0x20/0x30
[ 4250.227150]  [<ffffffff813e09bb>] netlink_unicast+0x19b/0x220
[ 4250.227155]  [<ffffffff813e0e26>] netlink_sendmsg+0x336/0x3b0
[ 4250.227162]  [<ffffffff8139b397>] sock_sendmsg+0x87/0xa0
[ 4250.227168]  [<ffffffff81128317>] ? might_fault+0x57/0xb0
[ 4250.227175]  [<ffffffff8139b84c>] __sys_sendmsg+0x37c/0x390
[ 4250.227180]  [<ffffffff81197f37>] ? fsnotify+0x87/0x5f0
[ 4250.227185]  [<ffffffff8119814c>] ? fsnotify+0x29c/0x5f0
[ 4250.227188]  [<ffffffff81197f37>] ? fsnotify+0x87/0x5f0
[ 4250.227195]  [<ffffffff8116ff6a>] ? fget_light+0x3da/0x4d0
[ 4250.227200]  [<ffffffff8139e9e4>] sys_sendmsg+0x44/0x80
[ 4250.227207]  [<ffffffff8146cfa9>] system_call_fastpath+0x16/0x1b
[ 4250.227211] ---[ end trace 7082b359b3f3e7d2 ]---

Larry
