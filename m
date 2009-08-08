Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48393 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZHHUSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 16:18:51 -0400
Received: by bwz19 with SMTP id 19so1991949bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 13:18:51 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: WARNING: at net/wireless/chan.c:19 rdev_fixed_channel
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 23:18:49 +0300
Message-ID: <87my6akqja.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I resumed my thinkpad x60s laptop (iwl3945, 32bit, old wpa_supplicant,
latest wireless-testing plus Johannes' siwfreq locking fix) and got the
warning below. Everything still worked, it automatically associated to a
WPA2 network and I'm sending this over that connection.

I have seen the page table error since rc2 or so, and I have been too
lazy to investigate it. I assume it's not related to the warning.

[30295.568384] phy0: device no longer idle - scanning
[30295.569126] phy0: device now idle
[30295.587033] render error detected, EIR: 0x00000010
[30295.587040] page table error
[30295.587043]   PGTBL_ER: 0x00000001
[30295.587049] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
0x00000010, masking
[30295.587066] render error detected, EIR: 0x00000010
[30295.587070] page table error
[30295.587073]   PGTBL_ER: 0x00000001
[30295.814045] ------------[ cut here ]------------
[30295.814088] WARNING: at net/wireless/chan.c:19
rdev_fixed_channel+0x28/0x7d [cfg80211]()
[30295.814094] Hardware name: 1703Y1F
[30295.814097] Modules linked in: tun cdc_ether usbnet cdc_acm mii i915
drm i2c_algo_bit sco bnep rfcomm l2cap binfmt_misc ipv6 fuse
acpi_cpufreq loop snd_hda_codec_analog snd_hda_intel snd_hda_codec arc4
ecb snd_pcm_oss snd_mixer_oss snd_pcm iwl3945 snd_seq_dummy snd_seq_oss
iwlcore snd_seq_midi_event mac80211 snd_seq pcmcia snd_timer
snd_seq_device cfg80211 btusb snd thinkpad_acpi yenta_socket bluetooth
soundcore rsrc_nonstatic rfkill rng_core battery ac button
snd_page_alloc pcmcia_core psmouse pcspkr nvram i2c_i801 evdev processor
ext3 jbd sha256_generic aes_i586 aes_generic cbc dm_crypt dm_mirror
dm_region_hash dm_log dm_snapshot dm_mod sd_mod sdhci_pci sdhci ata_piix
mmc_core led_class libata uhci_hcd ehci_hcd scsi_mod usbcore e1000e
video backlight output thermal fan
[30295.814237] Pid: 9925, comm: ip Tainted: G        W  2.6.31-rc5-wl
#205
[30295.814242] Call Trace:
[30295.814254]  [<c102965e>] warn_slowpath_common+0x65/0x95
[30295.814262]  [<c10296a0>] warn_slowpath_null+0x12/0x15
[30295.814289]  [<f8d09ecc>] rdev_fixed_channel+0x28/0x7d [cfg80211]
[30295.814317]  [<f8d08e93>] __cfg80211_connect+0x50/0x385 [cfg80211]
[30295.814343]  [<f8d0bf49>] cfg80211_mgd_wext_connect+0x101/0x11e
[cfg80211]
[30295.814368]  [<f8cfc308>] cfg80211_netdev_notifier_call+0x218/0x2b3
[cfg80211]
[30295.814379]  [<c103ea43>] notifier_call_chain+0x2b/0x55
[30295.814387]  [<c103eb10>] raw_notifier_call_chain+0x11/0x13
[30295.814395]  [<c1180d40>] dev_open+0xc9/0xd3
[30295.814404]  [<c1180427>] dev_change_flags+0xaa/0x15f
[30295.814412]  [<c1187580>] do_setlink+0x239/0x2f1
[30295.814421]  [<c11886e4>] rtnl_newlink+0x275/0x3ef
[30295.814428]  [<c11884a3>] ? rtnl_newlink+0x34/0x3ef
[30295.814435]  [<c11884ec>] ? rtnl_newlink+0x7d/0x3ef
[30295.814444]  [<c1187b00>] ? rtnl_fill_ifinfo+0x25f/0x4c2
[30295.814452]  [<c118846f>] ? rtnl_newlink+0x0/0x3ef
[30295.814460]  [<c1188455>] rtnetlink_rcv_msg+0x18f/0x1a9
[30295.814468]  [<c11882c6>] ? rtnetlink_rcv_msg+0x0/0x1a9
[30295.814476]  [<c118ebf7>] netlink_rcv_skb+0x35/0x7a
[30295.814483]  [<c11882be>] rtnetlink_rcv+0x21/0x29
[30295.814490]  [<c118e7eb>] netlink_unicast+0xcb/0x121
[30295.814498]  [<c118ea63>] netlink_sendmsg+0x222/0x22f
[30295.814507]  [<c1173b30>] sock_sendmsg+0xcf/0xe6
[30295.814516]  [<c103b2d7>] ? autoremove_wake_function+0x0/0x38
[30295.814525]  [<c103b2d7>] ? autoremove_wake_function+0x0/0x38
[30295.814533]  [<c103b2d7>] ? autoremove_wake_function+0x0/0x38
[30295.814542]  [<c106ffab>] ? get_page_from_freelist+0x8b/0x35a
[30295.814550]  [<c10f34c0>] ? copy_from_user+0x2f/0x117
[30295.814557]  [<c10f34c0>] ? copy_from_user+0x2f/0x117
[30295.814565]  [<c117ab99>] ? verify_iovec+0x45/0x74
[30295.814572]  [<c1173c8b>] sys_sendmsg+0x144/0x197
[30295.814580]  [<c11745d9>] ? sys_recvmsg+0x11a/0x17f
[30295.814588]  [<c1070521>] ? __alloc_pages_nodemask+0xe0/0x422
[30295.814597]  [<c1081524>] ? vma_merge+0x138/0x229
[30295.814605]  [<c1072955>] ? lru_cache_add_lru+0x2c/0x2e
[30295.814613]  [<c1083cbf>] ? page_add_new_anon_rmap+0x5d/0x6a
[30295.814622]  [<c107df6a>] ? handle_mm_fault+0x1a8/0x48d
[30295.814630]  [<c1174ac5>] sys_socketcall+0x145/0x172
[30295.814638]  [<c1002a08>] sysenter_do_call+0x12/0x26
[30295.814644] ---[ end trace 63d0b9ce8430ae90 ]---
[30295.814655] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[30300.572081] phy0: device no longer idle - scanning
[30303.159685] phy0: device now idle

-- 
Kalle Valo
