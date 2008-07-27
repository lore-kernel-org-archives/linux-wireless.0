Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbYG0U6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 16:58:43 -0400
Date: Sun, 27 Jul 2008 13:58:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: "Mohammed Gamal" <m.gamal005@gmail.com>
Subject: Fw: [Oops] b43 driver on 2.6.26
Message-Id: <20080727135840.a040e368.akpm@linux-foundation.org> (sfid-20080727_225900_017929_65248AEA)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__27_Jul_2008_13_58_40_-0700_9Qptzf8Grj3=wNxM"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Sun__27_Jul_2008_13_58_40_-0700_9Qptzf8Grj3=wNxM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit



Begin forwarded message:

Date: Wed, 23 Jul 2008 01:03:24 +0300
From: "Mohammed Gamal" <m.gamal005@gmail.com>
To: linux-net@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [Oops] b43 driver on 2.6.26


I get the following oops with b43 driver on scanning for wireless networks.
----

[  979.059158] ------------[ cut here ]------------
[  979.059181] kernel BUG at net/core/dev.c:1328!
[  979.059190] invalid opcode: 0000 [1] SMP 
[  979.059202] CPU 0 
[  979.059211] Modules linked in: rfkill_input arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class input_polldev ipv6 i915 drm binfmt_misc rfcomm l2cap nfsd lockd auth_rpcgss sunrpc exportfs ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp bridge stp kvm_intel kvm ppdev acpi_cpufreq cpufreq_ondemand cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative cpufreq_powersave pci_slot sbs sbshc iptable_filter ip_tables x_tables parport_pc lp parport snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd hci_usb soundcore serio_raw bluetooth ac iTCO_wdt button psmouse pcspkr iTCO_vendor_support container battery shpchp pci_hotplug intel_agp evdev dm_multipath dm_mod scsi_dh ext3 jbd mbcache sg sr_mod sd_mod cdrom ata_generic ata_piix libata scsi_mod dock uhci_hcd ehci_hcd ssb pcmcia pcmcia_c!
 ore usbcore raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal processor fan fuse
[  979.059564] Pid: 8718, comm: b43 Not tainted 2.6.26 #11
[  979.059573] RIP: 0010:[<ffffffff803f0f0d>]  [<ffffffff803f0f0d>] __netif_schedule+0x6d/0x80
[  979.059603] RSP: 0018:ffff880039253de0  EFLAGS: 00010246
[  979.059612] RAX: 00000000ffffffff RBX: ffff880032049700 RCX: 0000000000000000
[  979.059622] RDX: ffff880039b5e740 RSI: ffffffff805dca40 RDI: ffffffff805dca40
[  979.059632] RBP: ffff880039253df0 R08: ffff88003b599808 R09: ffffffffa216cee0
[  979.059641] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880031dc6f18
[  979.059651] R13: ffff880032f1d000 R14: ffff880031dc62e0 R15: 0000000000000000
[  979.059663] FS:  0000000000000000(0000) GS:ffffffff806ad280(0000) knlGS:0000000000000000
[  979.059674] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  979.059683] CR2: 000000000042d6a0 CR3: 0000000000201000 CR4: 00000000000026e0
[  979.059694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  979.059704] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  979.059715] Process b43 (pid: 8718, threadinfo ffff880039252000, task ffff88003a1fce20)
[  979.059723] Stack:  ffff880039253df0 ffff880032049700 ffff880039253e50 ffffffffa20a6123
[  979.059745]  ffffffffffffffff ffff880032049000 0000000000000000 0000000000000000
[  979.059762]  ffff880039253e40 ffff880031dc6f48 0000000000000000 ffff880031dc62e0
[  979.059778] Call Trace:
[  979.059855]  [<ffffffffa20a6123>] ieee80211_scan_completed+0x233/0x2c0 [mac80211]
[  979.059947]  [<ffffffffa20a8f38>] ieee80211_sta_scan_work+0xa8/0x200 [mac80211]
[  979.060002]  [<ffffffffa20a8e90>] ? ieee80211_sta_scan_work+0x0/0x200 [mac80211]
[  979.060036]  [<ffffffff802509a0>] run_workqueue+0xd0/0x170
[  979.060068]  [<ffffffff80251493>] worker_thread+0xa3/0x110
[  979.060090]  [<ffffffff80254970>] ? autoremove_wake_function+0x0/0x40
[  979.060122]  [<ffffffff802513f0>] ? worker_thread+0x0/0x110
[  979.060142]  [<ffffffff802544bd>] kthread+0x4d/0x80
[  979.060175]  [<ffffffff8020d8f9>] child_rip+0xa/0x11
[  979.060239]  [<ffffffff80254470>] ? kthread+0x0/0x80
[  979.060255]  [<ffffffff8020d8ef>] ? child_rip+0x0/0x11
[  979.060273] 
[  979.060278] 
[  979.060283] Code: 80 80 bf 02 00 00 00 48 01 c2 48 8b 02 48 89 46 68 48 89 32 e8 f5 31 e5 ff 48 89 df 57 9d 66 0f 1f 44 00 00 48 83 c4 08 5b c9 c3 <0f> 0b eb fe 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 
[  979.060427] RIP  [<ffffffff803f0f0d>] __netif_schedule+0x6d/0x80
[  979.060444]  RSP <ffff880039253de0>
[  979.060526] ---[ end trace 55f1610a9e5669be ]---



--Multipart=_Sun__27_Jul_2008_13_58_40_-0700_9Qptzf8Grj3=wNxM
Content-Type: application/octet-stream;
 name="oops"
Content-Disposition: attachment;
 filename="oops"
Content-Transfer-Encoding: base64

WyAgOTc5LjA1OTE1OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgIDk3
OS4wNTkxODFdIGtlcm5lbCBCVUcgYXQgbmV0L2NvcmUvZGV2LmM6MTMyOCEKWyAgOTc5LjA1OTE5
MF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWzFdIFNNUCAKWyAgOTc5LjA1OTIwMl0gQ1BVIDAgClsg
IDk3OS4wNTkyMTFdIE1vZHVsZXMgbGlua2VkIGluOiByZmtpbGxfaW5wdXQgYXJjNCBlY2IgY3J5
cHRvX2Jsa2NpcGhlciBiNDMgcmZraWxsIG1hYzgwMjExIGNmZzgwMjExIGxlZF9jbGFzcyBpbnB1
dF9wb2xsZGV2IGlwdjYgaTkxNSBkcm0gYmluZm10X21pc2MgcmZjb21tIGwyY2FwIG5mc2QgbG9j
a2QgYXV0aF9ycGNnc3Mgc3VucnBjIGV4cG9ydGZzIGlwdF9NQVNRVUVSQURFIGlwdGFibGVfbmF0
IG5mX25hdCBuZl9jb25udHJhY2tfaXB2NCB4dF9zdGF0ZSBuZl9jb25udHJhY2sgaXB0X1JFSkVD
VCB4dF90Y3B1ZHAgYnJpZGdlIHN0cCBrdm1faW50ZWwga3ZtIHBwZGV2IGFjcGlfY3B1ZnJlcSBj
cHVmcmVxX29uZGVtYW5kIGNwdWZyZXFfdXNlcnNwYWNlIGNwdWZyZXFfc3RhdHMgZnJlcV90YWJs
ZSBjcHVmcmVxX2NvbnNlcnZhdGl2ZSBjcHVmcmVxX3Bvd2Vyc2F2ZSBwY2lfc2xvdCBzYnMgc2Jz
aGMgaXB0YWJsZV9maWx0ZXIgaXBfdGFibGVzIHhfdGFibGVzIHBhcnBvcnRfcGMgbHAgcGFycG9y
dCBzbmRfaGRhX2ludGVsIHNuZF9wY21fb3NzIHNuZF9taXhlcl9vc3Mgc25kX3BjbSBzbmRfcGFn
ZV9hbGxvYyBzbmRfaHdkZXAgc25kX3NlcV9kdW1teSBzbmRfc2VxX29zcyBzbmRfc2VxX21pZGkg
c25kX3Jhd21pZGkgc25kX3NlcV9taWRpX2V2ZW50IHNuZF9zZXEgc25kX3RpbWVyIHNuZF9zZXFf
ZGV2aWNlIHNuZCBoY2lfdXNiIHNvdW5kY29yZSBzZXJpb19yYXcgYmx1ZXRvb3RoIGFjIGlUQ09f
d2R0IGJ1dHRvbiBwc21vdXNlIHBjc3BrciBpVENPX3ZlbmRvcl9zdXBwb3J0IGNvbnRhaW5lciBi
YXR0ZXJ5IHNocGNocCBwY2lfaG90cGx1ZyBpbnRlbF9hZ3AgZXZkZXYgZG1fbXVsdGlwYXRoIGRt
X21vZCBzY3NpX2RoIGV4dDMgamJkIG1iY2FjaGUgc2cgc3JfbW9kIHNkX21vZCBjZHJvbSBhdGFf
Z2VuZXJpYyBhdGFfcGlpeCBsaWJhdGEgc2NzaV9tb2QgZG9jayB1aGNpX2hjZCBlaGNpX2hjZCBz
c2IgcGNtY2lhIHBjbWNpYV9jb3JlIHVzYmNvcmUgcmFpZDEwIHJhaWQ0NTYgYXN5bmNfeG9yIGFz
eW5jX21lbWNweSBhc3luY190eCB4b3IgcmFpZDEgcmFpZDAgbXVsdGlwYXRoIGxpbmVhciBtZF9t
b2QgdGhlcm1hbCBwcm9jZXNzb3IgZmFuIGZ1c2UKWyAgOTc5LjA1OTU2NF0gUGlkOiA4NzE4LCBj
b21tOiBiNDMgTm90IHRhaW50ZWQgMi42LjI2ICMxMQpbICA5NzkuMDU5NTczXSBSSVA6IDAwMTA6
WzxmZmZmZmZmZjgwM2YwZjBkPl0gIFs8ZmZmZmZmZmY4MDNmMGYwZD5dIF9fbmV0aWZfc2NoZWR1
bGUrMHg2ZC8weDgwClsgIDk3OS4wNTk2MDNdIFJTUDogMDAxODpmZmZmODgwMDM5MjUzZGUwICBF
RkxBR1M6IDAwMDEwMjQ2ClsgIDk3OS4wNTk2MTJdIFJBWDogMDAwMDAwMDBmZmZmZmZmZiBSQlg6
IGZmZmY4ODAwMzIwNDk3MDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgIDk3OS4wNTk2MjJdIFJE
WDogZmZmZjg4MDAzOWI1ZTc0MCBSU0k6IGZmZmZmZmZmODA1ZGNhNDAgUkRJOiBmZmZmZmZmZjgw
NWRjYTQwClsgIDk3OS4wNTk2MzJdIFJCUDogZmZmZjg4MDAzOTI1M2RmMCBSMDg6IGZmZmY4ODAw
M2I1OTk4MDggUjA5OiBmZmZmZmZmZmEyMTZjZWUwClsgIDk3OS4wNTk2NDFdIFIxMDogMDAwMDAw
MDAwMDAwMDAwMSBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgwMDMxZGM2ZjE4Clsg
IDk3OS4wNTk2NTFdIFIxMzogZmZmZjg4MDAzMmYxZDAwMCBSMTQ6IGZmZmY4ODAwMzFkYzYyZTAg
UjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgIDk3OS4wNTk2NjNdIEZTOiAgMDAwMDAwMDAwMDAwMDAw
MCgwMDAwKSBHUzpmZmZmZmZmZjgwNmFkMjgwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAK
WyAgOTc5LjA1OTY3NF0gQ1M6ICAwMDEwIERTOiAwMDE4IEVTOiAwMDE4IENSMDogMDAwMDAwMDA4
MDA1MDAzYgpbICA5NzkuMDU5NjgzXSBDUjI6IDAwMDAwMDAwMDA0MmQ2YTAgQ1IzOiAwMDAwMDAw
MDAwMjAxMDAwIENSNDogMDAwMDAwMDAwMDAwMjZlMApbICA5NzkuMDU5Njk0XSBEUjA6IDAwMDAw
MDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICA5NzkuMDU5NzA0XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYw
IERSNzogMDAwMDAwMDAwMDAwMDQwMApbICA5NzkuMDU5NzE1XSBQcm9jZXNzIGI0MyAocGlkOiA4
NzE4LCB0aHJlYWRpbmZvIGZmZmY4ODAwMzkyNTIwMDAsIHRhc2sgZmZmZjg4MDAzYTFmY2UyMCkK
WyAgOTc5LjA1OTcyM10gU3RhY2s6ICBmZmZmODgwMDM5MjUzZGYwIGZmZmY4ODAwMzIwNDk3MDAg
ZmZmZjg4MDAzOTI1M2U1MCBmZmZmZmZmZmEyMGE2MTIzClsgIDk3OS4wNTk3NDVdICBmZmZmZmZm
ZmZmZmZmZmZmIGZmZmY4ODAwMzIwNDkwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwClsgIDk3OS4wNTk3NjJdICBmZmZmODgwMDM5MjUzZTQwIGZmZmY4ODAwMzFkYzZmNDggMDAw
MDAwMDAwMDAwMDAwMCBmZmZmODgwMDMxZGM2MmUwClsgIDk3OS4wNTk3NzhdIENhbGwgVHJhY2U6
ClsgIDk3OS4wNTk4NTVdICBbPGZmZmZmZmZmYTIwYTYxMjM+XSBpZWVlODAyMTFfc2Nhbl9jb21w
bGV0ZWQrMHgyMzMvMHgyYzAgW21hYzgwMjExXQpbICA5NzkuMDU5OTQ3XSAgWzxmZmZmZmZmZmEy
MGE4ZjM4Pl0gaWVlZTgwMjExX3N0YV9zY2FuX3dvcmsrMHhhOC8weDIwMCBbbWFjODAyMTFdClsg
IDk3OS4wNjAwMDJdICBbPGZmZmZmZmZmYTIwYThlOTA+XSA/IGllZWU4MDIxMV9zdGFfc2Nhbl93
b3JrKzB4MC8weDIwMCBbbWFjODAyMTFdClsgIDk3OS4wNjAwMzZdICBbPGZmZmZmZmZmODAyNTA5
YTA+XSBydW5fd29ya3F1ZXVlKzB4ZDAvMHgxNzAKWyAgOTc5LjA2MDA2OF0gIFs8ZmZmZmZmZmY4
MDI1MTQ5Mz5dIHdvcmtlcl90aHJlYWQrMHhhMy8weDExMApbICA5NzkuMDYwMDkwXSAgWzxmZmZm
ZmZmZjgwMjU0OTcwPl0gPyBhdXRvcmVtb3ZlX3dha2VfZnVuY3Rpb24rMHgwLzB4NDAKWyAgOTc5
LjA2MDEyMl0gIFs8ZmZmZmZmZmY4MDI1MTNmMD5dID8gd29ya2VyX3RocmVhZCsweDAvMHgxMTAK
WyAgOTc5LjA2MDE0Ml0gIFs8ZmZmZmZmZmY4MDI1NDRiZD5dIGt0aHJlYWQrMHg0ZC8weDgwClsg
IDk3OS4wNjAxNzVdICBbPGZmZmZmZmZmODAyMGQ4Zjk+XSBjaGlsZF9yaXArMHhhLzB4MTEKWyAg
OTc5LjA2MDIzOV0gIFs8ZmZmZmZmZmY4MDI1NDQ3MD5dID8ga3RocmVhZCsweDAvMHg4MApbICA5
NzkuMDYwMjU1XSAgWzxmZmZmZmZmZjgwMjBkOGVmPl0gPyBjaGlsZF9yaXArMHgwLzB4MTEKWyAg
OTc5LjA2MDI3M10gClsgIDk3OS4wNjAyNzhdIApbICA5NzkuMDYwMjgzXSBDb2RlOiA4MCA4MCBi
ZiAwMiAwMCAwMCAwMCA0OCAwMSBjMiA0OCA4YiAwMiA0OCA4OSA0NiA2OCA0OCA4OSAzMiBlOCBm
NSAzMSBlNSBmZiA0OCA4OSBkZiA1NyA5ZCA2NiAwZiAxZiA0NCAwMCAwMCA0OCA4MyBjNCAwOCA1
YiBjOSBjMyA8MGY+IDBiIGViIGZlIDY2IDY2IDY2IDY2IDY2IDY2IDJlIDBmIDFmIDg0IDAwIDAw
IDAwIDAwIDAwIDU1IDQ4IApbICA5NzkuMDYwNDI3XSBSSVAgIFs8ZmZmZmZmZmY4MDNmMGYwZD5d
IF9fbmV0aWZfc2NoZWR1bGUrMHg2ZC8weDgwClsgIDk3OS4wNjA0NDRdICBSU1AgPGZmZmY4ODAw
MzkyNTNkZTA+ClsgIDk3OS4wNjA1MjZdIC0tLVsgZW5kIHRyYWNlIDU1ZjE2MTBhOWU1NjY5YmUg
XS0tLQoK

--Multipart=_Sun__27_Jul_2008_13_58_40_-0700_9Qptzf8Grj3=wNxM--
