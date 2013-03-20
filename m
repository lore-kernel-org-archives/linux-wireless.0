Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4985 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689Ab3CTOyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 10:54:06 -0400
Message-ID: <5149CD81.40301@broadcom.com> (sfid-20130320_155416_331137_79B68E9F)
Date: Wed, 20 Mar 2013 15:53:53 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Spinadel" <dvdspndl@gmail.com>
cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: rcutree tree warning during P2P device support testing
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am testing the P2P device support patches. Upon stopping the
wpa_supplicant I get the following warning and when I unload brcmfmac it
hangs resulting in hung_task_timeout message. The whole rcu stuff still
needs to settle in my brain. I suspect the warning is related to
brcmfmac unload failure, but maybe you have some ideas where I should look.

Gr. AvS

[ 1634.031570] ------------[ cut here ]------------
[ 1634.039095] WARNING: at kernel/rcutree.c:1960
rcu_process_callbacks+0x469/0x560()
[ 1634.049534] Hardware name: Latitude E6410
[ 1634.056474] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O)
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device dell_laptop dell_wmi
psmouse coretemp intel_ips serio_raw snd lpc_ich mfd_core sparse_keymap
dcdbas soundcore snd_page_alloc microcode nouveau ttm drm_kms_helper drm
i2c_algo_bit mxm_wmi sdhci_pci crc32c_intel firewire_ohci ahci sdhci
firewire_core libahci crc_itu_t mmc_core e1000e ptp video pps_core
intel_agp intel_gtt agpgart
[ 1634.120601] Pid: 16, comm: ksoftirqd/2 Tainted: G           O
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[ 1634.133917] Call Trace:
[ 1634.139833]  [<c1039c92>] warn_slowpath_common+0x72/0xa0
[ 1634.148659]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
[ 1634.157914]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
[ 1634.167121]  [<c1039ce2>] warn_slowpath_null+0x22/0x30
[ 1634.175725]  [<c10c61f9>] rcu_process_callbacks+0x469/0x560
[ 1634.184783]  [<c1042217>] __do_softirq+0xb7/0x240
[ 1634.192952]  [<c15279e0>] ? restore_all+0xf/0xf
[ 1634.200919]  [<c10423dd>] run_ksoftirqd+0x3d/0x70
[ 1634.209076]  [<c1063605>] smpboot_thread_fn+0x115/0x190
[ 1634.217753]  [<c10634f0>] ? lg_lock_init+0x20/0x20
[ 1634.225973]  [<c105b67f>] kthread+0x9f/0xb0
[ 1634.233570]  [<c1060000>] ? down_write_trylock+0x60/0x60
[ 1634.242289]  [<c152eab7>] ret_from_kernel_thread+0x1b/0x28
[ 1634.251185]  [<c105b5e0>] ? flush_kthread_work+0x150/0x150
[ 1634.260087] ---[ end trace c5c2a2c787d3190d ]---
[ 2262.659502] dell_wmi: Received unknown WMI event (0x11)

arend@arend-lp-dev:~/sync$ [ 3376.163334] dell_wmi: Received unknown WMI
event (0x11)
[ 3422.313946] usb 2-1.3: USB disconnect, device number 3
[ 3422.322096] brcmfmac: brcmf_usb_intr_complete: intr cb when DBUS
down, ignoring
[ 3422.332819] brcmfmac: brcmf_fil_cmd_data: bus is down. we have
nothing to do.
[ 3431.537907] brcmfmac: brcmf_fil_cmd_data: bus is down. we have
nothing to do.
[ 3431.545565] usbcore: deregistering interface driver brcmfmac
[ 3606.381631] INFO: task khubd:30 blocked for more than 120 seconds.
[ 3606.388366] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3606.396931] khubd           D f4f01cd8     0    30      2 0x00000000
[ 3606.403609]  f4f01d10 00000092 00000000 f4f01cd8 00000246 c1748000
c183fb40 c183fb40
[ 3606.411731]  d46b6273 0000031c f53e7b40 f4d323c0 c1748000 00000246
00000000 f0820090
[ 3606.419807]  00000246 f4f01cd8 00000046 00000001 00000046 00000000
00000002 f0820090
[ 3606.427881] Call Trace:
[ 3606.430518]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[ 3606.435907]  [<c1525ff3>] schedule+0x23/0x60
[ 3606.440402]  [<f8230c65>] wiphy_unregister+0xa5/0x2e0 [cfg80211]
[ 3606.446600]  [<c105be00>] ? __init_waitqueue_head+0x60/0x60
[ 3606.452451]  [<f8356db5>] brcmf_free_vif+0x55/0x70 [brcmfmac]
[ 3606.458389]  [<f8357405>] brcmf_cfg80211_detach+0x45/0x70 [brcmfmac]
[ 3606.464955]  [<f8361351>] brcmf_del_if+0x81/0x170 [brcmfmac]
[ 3606.470803]  [<f836177e>] brcmf_detach+0x5e/0xd0 [brcmfmac]
[ 3606.476572]  [<f836bcd3>] brcmf_usb_disconnect+0x63/0xa0 [brcmfmac]
[ 3606.483093]  [<c13daf3a>] usb_unbind_interface+0x4a/0x180
[ 3606.488706]  [<c136e704>] __device_release_driver+0x64/0xc0
[ 3606.494472]  [<c136e786>] device_release_driver+0x26/0x40
[ 3606.500121]  [<c136e245>] bus_remove_device+0xa5/0xd0
[ 3606.505385]  [<c136bdfd>] device_del+0xdd/0x150
[ 3606.510108]  [<c13d8cf9>] usb_disable_device+0x89/0x1c0
[ 3606.515590]  [<c13d14d3>] usb_disconnect+0x93/0x160
[ 3606.520681]  [<c13d28c0>] hub_thread+0x2c0/0x1160
[ 3606.525580]  [<c1525318>] ? __schedule+0x3a8/0x7e0
[ 3606.530583]  [<c105be00>] ? __init_waitqueue_head+0x60/0x60
[ 3606.536437]  [<c1064cae>] ? complete+0x4e/0x60
[ 3606.541105]  [<c13d2600>] ? hub_port_debounce+0xd0/0xd0
[ 3606.546609]  [<c105b67f>] kthread+0x9f/0xb0
[ 3606.551017]  [<c1060000>] ? down_write_trylock+0x60/0x60
[ 3606.556553]  [<c152eab7>] ret_from_kernel_thread+0x1b/0x28
[ 3606.562287]  [<c105b5e0>] ? flush_kthread_work+0x150/0x150
[ 3606.568015] INFO: lockdep is turned off.
[ 3606.572176] INFO: task rmmod:2686 blocked for more than 120 seconds.
[ 3606.578814] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3606.586870] rmmod           D f2727e08     0  2686   2685 0x00000000
[ 3606.593483]  f2727e64 00000086 f44f9604 f2727e08 f71128d0 c1748000
c183fb40 c183fb40
[ 3606.601597]  f86cc1e4 0000031e f53e7b40 f44f91e0 c1748000 f72a89b4
f2727e28 00000282
[ 3606.609753]  f44f91e0 f44f91e0 f7112898 00000000 00000000 f2727e74
00000246 00000000
[ 3606.617897] Call Trace:
[ 3606.620545]  [<c136eea8>] ? driver_detach+0x38/0xa0
[ 3606.625654]  [<c1525ff3>] schedule+0x23/0x60
[ 3606.630393]  [<c15262c8>] schedule_preempt_disabled+0x18/0x30
[ 3606.636356]  [<c1523b9d>] mutex_lock_nested+0x13d/0x2e0
[ 3606.641882]  [<c136eea8>] ? driver_detach+0x38/0xa0
[ 3606.647016]  [<c136eea8>] driver_detach+0x38/0xa0
[ 3606.651950]  [<c136e543>] bus_remove_driver+0x63/0xa0
[ 3606.657288]  [<c136f4f8>] driver_unregister+0x48/0x80
[ 3606.662565]  [<c13da1bd>] usb_deregister+0x5d/0xb0
[ 3606.667648]  [<f836d049>] brcmf_usb_exit+0x49/0x90 [brcmfmac]
[ 3606.673625]  [<f836ba00>] ? brcmf_usb_ctlwrite_complete+0x90/0x90
[brcmfmac]
[ 3606.680906]  [<f836dd6d>] brcmfmac_module_exit+0x17/0x1e [brcmfmac]
[ 3606.687430]  [<c10a0485>] sys_delete_module+0x135/0x200
[ 3606.692901]  [<c111f686>] ? vm_munmap+0x46/0x60
[ 3606.697661]  [<c105ff5b>] ? up_write+0x1b/0x30
[ 3606.702362]  [<c111f686>] ? vm_munmap+0x46/0x60
[ 3606.707199]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[ 3606.712388] INFO: lockdep is turned off.

