Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33703 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbbEUKKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 06:10:20 -0400
Received: by wgjc11 with SMTP id c11so80404116wgj.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 03:10:19 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 May 2015 12:10:19 +0200
Message-ID: <CALhHN=qpttT98YMBq8iC134pnU14kV4VZY-oGKwNsA5tBgXzUA@mail.gmail.com> (sfid-20150521_121026_038768_B5CB0FC0)
Subject: ath9k: use_chanctx=1 sta + p2p_client - oops
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

During tests of multi channel concurency with AR9462 (rev 01) I hit such oops

gdb point xmit.c +2378

[70874.035886] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[70874.043725] IP: [<ffffffffc071d589>] ath_tx_start+0x129/0x450 [ath9k]
[70874.050173] PGD cb5e4067 PUD cae20067 PMD 0
[70874.054462] Oops: 0000 [#1] SMP
[70874.057702] Modules linked in: iwlmvm(E) iwlwifi(E) ath10k_pci(OE)
ath10k_core(OE) ath9k(E) ath9k_common(E) ath9k_hw(E) ath(E)
mac80211(OE) cfg80211(OE) ftdi_sio(E) usbserial(E) ctr(E) ccm(E)
arc4(E) dm_crypt(E) cmac(E) dell_wmi(E) sparse_keymap(E) intel_rapl(E)
dell_laptop(E) iosf_mbi(E) dcdbas(E) x86_pkg_temp_thermal(E)
intel_powerclamp(E) i8k(E) coretemp(E) kvm_intel(E) kvm(E) rfcomm(E)
bnep(E) crct10dif_pclmul(E) crc32_pclmul(E) snd_hda_codec_idt(E)
ghash_clmulni_intel(E) snd_hda_codec_generic(E) uvcvideo(E)
aesni_intel(E) videobuf2_vmalloc(E) aes_x86_64(E) videobuf2_memops(E)
lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) videobuf2_core(E)
cryptd(E) snd_hda_intel(E) v4l2_common(E) snd_hda_controller(E)
videodev(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) joydev(E)
serio_raw(E) snd_pcm(E) media(E) ath3k(E) snd_seq_midi(E)
snd_seq_midi_event(E) btusb(E) btbcm(E) snd_rawmidi(E) btintel(E)
bluetooth(E) snd_seq(E) lpc_ich(E) snd_seq_device(E) snd_timer(E)
dell_smo8800(E) mac_hid(E) snd(E) mei_me(E) soundcore(E) shpchp(E)
mei(E) binfmt_misc(E) parport_pc(E) ppdev(E) lp(E) parport(E)
nouveau(E) mxm_wmi(E) i915(E) ttm(E) i2c_algo_bit(E) drm_kms_helper(E)
e1000e(E) sdhci_pci(E) ahci(E) ptp(E) sdhci(E) psmouse(E) libahci(E)
drm(E) wmi(E) pps_core(E) video(E) [last unloaded: cfg80211]
[70874.172405] CPU: 5 PID: 12739 Comm: wpa_supplicant Tainted: G
 W  OE   4.1.0-rc1master-2015-05-14-00-wl-ath+ #21
[70874.183090] Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS
A13 09/02/2013
[70874.190389] task: ffff8800c88dd100 ti: ffff8800c9df4000 task.ti:
ffff8800c9df4000
[70874.197863] RIP: 0010:[<ffffffffc071d589>]  [<ffffffffc071d589>]
ath_tx_start+0x129/0x450 [ath9k]
[70874.206734] RSP: 0018:ffff8800c9df75a8  EFLAGS: 00010216
[70874.212037] RAX: 0000000000000000 RBX: ffff8800cabc93e0 RCX: 0000000000000038
[70874.219164] RDX: ffff880222846988 RSI: ffff8800cabca6f0 RDI: 0000000000000000
[70874.226290] RBP: ffff8800c9df7628 R08: 0000000000000000 R09: 0000000000000000
[70874.233414] R10: ffff88020a2a4d44 R11: 0000000000000000 R12: ffff8802228453b8
[70874.240541] R13: ffff8800c9df7658 R14: ffff8800c9ae6000 R15: ffff880222846ce8
[70874.247667] FS:  00007fe30e448740(0000) GS:ffff88022e340000(0000)
knlGS:0000000000000000
[70874.255747] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[70874.261485] CR2: 0000000000000000 CR3: 00000000b7529000 CR4: 00000000001407e0
[70874.268610] Stack:
[70874.270616]  ffff8800c9df7698 ffff880000000000 ffff88020a2a4d44
ffffffff00000000
[70874.278042]  ffff8800cabca710 0000000000000000 ffff8802228468b0
ffff8800cabca6f0
[70874.285465]  0000000000000000 ffff880209bb1700 ffff8800c9df7638
ffff8800ca9a4018
[70874.292894] Call Trace:
[70874.295336]  [<ffffffffc071492f>] ath9k_tx+0xaf/0x2b0 [ath9k]
[70874.301084]  [<ffffffffc095ff7a>] ?
rate_control_get_rate+0x14a/0x150 [mac80211]
[70874.308478]  [<ffffffffc096fd64>] ieee80211_tx_frags+0x104/0x410 [mac80211]
[70874.315435]  [<ffffffffc09700ee>] __ieee80211_tx+0x7e/0x180 [mac80211]
[70874.321961]  [<ffffffffc097347e>] ieee80211_tx+0xbe/0xf0 [mac80211]
[70874.328224]  [<ffffffffc09736b1>] ieee80211_xmit+0xa1/0x100 [mac80211]
[70874.334748]  [<ffffffffc0974b7a>]
__ieee80211_tx_skb_tid_band+0x6a/0x80 [mac80211]
[70874.342314]  [<ffffffffc09795d6>] ieee80211_send_auth+0x166/0x1d0 [mac80211]
[70874.349361]  [<ffffffffc0994b48>] ieee80211_probe_auth+0x138/0x3d0 [mac80211]
[70874.356493]  [<ffffffffc099b4e5>] ieee80211_mgd_auth+0x295/0x310 [mac80211]
[70874.363452]  [<ffffffffc09629f8>] ieee80211_auth+0x18/0x20 [mac80211]
[70874.369894]  [<ffffffffc08e4bc3>] cfg80211_mlme_auth+0xf3/0x1c0 [cfg80211]
[70874.376761]  [<ffffffff81206a76>] ? do_select+0x6d6/0x790
[70874.382155]  [<ffffffffc08cd30d>] nl80211_authenticate+0x2ad/0x310 [cfg80211]
[70874.389283]  [<ffffffff816e9bd5>] genl_family_rcv_msg+0x1a5/0x3d0
[70874.395368]  [<ffffffff81206100>] ? poll_select_copy_remaining+0x130/0x130
[70874.402233]  [<ffffffff816e9e00>] ? genl_family_rcv_msg+0x3d0/0x3d0
[70874.408491]  [<ffffffff816e9e91>] genl_rcv_msg+0x91/0xd0
[70874.413795]  [<ffffffff816e9131>] netlink_rcv_skb+0xc1/0xe0
[70874.419359]  [<ffffffff816e97dc>] genl_rcv+0x2c/0x40
[70874.424315]  [<ffffffff816e87d6>] netlink_unicast+0xf6/0x200
[70874.429966]  [<ffffffff816e8cf4>] netlink_sendmsg+0x414/0x670
[70874.435705]  [<ffffffff8169b63d>] sock_sendmsg+0x3d/0x50
[70874.441010]  [<ffffffff8169bfee>] ___sys_sendmsg+0x29e/0x2c0
[70874.446663]  [<ffffffff81231616>] ? fsnotify+0x306/0x490
[70874.451967]  [<ffffffff8169b354>] ? SYSC_recvfrom+0xd4/0x160
[70874.457617]  [<ffffffff8169c912>] __sys_sendmsg+0x42/0x80
[70874.463006]  [<ffffffff8169c962>] SyS_sendmsg+0x12/0x20
[70874.468224]  [<ffffffff817c7232>] system_call_fastpath+0x16/0x75
[70874.474222] Code: 84 bd 02 00 00 41 8b 86 9c 00 00 00 83 e0 0f 48
8d 0c c5 00 00 00 00 48 c1 e0 07 48 29 c8 4c 8d 7c 02 18 49 8b 47 48
49 8b 75 00 <48> 39 30 0f 85 fa 02 00 00 41 f6 46 28 08 74 08 49 8b 47
48 c6
[70874.493638] RIP  [<ffffffffc071d589>] ath_tx_start+0x129/0x450 [ath9k]
[70874.500166]  RSP <ffff8800c9df75a8>
[70874.503648] CR2: 0000000000000000
[70874.511427] ---[ end trace abdb98269f393a51 ]---
[70874.516037] Kernel panic - not syncing: Fatal exception in interrupt
[70874.522420] Kernel Offset: disabled
[70874.525902] drm_kms_helper: panic occurred, switching back to text console

BR
Janusz
