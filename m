Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1690 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1KIV2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 16:28:53 -0500
Message-ID: <4EBAF088.2040406@broadcom.com> (sfid-20111109_222858_083396_662BDDBC)
Date: Wed, 9 Nov 2011 22:28:40 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Arik Nemtsov" <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.2-rc1: system locks up upon inserting brcmsmac
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I merged wireless-testing master with our main development branch and
got a hanging system. So I tested your master branch after that and the
same result. Given the kernel log it may be the commit mentioned below
although I did not bisect it yet.

077a91548 mac80211: support adding IV-room in the skb for CCMP keys

Our driver does not do hardware encryption so not sure whether it is
related.

Gr. AvS
================================================================
Nov  9 22:00:54 lb-bun-09 kernel: [ 5012.280889] udev[435]: renamed
network interface wlan0 to wlan1
Nov  9 22:00:54 lb-bun-09 kernel: [ 5012.331323] ieee80211 phy0:
brcms_ops_bss_info_changed: qos enabled: false (implement)
Nov  9 22:00:54 lb-bun-09 kernel: [ 5012.331333] ieee80211 phy0:
brcms_ops_config: change monitor mode: false (implement)
Nov  9 22:00:54 lb-bun-09 kernel: [ 5012.331335] ieee80211 phy0:
brcms_ops_config: change power-save mode: false (implement)
Nov  9 22:00:54 lb-bun-09 kernel: [ 5012.331589] ADDRCONF(NETDEV_UP):
wlan1: link is not ready
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.975367] wlan1: authenticate
with 98:fc:11:8e:94:57 (try 1)
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.976967] wlan1: authenticated
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.977000] wlan1: associate with
98:fc:11:8e:94:57 (try 1)
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981162] wlan1: RX AssocResp
from 98:fc:11:8e:94:57 (capab=0x411 status=0 aid=1)
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981168] wlan1: associated
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981755] ieee80211 phy0:
brcms_ops_bss_info_changed: qos enabled: true (implement)
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981765] ieee80211 phy0:
brcmsmac: brcms_ops_bss_info_changed: associated
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981772] ieee80211 phy0:
changing basic rates failed: -22
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.981778] ieee80211 phy0:
brcms_ops_bss_info_changed: arp filtering: enabled true, count 0
 (implement)
Nov  9 22:00:56 lb-bun-09 kernel: [ 5014.982058]
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.136055] BUG: unable to handle
kernel NULL pointer dereference at 00000007
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] IP: [<f9388d32>]
ccmp_encrypt_skb+0xe2/0x220 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] *pde = 00000000
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Oops: 0000 [#1] SMP
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Modules linked in:
aes_i586 aes_generic arc4 brcmsmac(O) brcmutil(O) crc_ccitt m
ac80211 cfg80211 binfmt_misc snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq
_midi_event snd_seq snd_timer snd_seq_device snd soundcore psmouse
snd_page_alloc serio_raw usbhid hid i915 drm_kms_helper drm i2
c_algo_bit sdhci_pci sdhci floppy mmc_core intel_agp video r8169 mii
intel_gtt agpgart
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Pid: 0, comm:
kworker/0:0 Tainted: G           O 3.2.0-rc1-testing-no-force-hs-0
0002-g8ff65e4 #1                  /DG41TY
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] EIP: 0060:[<f9388d32>]
EFLAGS: 00010202 CPU: 1
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] EIP is at
ccmp_encrypt_skb+0xe2/0x220 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] EAX: 00000000 EBX:
edc393c0 ECX: 0000000a EDX: 00300b06
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] ESI: f2f8cc86 EDI:
edc393d8 EBP: f4cb3ba8 ESP: f4cb3b10
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Process kworker/0:0
(pid: 0, ti=f4cb2000 task=f4ca8000 task.ti=f4c9e000)
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Stack:
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  f38d2400 f396c048
f38d2400 f4cb3b50 00000048 0000001a 0000000f f73b4800
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  00010000 00000000
f396c070 f396c000 f2ff6c40 f4cb3c08 f4cb3b8c f93b1c67
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  00000000 f4cb3c08
00000000 00000001 00000004 00000072 f4cb3b7c c05b0b93
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Call Trace:
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93b1c67>] ?
minstrel_ht_get_rate+0x387/0x3c0 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05b0b93>] ?
vmalloc_fault+0xf3/0x130
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93964d5>] ?
rate_control_get_rate+0x95/0x1e0 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f9388e91>]
ieee80211_crypto_ccmp_encrypt+0x21/0x50 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93a0955>]
invoke_tx_handlers+0x915/0xfa0 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93a110d>]
ieee80211_tx+0x4d/0x90 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93a13e7>]
ieee80211_xmit+0x87/0xd0 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<f93a1a19>]
ieee80211_subif_start_xmit+0x2a9/0x8a0 [mac80211]
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04d6997>]
dev_hard_start_xmit+0x2b7/0x620
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04fe445>] ?
inet_getpeer+0x465/0x5e0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04eca61>]
sch_direct_xmit+0xb1/0x170
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04d6e4c>]
dev_queue_xmit+0x14c/0x530
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c051d83d>] ?
tcp_v4_do_rcv+0x1dd/0x430
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04df07c>]
neigh_resolve_output+0xfc/0x1c0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c04ebc00>] ?
eth_rebuild_header+0x80/0x80
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c055717a>]
ip6_finish_output2+0xca/0x370
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0561a80>] ?
rt6_bind_peer+0x40/0x80
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c055749f>]
ip6_finish_output+0x7f/0xb0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0557557>]
ip6_output+0x87/0x100
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0568ba4>]
ndisc_send_skb+0x1e4/0x210
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0568c27>]
__ndisc_send+0x57/0x70
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05694a4>]
ndisc_send_ns+0x74/0xb0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0153ae6>] ?
add_timer+0x16/0x20
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05593c2>] ?
addrconf_mod_timer+0x52/0x70
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c055c0da>]
addrconf_dad_timer+0x13a/0x180
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0152c3a>]
run_timer_softirq+0x11a/0x2d0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c055bfa0>] ?
addrconf_dad_completed+0xc0/0xc0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c014b74e>]
__do_softirq+0x9e/0x1b0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c014b6b0>] ?
irq_enter+0x70/0x70
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  <IRQ>
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c014b58d>] ?
irq_exit+0x9d/0xc0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05b4d49>] ?
smp_apic_timer_interrupt+0x59/0x88
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05ae3c9>] ?
apic_timer_interrupt+0x31/0x38
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c01700d8>] ?
print_tickdevice+0x2d8/0x3b0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0109c88>] ?
mwait_idle+0x88/0x180
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c0101d9e>] ?
cpu_idle+0xae/0xe0
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002]  [<c05a605f>] ?
start_secondary+0x1d8/0x1de
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Code: 91 2b b3 ac 00 00
00 83 fe 07 76 df ba 08 00 00 00 89 d8 e8 01 10 14 c7 8b 8d 7c ff ff ff
8d 50 08 89 c6 e8 b1 24 ff c6 8b 47 1c <f6> 40 07 20 0f 85 5b ff ff ff
03 b5 7c ff ff ff 89 b5 74 ff ff
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] EIP: [<f9388d32>]
ccmp_encrypt_skb+0xe2/0x220 [mac80211] SS:ESP 0068:f4cb3b10
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] CR2: 0000000000000007
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] BUG: scheduling while
atomic: kworker/0:0/0/0x10000300
Nov  9 22:00:57 lb-bun-09 kernel: [ 5015.140002] Modules linked in:
aes_i586 aes_generic arc4 brcmsmac(O) brcmutil(O) crc_ccitt mac80211
cfg80211 binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer snd_seq_device snd soundcore psmouse snd_page_alloc serio_raw
usbhid hid i915 drm_kms_helper drm i2c_algo_bit sdhci_pci sdhci floppy
mmc_core intel_agp video r8169 mii intel_gtt agpgart
================================================================

