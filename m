Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59844 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2LWNe6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 08:34:58 -0500
Received: from ilfaris ([83.215.103.237]) by smtp.web.de (mrweb001) with
 ESMTPSA (Nemesis) id 0MK2JZ-1TlOnF2E7h-001XGT for
 <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2012 14:34:56 +0100
Date: Sun, 23 Dec 2012 14:34:52 +0100
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Subject: Warning with trace while trying to connect to an AP
Message-ID: <20121223143452.1d029621@ilfaris> (sfid-20121223_143502_563235_989FE958)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

while trying to connect to an AP I got the following trace:
[13677.506164] ------------[ cut here ]------------
[13677.506196] WARNING: at net/wireless/mlme.c:517 cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()
[13677.506219] Hardware name: 30515YG
[13677.506222] Modules linked in: rtl8192ce rtlwifi rtl8192c_common mac80211 cfg80211 xt_tcpudp xt_REDIRECT xt_h
l iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables deflate zlib_d
eflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo acpi_cpufreq mperf loop fuse arc4 snd_h
da_codec_conexant snd_hda_codec_hdmi radeon snd_hda_intel i2c_algo_bit snd_hda_codec snd_hwdep snd_pcm drm_kms_h
elper btusb thinkpad_acpi snd_page_alloc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core bluetooth tt
m snd_timer drm nvram videodev snd crc16 i2c_piix4 agpgart psmouse soundcore evdev rfkill i2c_core pcspkr serio_
raw k10temp ehci_pci wmi video battery ac button processor sha256_generic twofish_x86_64_3way xts lrw gf128mul g
lue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif rtsx_pci_sdmmc mmc_core ohci_hcd 
thermal ehci_hcd microcode thermal_sys rtsx_pci atl1c mfd_core usbcore ahci libahci libata scsi_mod usb_common [
last unloaded: cfg80211]
[13677.506360] Pid: 19340, comm: wpa_supplicant Tainted: G        W    3.8.0-rc1 #1
[13677.506368] Call Trace:
[13677.506378]  [<ffffffff810381d9>] ? warn_slowpath_common+0x79/0xc0
[13677.506389]  [<ffffffffa039082d>] ? cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]
[13677.506399]  [<ffffffffa037e5ce>] ? nl80211_pre_doit+0x30e/0x400 [cfg80211]
[13677.506409]  [<ffffffffa037c7dd>] ? nl80211_disassociate+0xad/0xf0 [cfg80211]
[13677.506416]  [<ffffffff8135c919>] ? genl_rcv_msg+0x249/0x2c0
[13677.506421]  [<ffffffff8135c6d0>] ? genl_rcv+0x30/0x30
[13677.506425]  [<ffffffff8135c351>] ? netlink_rcv_skb+0x91/0xa0
[13677.506429]  [<ffffffff8135c6bf>] ? genl_rcv+0x1f/0x30
[13677.506433]  [<ffffffff8135bc5c>] ? netlink_unicast+0x19c/0x220
[13677.506438]  [<ffffffff8135bfe3>] ? netlink_sendmsg+0x303/0x3c0
[13677.506443]  [<ffffffff8131eccb>] ? sock_sendmsg+0x7b/0xb0
[13677.506472]  [<ffffffff81320524>] ? __sys_sendmsg+0x394/0x3b0
[13677.506487]  [<ffffffff8102bc32>] ? __do_page_fault+0x1b2/0x480
[13677.506493]  [<ffffffff81133bec>] ? poll_select_copy_remaining+0xfc/0x150
[13677.506497]  [<ffffffff81322554>] ? sys_sendmsg+0x44/0x80
[13677.506503]  [<ffffffff81412792>] ? system_call_fastpath+0x16/0x1b
[13677.506506] ---[ end trace c4fc3013132383ed ]---

I am using v3.8-rc1 with the following WiFi device:
01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8195]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 3000 [size=256]
	Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192ce

If you need further information, please feel free to ask.


With best regards,
Julian Wollrath
