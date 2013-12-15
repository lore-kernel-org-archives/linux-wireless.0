Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.93]:43451 "HELO
	nm17-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751631Ab3LOTU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 14:20:29 -0500
Received: from node1.localdomain (localhost [127.0.0.1])
	by node1.localdomain (8.14.5/8.14.5) with ESMTP id rBFJEQCf028875
	for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 14:14:26 -0500
Received: (from parkw@localhost)
	by node1.localdomain (8.14.5/8.14.5/Submit) id rBFJEO9K028874
	for linux-wireless@vger.kernel.org; Sun, 15 Dec 2013 14:14:24 -0500
Date: Sun, 15 Dec 2013 14:14:24 -0500
From: William Park <opengeometry@yahoo.ca>
To: linux-wireless@vger.kernel.org
Subject: Re: 2.4GHz working, but 5GHz not working
Message-ID: <20131215191424.GA28861@node1.localdomain> (sfid-20131215_202039_630121_85DD3F72)
References: <20131214052157.GA5372@node1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131214052157.GA5372@node1.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update:

It seems that my driver and/or the router don't like certain
combination of channel and its width.

    - channel=36 and width=20/40MHz works -- I now remember this was
      what worked before.
    
    - channel=44 and channel=165 don't work at all.

    - most other channels (didn't try all) work for width=40MHz only.

So, I'm now using channel=161 and width=40MHz.
-- 
William

On Sat, Dec 14, 2013 at 12:21:57AM -0500, William Park wrote:
> Hi,
> 
> I have Linksys WMP600N dual-band PCI adapter (rt2800pci) which used to
> work, but now 5GHz is not working.  Router is ok, since my laptop can
> connect 5GHz.
> 
> I tried 3.10 and 3.12 kernels (that I compiled myself) and many distros
> (both live and regular install), and they all exhibit the same problem.
> When attempt is made to connect 5GHz, I get:
> 
> 	------------[ cut here ]------------
> 	WARNING: CPU: 0 PID: 2126 at /home/kernel/linux-3.12/drivers/net/wireless/rt2x00/rt2x00config.c:201 rt2x00lib_config+0x293/0x2e0 [rt2x00lib]()
> 	Modules linked in: nls_iso8859_1 nls_cp437 vfat fat btrfs libcrc32c fuse vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables dm_mod nvidia(PO) snd_hda_codec_hdmi acpi_cpufreq processor edac_core sp5100_tco arc4 rt2800pci rt2800lib rt2x00pci rt2x00mmio rt2x00lib mac80211 cfg80211 eeprom_93cx6 drm agpgart r8169 psmouse evdev mii thermal_sys mac_hid k10temp i2c_piix4 crc_ccitt i2c_core edac_mce_amd button hwmon rtc_cmos rfkill wmi serio_raw ohci_pci ohci_hcd kvm_amd kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore microcode loop
> 	CPU: 0 PID: 2126 Comm: wpa_supplicant Tainted: P           O 3.12.3 #1
> 	Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1605 10/25/2012
> 	 0000000000000009 ffff88007ff135d8 ffffffff814e59c1 0000000000000007
> 	 0000000000000000 ffff88007ff13618 ffffffff8103fff2 0000000000000038
> 	 ffff880416d05720 ffff880416d045c0 0000000000000042 0000000000000040
> 	Call Trace:
> 	 [<ffffffff814e59c1>] dump_stack+0x46/0x58
> 	 [<ffffffff8103fff2>] warn_slowpath_common+0x82/0xb0
> 	 [<ffffffff81040035>] warn_slowpath_null+0x15/0x20
> 	 [<ffffffffa0464f73>] rt2x00lib_config+0x293/0x2e0 [rt2x00lib]
> 	 [<ffffffffa0464463>] rt2x00mac_config+0x43/0x80 [rt2x00lib]
> 	 [<ffffffffa040543d>] ieee80211_hw_config+0x5d/0x2c0 [mac80211]
> 	 [<ffffffffa042e033>] ieee80211_vif_use_channel+0x3a3/0x440 [mac80211]
> 	 [<ffffffffa042f898>] ieee80211_prep_connection+0x138/0x820 [mac80211]
> 	 [<ffffffff811a27f0>] ? ext4_ext_find_extent+0x220/0x2a0
> 	 [<ffffffff814e1fd6>] ? printk+0x48/0x4a
> 	 [<ffffffffa0434811>] ieee80211_mgd_auth+0x2a1/0x310 [mac80211]
> 	 [<ffffffffa04191e3>] ieee80211_auth+0x13/0x20 [mac80211]
> 	 [<ffffffffa03e4b03>] cfg80211_mlme_auth+0x173/0x1a0 [cfg80211]
> 	 [<ffffffffa03d6afc>] nl80211_authenticate+0x2cc/0x330 [cfg80211]
> 	 [<ffffffff81461edc>] genl_family_rcv_msg+0x17c/0x380
> 	 [<ffffffff814620e0>] ? genl_family_rcv_msg+0x380/0x380
> 	 [<ffffffff81462159>] genl_rcv_msg+0x79/0xb0
> 	 [<ffffffff81461959>] netlink_rcv_skb+0xa9/0xc0
> 	 [<ffffffff81461bb7>] genl_rcv+0x27/0x40
> 	 [<ffffffff81460eed>] netlink_unicast+0x10d/0x190
> 	 [<ffffffff81461289>] netlink_sendmsg+0x319/0x760
> 	 [<ffffffff81422594>] sock_sendmsg+0x64/0x80
> 	 [<ffffffff8142e799>] ? verify_iovec+0x49/0xd0
> 	 [<ffffffff814228a4>] ___sys_sendmsg.part.30+0x2a4/0x2c0
> 	 [<ffffffff81035fec>] ? __do_page_fault+0x1ec/0x4f0
> 	 [<ffffffff811319af>] ? mntput+0x1f/0x30
> 	 [<ffffffff81115bba>] ? __fput+0x16a/0x230
> 	 [<ffffffff814232c0>] __sys_sendmsg+0x50/0x90
> 	 [<ffffffff81423309>] SyS_sendmsg+0x9/0x10
> 	 [<ffffffff814ec222>] system_call_fastpath+0x16/0x1b
> 	---[ end trace 9b341a9f9ef3f57c ]---
> 
> This is a sign that the card is failing?
> -- 
> William
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
