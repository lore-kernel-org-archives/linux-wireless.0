Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55121 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2H0N0D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 09:26:03 -0400
Received: from aldoreel ([79.198.116.157]) by smtp.web.de (mrweb003) with
 ESMTPSA (Nemesis) id 0LsQQK-1TlpQn1mPY-012NfT for
 <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 15:26:01 +0200
Date: Mon, 27 Aug 2012 15:25:59 +0200
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac: BCM43224 trace of a warning
Message-ID: <20120827152559.0b8a9502@aldoreel> (sfid-20120827_152607_901282_E3CD2F7C)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just found the following in my dmesg output:
[  999.752979] ------------[ cut here ]------------
[  999.753001] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7993 brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]()
[  999.753004] Hardware name: Vostro 3500
[  999.753005] Modules linked in: parport_pc ppdev lp parport af_packet fuse arc4 snd_hda_codec_hdmi nouveau snd_hda_codec_idt snd_hda_intel cfbfillrect cfbimgblt mxm_wmi cfbcopyarea i2c_algo_bit brcmsmac drm_kms_helper ttm drm cordic brcmutil agpgart mac80211 snd_hda_codec sg i2c_i801 i2c_core ehci_hcd usbcore snd_pcm snd_page_alloc sr_mod cdrom coretemp cfg80211 snd_timer snd soundcore rfkill dell_wmi sparse_keymap kvm_intel kvm evdev usb_common psmouse r8169 pcspkr dell_laptop acpi_cpufreq mperf dcdbas bcma battery ac serio_raw crc32c_intel mii button wmi processor sd_mod microcode thermal ahci libahci libata scsi_mod
[  999.753064] Pid: 698, comm: kworker/u:5 Not tainted 3.6.0-rc3-wl-00079-g90c76a9 #1
[  999.753066] Call Trace:
[  999.753075]  [<ffffffff8103c339>] ? warn_slowpath_common+0x79/0xc0
[  999.753085]  [<ffffffffa061e9c1>] ? brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]
[  999.753090]  [<ffffffffa06111b2>] ? brcms_ops_flush+0x32/0x50 [brcmsmac]
[  999.753102]  [<ffffffffa056e98c>] ? ieee80211_mgd_probe_ap.part.42+0x12c/0x150 [mac80211]
[  999.753111]  [<ffffffffa056f91d>] ? ieee80211_beacon_connection_loss_work+0x8d/0x130 [mac80211]
[  999.753116]  [<ffffffff81054157>] ? process_one_work+0x127/0x450
[  999.753121]  [<ffffffff81052356>] ? cwq_activate_first_delayed+0x26/0x40
[  999.753130]  [<ffffffffa056f890>] ? ieee80211_set_disassoc+0x3a0/0x3a0 [mac80211]
[  999.753133]  [<ffffffff81054aad>] ? worker_thread+0x15d/0x420
[  999.753138]  [<ffffffff810682ca>] ? sched_move_task+0xba/0x1a0
[  999.753141]  [<ffffffff81054950>] ? manage_workers.isra.27+0x280/0x280
[  999.753146]  [<ffffffff810598b5>] ? kthread+0x85/0x90
[  999.753154]  [<ffffffff8141c574>] ? kernel_thread_helper+0x4/0x10
[  999.753158]  [<ffffffff81059830>] ? kthread_freezable_should_stop+0x50/0x50
[  999.753161]  [<ffffffff8141c570>] ? gs_change+0xb/0xb
[  999.753163] ---[ end trace b305ccae444fa33f ]---

I do not really know what I did, when the warning was triggered but
maybe the warning will be of interest nevertheless. I am using 3.6-rc3 +
wireless-testing/master as of yesterday (August 26th 2012). If
you need more information, please feel free to ask; if you have some
hints, on how to find what caused the problem, please tell me.

With best regards,
Julian Wollrath
