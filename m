Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34314 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbcA2UTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 15:19:50 -0500
Received: by mail-qg0-f45.google.com with SMTP id 6so74606541qgy.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 12:19:50 -0800 (PST)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: rtl8xxxu (mac80211) not working with rtl8723au
To: =?UTF-8?Q?Andr=c3=a9_Vitor?= <andrevdj@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAP1NbjnOYorDuoTcsEUX76Ei0jievissNNNf=WN_uuwZNiRkwg@mail.gmail.com>
 <CAP1NbjmewVTQ6KbY7fkgdhJ6iMSg0tO9g1P6Usymi3EmfmVA8w@mail.gmail.com>
Message-ID: <56ABC964.10808@gmail.com> (sfid-20160129_211954_867665_4C860B5B)
Date: Fri, 29 Jan 2016 15:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAP1NbjmewVTQ6KbY7fkgdhJ6iMSg0tO9g1P6Usymi3EmfmVA8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/16 17:09, André Vitor wrote:
> Hi all,
> 
> I'm having trouble with driver r8xxxu. My device has a realtek usb wifi+bt
> combo (0bda:0724) built-in.
> I can connect to a wifi network but if I open something that uses
> connections the driver stops working with a mac80211 crash message.
> 
> OS used is Android-x86 with kernel 4.4.0.
> 
> I'm also CC'ing the driver's author as I contacted him earlier.
> 
> dmesg >
> [   34.641610] ------------[ cut here ]------------
> [   34.641701] WARNING: CPU: 0 PID: 0 at
> /home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
> ieee80211_rx_napi+0x63/0x60f [mac80211]()
> [   34.641709] Modules linked in: hid_sensor_accel_3d hid_sensor_als
> hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation
> hid_sensor_gyro_3d hid_sensor_trigger industrialio_triggered_buffer
> kfifo_buf industrialio hid_sensor_iio_common hid_sensor_custom mac_hid
> rtl8xxxu mac80211 cfg80211 atkbd pcspkr efivars snd_hda_codec_hdmi
> snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich snd_hda_intel
> snd_hda_codec snd_hda_core snd_hwdep i915 drm_kms_helper drm fb_sys_fops
> sysfillrect syscopyarea sysimgblt i2c_algo_bit hid_sensor_hub
> hid_multitouch dw_dmac dw_dmac_core i2c_hid i2c_designware_platform
> i2c_designware_core snd_soc_sst_acpi 8250_dw pwm_lpss_platform pwm_lpss
> snd_soc_rt5640 snd_soc_rl6231 snd_soc_core snd_compress snd_pcm_dmaengine
> snd_pcm snd_timer snd soundcore ac97_bus
> [   34.641852] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-android-x86+
> #2
> [   34.641859] Hardware name: Zmax B10T/B10T, BIOS 5.6.5 11/22/2013
> [   34.641867]  00000000 c14e8b20 00000000 c103bae0 f91a9291 00000e23
> da4467c0 f637c7f8
> [   34.641887]  f637c7e8 f637c420 c103bb58 00000009 00000000 f91a9291
> f553b501 00000000
> [   34.641906]  dee010b4 00000000 f82f815c f3f1e800 dee010b8 d48231d8
> f637c420 ffffffff
> [   34.641925] Call Trace:
> [   34.641944]  [<c14e8b20>] ? dump_stack+0x45/0x65
> [   34.641958]  [<c103bae0>] ? warn_slowpath_common+0x8a/0x9f
> [   34.642030]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
> [   34.642042]  [<c103bb58>] ? warn_slowpath_null+0xd/0x10
> [   34.642114]  [<f91a9291>] ? ieee80211_rx_napi+0x63/0x60f [mac80211]
> [   34.642178]  [<f918d1d1>] ? ieee80211_tasklet_handler+0x4f/0x8e
> [mac80211]
> [   34.642190]  [<c103f04c>] ? tasklet_action+0x78/0x81
> [   34.642201]  [<c103ea69>] ? __do_softirq+0xb9/0x21c
> [   34.642213]  [<c103e9b0>] ? __tasklet_hrtimer_trampoline+0x27/0x27
> [   34.642225]  [<c100467f>] ? do_softirq_own_stack+0x1a/0x1f
> [   34.642231]  <IRQ>  [<c103ecf8>] ? irq_exit+0x31/0x70
> [   34.642278]  [<c1004121>] ? do_IRQ+0x88/0x99
> [   34.642292]  [<c14f0a69>] ? common_interrupt+0x29/0x30
> [   34.642306]  [<c13b0678>] ? cpuidle_enter_state+0x16a/0x2a7
> [   34.642319]  [<c1067bb4>] ? cpu_startup_entry+0x197/0x280
> [   34.642332]  [<c1833a41>] ? start_kernel+0x35b/0x35e
> [   34.642340] ---[ end trace 2226f818bc03f025 ]---
> [   34.844354] ------------[ cut here ]------------

This part looks suspicious to me - this is the NAPI stack spitting out
slowpath warnings.

Johannes, have you seen this kind of trace before?

I am curious if this could be the Android mods that halts certain
processing or if it's something I did wrong in the driver.

Jes

