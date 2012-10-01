Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58741 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2JALpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:45:36 -0400
Date: Mon, 1 Oct 2012 07:34:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jasmine Hassan <jasmine.aura@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta 6.20.55.19
Message-ID: <20121001113456.GA31313@tuxdriver.com> (sfid-20121001_134540_351021_2B1D0194)
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why aren't you using brcmsmac?

On Mon, Oct 01, 2012 at 11:25:49AM +0200, Jasmine Hassan wrote:
> Hi,
> 
> I posted this a few days ago against 3.6-rc7, but got no response.
> http://marc.info/?l=linux-wireless&m=134875589522742&w=2
> 
> Tested again today against 3.6 stable, and still triggering kernel bug.
> Attached updated kernel trace from syslog.
> 
> Best,
> Jasmine Hassan

> Oct  1 10:38:47 terra kernel: [   17.026025] ------------[ cut here ]------------
> Oct  1 10:38:47 terra kernel: [   17.028051] kernel BUG at include/net/cfg80211.h:2473!
> Oct  1 10:38:47 terra kernel: [   17.030240] invalid opcode: 0000 [#1] PREEMPT SMP 
> Oct  1 10:38:47 terra kernel: [   17.032546] Modules linked in: af_packet cpufreq_conservative cpufreq_stats cpufreq_powersave binfmt_misc fuse loop dm_crypt dm_mod snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core snd_hda_codec_conexant i915 radeon intel_agp intel_gtt videodev i2c_algo_bit ttm drm_kms_helper media btusb bluetooth drm hid_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc joydev i2c_i801 snd_seq_dummy iTCO_wdt iTCO_vendor_support lpc_ich coretemp snd_seq_oss i2c_core mfd_core mei lib80211_crypt_tkip snd_seq_midi wl(PO) snd_seq_midi_event snd_rawmidi kvm_intel cfg80211 kvm snd_seq dell_wmi acpi_cpufreq mperf snd_seq_device snd_timer snd lib80211 dell_laptop(O) rfkill evdev sparse_keymap soundcore microcode psmouse dcdbas pcspkr processor serio_raw video battery ac button wmi ext4 crc16 jbd2 mbcache btrfs libcrc32c zlib_deflate usbhid hid sr_mod sd_mod cdrom crc_t10dif crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 f
> Oct  1 10:38:47 terra kernel: an aes_generic ablk_helper cryptd thermal ahci libahci libata scsi_mod r8169 mii xhci_hcd ehci_hcd usbcore usb_common
> Oct  1 10:38:47 terra kernel: [   17.051679] CPU 0 
> Oct  1 10:38:47 terra kernel: [   17.051707] Pid: 2708, comm: wpa_supplicant Tainted: P           O 3.6-0.slh.1-aptosid-amd64 #1 Dell Inc. Inspiron 5520/0XWH1P
> Oct  1 10:38:47 terra kernel: [   17.057512] RIP: 0010:[<ffffffffa06e308a>]  [<ffffffffa06e308a>] wdev_priv+0x5/0xc [wl]
> Oct  1 10:38:47 terra kernel: [   17.060546] RSP: 0018:ffff880158cd19e0  EFLAGS: 00010246
> Oct  1 10:38:47 terra kernel: [   17.063538] RAX: ffffffffa089ba30 RBX: ffff880159727c00 RCX: 00000000000000ff
> Oct  1 10:38:47 terra kernel: [   17.066516] RDX: 0000000000000000 RSI: ffff880159727c00 RDI: 0000000000000000
> Oct  1 10:38:47 terra kernel: [   17.069503] RBP: 0000000000000000 R08: 0000000000015420 R09: ffff880159727c00
> Oct  1 10:38:47 terra kernel: [   17.072490] R10: ffffffffa051b229 R11: ffff880156715c1c R12: ffff880158cd1a98
> Oct  1 10:38:47 terra kernel: [   17.075474] R13: 0000000000000001 R14: ffff880159727c00 R15: ffff880156715c24
> Oct  1 10:38:47 terra kernel: [   17.078424] FS:  00007f1e952c1700(0000) GS:ffff88015f200000(0000) knlGS:0000000000000000
> Oct  1 10:38:47 terra kernel: [   17.081443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Oct  1 10:38:47 terra kernel: [   17.084476] CR2: 0000000001ac04b8 CR3: 0000000156693000 CR4: 00000000001407f0
> Oct  1 10:38:47 terra kernel: [   17.087551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  1 10:38:47 terra kernel: [   17.090597] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  1 10:38:47 terra kernel: [   17.093667] Process wpa_supplicant (pid: 2708, threadinfo ffff880158cd0000, task ffff8801573754c0)
> Oct  1 10:38:47 terra kernel: [   17.096715] Stack:
> Oct  1 10:38:47 terra kernel: [   17.099726]  ffffffffa06e395c ffff880159727c00 ffff880157579000 ffff880158cd1a98
> Oct  1 10:38:47 terra kernel: [   17.102700]  0000000000000001 ffff8801551a1c00 ffffffffa051b473 ffff880156715c1c
> Oct  1 10:38:47 terra kernel: [   17.105699]  0000000000000033 0000000000000021 ffff8801575791e0 000000000000009a
> Oct  1 10:38:47 terra kernel: [   17.108700] Call Trace:
> Oct  1 10:38:47 terra kernel: [   17.111660]  [<ffffffffa06e395c>] ? wl_cfg80211_scan+0x1a/0x1e1 [wl]
> Oct  1 10:38:47 terra kernel: [   17.114622]  [<ffffffffa051b473>] ? nl80211_trigger_scan+0x38d/0x45d [cfg80211]
> Oct  1 10:38:47 terra kernel: [   17.117621]  [<ffffffff81287f0a>] ? genl_rcv_msg+0x1b6/0x1ff
> Oct  1 10:38:47 terra kernel: [   17.120619]  [<ffffffff81287d54>] ? genl_rcv+0x28/0x28
> Oct  1 10:38:47 terra kernel: [   17.123606]  [<ffffffff812879c1>] ? netlink_rcv_skb+0x36/0x7c
> Oct  1 10:38:47 terra kernel: [   17.126562]  [<ffffffff81287d4b>] ? genl_rcv+0x1f/0x28
> Oct  1 10:38:47 terra kernel: [   17.129531]  [<ffffffff812874f9>] ? netlink_unicast+0xda/0x15a
> Oct  1 10:38:47 terra kernel: [   17.132492]  [<ffffffff812877f2>] ? netlink_sendmsg+0x279/0x29e
> Oct  1 10:38:47 terra kernel: [   17.135425]  [<ffffffff812594b3>] ? sock_sendmsg+0x4f/0x6c
> Oct  1 10:38:47 terra kernel: [   17.138303]  [<ffffffff810a76ae>] ? __alloc_pages_nodemask+0x139/0x6f2
> Oct  1 10:38:47 terra kernel: [   17.141232]  [<ffffffff810a12f5>] ? find_get_page+0x61/0x6c
> Oct  1 10:38:47 terra kernel: [   17.144164]  [<ffffffff81259fcd>] ? __sys_sendmsg+0x1f2/0x284
> Oct  1 10:38:47 terra kernel: [   17.147090]  [<ffffffff8132a335>] ? _raw_spin_unlock+0x1e/0x2c
> Oct  1 10:38:47 terra kernel: [   17.149996]  [<ffffffff810bae61>] ? handle_mm_fault+0x1aa/0x1e7
> Oct  1 10:38:47 terra kernel: [   17.152922]  [<ffffffff8102ce86>] ? do_page_fault+0x274/0x2f2
> Oct  1 10:38:47 terra kernel: [   17.155810]  [<ffffffff81011a2c>] ? check_for_xstate+0x22/0x75
> Oct  1 10:38:47 terra kernel: [   17.158629]  [<ffffffff81011d88>] ? restore_i387_xstate+0xe4/0x1f4
> Oct  1 10:38:47 terra kernel: [   17.161484]  [<ffffffff8104466c>] ? do_sigaltstack+0xac/0x146
> Oct  1 10:38:47 terra kernel: [   17.164324]  [<ffffffff8125ab89>] ? sys_sendmsg+0x39/0x57
> Oct  1 10:38:47 terra kernel: [   17.167152]  [<ffffffff8132aff9>] ? system_call_fastpath+0x16/0x1b
> Oct  1 10:38:47 terra kernel: [   17.169942] Code: c6 30 70 85 a0 31 c0 e8 22 03 c4 e0 48 c7 c7 30 ab 85 a0 31 c0 e8 14 03 c4 e0 48 89 df e8 73 fd ff ff 31 c0 5b c3 48 85 ff 75 02 <0f> 0b 48 8b 3f eb a4 41 54 41 89 c9 55 53 48 83 ec 50 65 48 8b 
> Oct  1 10:38:47 terra kernel: [   17.176029] RIP  [<ffffffffa06e308a>] wdev_priv+0x5/0xc [wl]
> Oct  1 10:38:47 terra kernel: [   17.178795]  RSP <ffff880158cd19e0>
> Oct  1 10:38:47 terra kernel: [   17.181589] ---[ end trace d0244e8a4dcb2ed4 ]---
> Oct  1 10:38:47 terra NetworkManager[2670]: <info> wpa_supplicant stopped
> Oct  1 10:38:47 terra NetworkManager[2670]: <info> (eth2): supplicant interface state: inactive -> down
> Oct  1 10:38:47 terra NetworkManager[2670]: <info> (eth2): device state change: disconnected -> unavailable (reason 'supplicant-failed') [30 20 10]
> Oct  1 10:38:47 terra NetworkManager[2670]: <info> (eth2): deactivating device (reason 'supplicant-failed') [10]


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
