Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33427 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AVTkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 14:40:23 -0500
Received: by mail-ob0-f178.google.com with SMTP id eh20so7511941obb.9
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 11:40:23 -0800 (PST)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 22 Jan 2013 20:40:02 +0100
Message-ID: <CAG-2HqX=iYXLq9y2+brGP-KtPMh+nKUHttS3DEgPNJKHWVJquw@mail.gmail.com> (sfid-20130122_204027_292817_8C53C8D1)
Subject: WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7539 brcms_c_wait_for_tx_completion
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having some (occasional) problems using 3.8-rc4 (see output below).

I don't know if this is new, as it is the first kernel I try on this machine.

Please let me know if there is any additional info I can provide (or
patches to try).

Cheers,

Tom


[  566.256181] ------------[ cut here ]------------
[  566.256197] WARNING: at
drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]()
[  566.256199] Hardware name: MacBookAir5,1
[  566.256200] Modules linked in: efivars hid_generic mousedev
hid_apple usbhid bcm5974 brcmsmac cordic mac80211 snd_hda_codec_hdmi
snd_hda_codec_cirrus brcmutil i915 cfg80211 kvm_intel kvm rfkill
i2c_algo_bit snd_hda_intel intel_agp intel_gtt snd_hda_codec
drm_kms_helper snd_hwdep aesni_intel aes_x86_64 snd_pcm xhci_hcd
ehci_pci applesmc ehci_hcd input_polldev drm microcode led_class
snd_page_alloc snd_timer usbcore snd bcma agpgart soundcore usb_common
battery acpi_cpufreq mperf ac evdev processor
[  566.256234] Pid: 84, comm: kworker/u:7 Not tainted 3.8.0-rc4-TEG #2
[  566.256236] Call Trace:
[  566.256241]  [<ffffffff81043e9f>] warn_slowpath_common+0x7f/0xc0
[  566.256244]  [<ffffffff81043efa>] warn_slowpath_null+0x1a/0x20
[  566.256250]  [<ffffffffa04ca32b>]
brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]
[  566.256255]  [<ffffffffa04bd8ab>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[  566.256265]  [<ffffffffa04317b3>] ieee80211_scan_work+0x1b3/0x630 [mac80211]
[  566.256269]  [<ffffffff810615d2>] process_one_work+0x132/0x4f0
[  566.256273]  [<ffffffff81078cd1>] ? get_parent_ip+0x11/0x50
[  566.256282]  [<ffffffffa0431600>] ?
ieee80211_run_deferred_scan+0x90/0x90 [mac80211]
[  566.256285]  [<ffffffff81062cfd>] worker_thread+0x15d/0x450
[  566.256287]  [<ffffffff81062ba0>] ? busy_worker_rebind_fn+0x100/0x100
[  566.256290]  [<ffffffff81068d00>] kthread+0xc0/0xd0
[  566.256293]  [<ffffffff815f0000>] ? register_cpu+0x4e/0xc5
[  566.256296]  [<ffffffff81068c40>] ? kthread_create_on_node+0x130/0x130
[  566.256298]  [<ffffffff81602d1c>] ret_from_fork+0x7c/0xb0
[  566.256300]  [<ffffffff81068c40>] ? kthread_create_on_node+0x130/0x130
[  566.256302] ---[ end trace 2264c0238d7b0ba5 ]---
