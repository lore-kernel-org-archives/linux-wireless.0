Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34180 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965436AbcA0WZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 17:25:43 -0500
Received: by mail-ig0-f180.google.com with SMTP id ik10so660187igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 14:25:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <089e010d935cc850e4052a580ec2@google.com>
References: <CAP1NbjmewVTQ6KbY7fkgdhJ6iMSg0tO9g1P6Usymi3EmfmVA8w@mail.gmail.com>
	<089e010d935cc850e4052a580ec2@google.com>
Date: Wed, 27 Jan 2016 19:25:42 -0300
Message-ID: <CAP1Nbj=ch4m_egzhiSRksuaxnRc73AJdDzerJ2srnSW40X769g@mail.gmail.com> (sfid-20160127_232550_101670_819DC5C3)
Subject: Re: Delivery Status Notification (Failure)
From: =?UTF-8?B?QW5kcsOpIFZpdG9y?= <andrevdj@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jes Sorensen <jes.sorensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm having trouble with driver r8xxxu. My device has a realtek usb
wifi+bt combo (0bda:0724) built-in.
I can connect to a wifi network but if I open something that uses
connections the driver stops working with a mac80211 crash message.

OS used is Android-x86 with kernel 4.4.0.

I'm also CC'ing the driver's author as I contacted him earlier.

dmesg >
[   34.641610] ------------[ cut here ]------------
[   34.641701] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   34.641709] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   34.641852] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-android-x86+ #2
[   34.641859] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   34.641867]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
da4467c0 f637c7f8
[   34.641887]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f553b501 00000000
[   34.641906]  dee010b4 00000000 f82f815c f3f1e800 dee010b8 d48231d8
f637c420 ffffffff
[   34.641925] Call Trace:
[   34.641944]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   34.641958]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   34.642030]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   34.642042]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   34.642114]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   34.642178]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   34.642190]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   34.642201]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   34.642213]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   34.642225]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   34.642231]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   34.642278]  [<c1004121>] ? do_IRQ+0x88/0x99
[   34.642292]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   34.642306]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   34.642319]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   34.642332]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   34.642340] ---[ end trace 2226f818bc03f025 ]---
[   34.844354] ------------[ cut here ]------------
[   34.844407] WARNING: CPU: 0 PID: 7 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   34.844412] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   34.844494] CPU: 0 PID: 7 Comm: rcu_preempt Tainted: G        W
  4.4.0-android-x86+ #2
[   34.844498] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   34.844502]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d4ae3880 f637c7f8
[   34.844514]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f553b501 00000000
[   34.844524]  da4bdeb4 00000000 f82f815c f3f1e800 da4bdeb8 d4ae54d8
f3f45340 00200282
[   34.844535] Call Trace:
[   34.844548]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   34.844556]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   34.844595]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   34.844602]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   34.844641]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   34.844676]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   34.844682]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   34.844688]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   34.844695]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   34.844702]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   34.844705]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   34.844714]  [<c1004121>] ? do_IRQ+0x88/0x99
[   34.844722]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   34.844730]  [<c107e176>] ? run_timer_softirq+0x1ec/0x1ec
[   34.844737]  [<c14ef723>] ? schedule_timeout+0x58/0x192
[   34.844742]  [<c107de7f>] ? detach_if_pending+0xad/0xad
[   34.844750]  [<c1067760>] ? prepare_to_wait_event+0x9d/0xa5
[   34.844757]  [<c107a286>] ? rcu_gp_kthread+0x415/0x6d6
[   34.844763]  [<c1067824>] ? wait_woken+0x59/0x59
[   34.844769]  [<c1079e71>] ? rcu_cpu_notify+0x325/0x325
[   34.844776]  [<c104f318>] ? kthread+0xae/0xb3
[   34.844783]  [<c14f0289>] ? ret_from_kernel_thread+0x21/0x38
[   34.844789]  [<c104f26a>] ? kthread_create_on_node+0x100/0x100
[   34.844794] ---[ end trace 2226f818bc03f026 ]---
[   35.620254] ------------[ cut here ]------------
[   35.620315] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   35.620321] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   35.620406] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
4.4.0-android-x86+ #2
[   35.620412] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   35.620416]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d4979340 f637c7f8
[   35.620445]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f553b501 00000000
[   35.620455]  dee010b4 00000000 f82f815c f3f1e800 dee010b8 d494b898
f637c420 ffffffff
[   35.620466] Call Trace:
[   35.620477]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   35.620486]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   35.620525]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   35.620532]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   35.620571]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   35.620606]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   35.620613]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   35.620619]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   35.620626]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   35.620641]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   35.620656]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   35.620680]  [<c1004121>] ? do_IRQ+0x88/0x99
[   35.620688]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   35.620696]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   35.620704]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   35.620711]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   35.620716] ---[ end trace 2226f818bc03f027 ]---
[   35.621359] ------------[ cut here ]------------
[   35.621413] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   35.621418] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   35.621490] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
4.4.0-android-x86+ #2
[   35.621496] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   35.621499]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d4ae3280 f637c7f8
[   35.621527]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
c17b5650 00200282
[   35.621537]  00000000 00000000 c10674fa 00000000 00000000 00000001
00000003 f676ca40
[   35.621547] Call Trace:
[   35.621554]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   35.621561]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   35.621600]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   35.621606]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   35.621645]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   35.621651]  [<c10674fa>] ? __wake_up+0x2c/0x3b
[   35.621685]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   35.621700]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   35.621717]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   35.621731]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   35.621743]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   35.621746]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   35.621755]  [<c1004121>] ? do_IRQ+0x88/0x99
[   35.621762]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   35.621768]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   35.621775]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   35.621781]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   35.621785] ---[ end trace 2226f818bc03f028 ]---
[   69.347231] binder: 2988:2996 refcount change on invalid ref 10
[   69.386497] ------------[ cut here ]------------
[   69.386552] WARNING: CPU: 0 PID: 1147 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   69.386556] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   69.386640] CPU: 0 PID: 1147 Comm: loop1 Tainted: G        W
4.4.0-android-x86+ #2
[   69.386643] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   69.386648]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d077f880 f637c7f8
[   69.386659]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
c17b5bd0 00000282
[   69.386669]  00000000 00000000 c10674fa 00000000 00000000 00000001
00000003 f676cc80
[   69.386680] Call Trace:
[   69.386692]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   69.386700]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   69.386740]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   69.386747]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   69.386786]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   69.386793]  [<c10674fa>] ? __wake_up+0x2c/0x3b
[   69.386827]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   69.386834]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   69.386840]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   69.386847]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   69.386854]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   69.386857]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   69.386867]  [<c1004121>] ? do_IRQ+0x88/0x99
[   69.386874]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   69.386883]  [<c110a63a>] ? atime_needs_update+0x6/0x99
[   69.386889]  [<c110a6e2>] ? touch_atime+0x15/0x7c
[   69.386896]  [<c10c77e1>] ? generic_file_read_iter+0x485/0x56e
[   69.386904]  [<c10f7914>] ? vfs_iter_read+0x59/0x84
[   69.386913]  [<c12cd92a>] ? loop_queue_work+0x52a/0x783
[   69.386920]  [<c1053e07>] ? finish_task_switch+0x11f/0x174
[   69.386928]  [<c104f3b2>] ? kthread_worker_fn+0x95/0x108
[   69.386933]  [<c104f31d>] ? kthread+0xb3/0xb3
[   69.386939]  [<c104f318>] ? kthread+0xae/0xb3
[   69.386946]  [<c14f0289>] ? ret_from_kernel_thread+0x21/0x38
[   69.386952]  [<c104f26a>] ? kthread_create_on_node+0x100/0x100
[   69.386957] ---[ end trace 2226f818bc03f029 ]---
[   69.387624] ------------[ cut here ]------------
[   69.387673] WARNING: CPU: 0 PID: 1147 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   69.387677] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   69.387758] CPU: 0 PID: 1147 Comm: loop1 Tainted: G        W
4.4.0-android-x86+ #2
[   69.387761] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   69.387765]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d4aeba00 f637c7f8
[   69.387776]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
c107e320 f580ea04
[   69.387786]  00000282 00000000 f676cc80 c17b5a40 c17b5a40 f676cc80
c1079533 c17b5a40
[   69.387797] Call Trace:
[   69.387807]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   69.387815]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   69.387854]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   69.387861]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   69.387900]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   69.387907]  [<c107e320>] ? internal_add_timer+0x24/0x5b
[   69.387914]  [<c1079533>] ? __note_gp_changes+0x26/0x80
[   69.387948]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   69.387954]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   69.387960]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   69.387967]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   69.387973]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   69.387977]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   69.387986]  [<c1004121>] ? do_IRQ+0x88/0x99
[   69.387995]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   69.388004]  [<c120d23e>] ? inflate_fast+0x3dc/0x537
[   69.388012]  [<c120ddda>] ? zlib_inflate+0x8dc/0x108d
[   69.388020]  [<c1197c87>] ? zlib_uncompress+0xb1/0x123
[   69.388025]  [<c1197117>] ? squashfs_decompress+0x35/0x5e
[   69.388033]  [<c1193fb5>] ? squashfs_read_data+0x405/0x501
[   69.388040]  [<c1194200>] ? squashfs_cache_get+0x14f/0x267
[   69.388046]  [<c1194200>] ? squashfs_cache_get+0x14f/0x267
[   69.388054]  [<c1194745>] ? squashfs_get_datablock+0x17/0x1c
[   69.388060]  [<c1194745>] ? squashfs_get_datablock+0x17/0x1c
[   69.388066]  [<c1197022>] ? squashfs_readpage_block+0x1c/0x5e
[   69.388072]  [<c11955a2>] ? squashfs_readpage+0x5de/0x702
[   69.388079]  [<c10c6bdf>] ? add_to_page_cache_lru+0x78/0x80
[   69.388087]  [<c10cecbf>] ? __do_page_cache_readahead+0x163/0x18e
[   69.388093]  [<c10cecbf>] ? __do_page_cache_readahead+0x163/0x18e
[   69.388100]  [<c10cf024>] ? page_cache_sync_readahead+0x34/0x3a
[   69.388106]  [<c10c753f>] ? generic_file_read_iter+0x1e3/0x56e
[   69.388113]  [<c10f7914>] ? vfs_iter_read+0x59/0x84
[   69.388121]  [<c12cd92a>] ? loop_queue_work+0x52a/0x783
[   69.388127]  [<c1053e07>] ? finish_task_switch+0x11f/0x174
[   69.388135]  [<c104f3b2>] ? kthread_worker_fn+0x95/0x108
[   69.388141]  [<c104f31d>] ? kthread+0xb3/0xb3
[   69.388147]  [<c104f318>] ? kthread+0xae/0xb3
[   69.388154]  [<c14f0289>] ? ret_from_kernel_thread+0x21/0x38
[   69.388160]  [<c104f26a>] ? kthread_create_on_node+0x100/0x100
[   69.388165] ---[ end trace 2226f818bc03f02a ]---
[   70.718431] ------------[ cut here ]------------
[   70.718485] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   70.718489] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   70.718575] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
4.4.0-android-x86+ #2
[   70.718579] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   70.718583]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d07f6400 f637c7f8
[   70.718595]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f553b500 00200282
[   70.718605]  00000000 00000000 00000000 d07f6e80 f637c420 f553b500
f3f1e800 f57bf600
[   70.718616] Call Trace:
[   70.718628]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   70.718637]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   70.718676]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   70.718683]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   70.718722]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   70.718755]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   70.718762]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   70.718768]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   70.718775]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   70.718782]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   70.718785]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   70.718794]  [<c1004121>] ? do_IRQ+0x88/0x99
[   70.718802]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   70.718810]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   70.718818]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   70.718826]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   70.718831] ---[ end trace 2226f818bc03f02b ]---
[   72.777303] ------------[ cut here ]------------
[   72.777457] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   72.777469] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   72.777609] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
4.4.0-android-x86+ #2
[   72.777613] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   72.777617]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
c987b1c0 f637c7f8
[   72.777640]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f3f1e800 00000000
[   72.777650]  00000000 00000000 00000000 ded10a00 f637c420 f553b500
f3f1e800 f57bfa00
[   72.777661] Call Trace:
[   72.777672]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   72.777680]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   72.777719]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   72.777726]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   72.777764]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   72.777803]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   72.777820]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   72.777835]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   72.777842]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   72.777848]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   72.777852]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   72.777861]  [<c1004121>] ? do_IRQ+0x88/0x99
[   72.777868]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   72.777877]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   72.777885]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   72.777892]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   72.777897] ---[ end trace 2226f818bc03f02c ]---
[   73.592703] ------------[ cut here ]------------
[   73.592756] WARNING: CPU: 0 PID: 0 at
/home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
ieee80211_rx_napi+0x63/0x60f [mac80211]()
[   73.592760] Modules linked in: hid_sensor_accel_3d hid_sensor_als
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper
drm fb_sys_fops sysfillrect syscopyarea sysimgblt i2c_algo_bit
hid_sensor_hub hid_multitouch dw_dmac dw_dmac_core i2c_hid
i2c_designware_platform i2c_designware_core snd_soc_sst_acpi 8250_dw
pwm_lpss_platform pwm_lpss snd_soc_rt5640 snd_soc_rl6231 snd_soc_core
snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore
ac97_bus
[   73.592844] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
4.4.0-android-x86+ #2
[   73.592847] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
[   73.592852]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
d07d9580 f637c7f8
[   73.592863]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
f6764cfc 00000000
[   73.592873]  00000000 00000000 00200046 00000000 c190fb18 c190fb08
00200202 00000000
[   73.592884] Call Trace:
[   73.592895]  [<c14e8b20>] ? dump_stack+0x45/0x65
[   73.592905]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
[   73.592944]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   73.592951]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
[   73.592989]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
[   73.592996]  [<c107ae2d>] ? call_rcu_sched+0xc/0xe
[   73.593030]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e [mac80211]
[   73.593036]  [<c103f04c>] ? tasklet_action+0x78/0x81
[   73.593042]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
[   73.593049]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
[   73.593056]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
[   73.593059]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
[   73.593069]  [<c1004121>] ? do_IRQ+0x88/0x99
[   73.593076]  [<c14f0a69>] ? common_interrupt+0x29/0x30
[   73.593084]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
[   73.593092]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
[   73.593099]  [<c1833a41>] ? start_kernel+0x35b/0x35e
[   73.593103] ---[ end trace 2226f818bc03f02d ]---
[   77.274423] ieee80211 phy0: wlan0: No probe response from AP
00:1a:3f:91:26:e0 after 500ms, disconnecting.
[   77.351726] wlan0: authenticate with 00:1a:3f:91:26:e0
[   77.355209] wlan0: send auth to 00:1a:3f:91:26:e0 (try 1/3)
[   77.555281] wlan0: send auth to 00:1a:3f:91:26:e0 (try 2/3)
[   77.756779] wlan0: send auth to 00:1a:3f:91:26:e0 (try 3/3)
[   77.958465] wlan0: authentication with 00:1a:3f:91:26:e0 timed out
