Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:33969 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936086AbdD0Qfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 12:35:46 -0400
Received: by mail-yb0-f196.google.com with SMTP id l192so1570257ybl.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 09:35:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59070fb5-a5c0-a52f-fb47-2a5caeb9ea30@lwfinger.net>
References: <CAFXWsS9fNn=YF--408O=weoNHfAv+g+CXJ8Df8=BC4m4Lt1aSg@mail.gmail.com>
 <CAFXWsS9rNZ1QWt_CNK-gOfb1Mqwch25XxB43d6B_8SX76vBW4Q@mail.gmail.com>
 <1493300827.2281.13.camel@hadess.net> <CAFXWsS98BbApyuYzFNhhXKzSRv=oE4GfoTFO1wBbjyKBidW92A@mail.gmail.com>
 <1493301943.2281.14.camel@hadess.net> <CAFXWsS_jYO+ttoS0QyAmLzDEMDrwbXhgznm-AGMKGGED3fgGZg@mail.gmail.com>
 <59070fb5-a5c0-a52f-fb47-2a5caeb9ea30@lwfinger.net>
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Fri, 28 Apr 2017 02:35:44 +1000
Message-ID: <CAFXWsS_eduLG1SLxa8z5T1bGETx8gYXgfwANWBTcfXnnPxb6TQ@mail.gmail.com> (sfid-20170427_183551_363785_E06BF197)
Subject: Re: [PATCH] staging: rtl8723bs: Revert ignoring_unreachable_code kfree
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bastien Nocera <hadess@hadess.net>, linux-wireless@vger.kernel.org,
        jes.sorensen@gmail.com, Hans de Goede <hdegoede@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2017 at 01:58, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/27/2017 09:41 AM, Ian W MORRISON wrote:
>>
>> Here's hoping this is what you want. If not let me know what info you'd
>> like me
>> to provide. For this info I just built the r8723bs.ko module from
>> linux-next
>> commit 6557ddf.
>>
>> Commit trace from 'git log --oneline --follow drivers/staging/rtl8723bs':
>>
>> d9c7dd5 staging: rtl8723bs: clean up identical code on an if statement
>> ff8d351 staging: rtl8723bs: remove redundant comparisons of unsigned ints
>> with >= 0
>> 2e85ccf staging: rtl8723bs: ensure cmd is large enough for %4s scanf
>> format
>> b388285 staging: rtl8723bs: fix spelling mistake: "acquire"
>> 103ab68 staging: rtl8723bs: fix spelling mistakes in RT_TRACE messages
>> 1e7605e staging: rtl8723bs: force driver to be built as a module.
>> 7ad61a3 staging: rtl8723bs: remove null test before kfree
>> 9ddf6e3 staging: rtl8723bs: Add missing include <linux/of.h> to fix
>> compile error
>> 6cb3d05 staging: rtl8723bs: core: rtw_cmd: drop unneeded null tests
>> f951e88 staging: rtl8723bs: core: rtw_cmd: drop unneeded null test
>> 1c21a34 staging: rtl8723bs: Fix indenting error in core/rtw_pwrctrl.c
>> bd51edb staging: rtl8723bs: Fix indenting problems in core/rtw_odm.c
>> ef9209b staging: rtl8723bs: Fix indenting errors and an off-by-one mistake
>> in
>> core/rtw_mlme_ext.c
>> 3498d68 staging: rtl8723bs: Fix white-space errors in core/rtw_recv.c
>> 0ba8d4b staging: rtl8723bs: Fix some white-space errors in
>> core/rtw_security.c
>> aa29d8b staging: rtl8723bs: Fix indenting problem in core/rtw_sta_mgt.c
>> 130cf72 staging: rtl8723bs: Fix some indenting problems and a potential
>> data overrun
>> 5004922 staging: rtl8723bs: Fix indenting mistakes in core/rtw_mlme.c
>> b7126fa staging: rtl8723bs: Fix indenting mistakes in core/rtw_ieee80211.c
>> 9c63e98 staging: rtl8723bs: Fix indenting mistake in core/rtw_ap.c
>> 21a9509 staging: rtl8723bs: Fix possible usage of NULL pointer in
>> core/rtw_debug.c
>> f195f7d staging: rtl8723bs: Fix indenting problems in core/rtw_xmit.c
>> 1793db1 staging: rtl8723bs: Fix indenting problem for hal/hal_com.c
>> 0952abb staging: rtl8723bs: Fix indening problem in hal/hal_com_phycfg.c
>> d9be201 staging: rtl8723bs: Fix indenting problems in
>> hal/HalHWImg8723B_BB.c
>> 7e2b0aa staging: rtl8723bs: Fix potential usage while NULL error in
>> hal/rtl8723b_hal_init.c
>> 6557ddf staging: rtl8723bs: Fix various errors in os_dep/ioctl_cfg80211.c
>> e62bb92 staging: rtl8723bs: Fix indenting mistake in os_dep/mlme_linux.c
>> 72544c5f staging: rtl8723bs: Fix indenting warning in os_dep/os_intfs.c
>> 2679a3f staging: rtl8723bs: Fix dereference before check warning in
>> os_dep/recv_linux.c
>> c49c1f2 staging: rtl8723bs: Fix indenting warning in os_dep/rtw_proc.c
>> 9ad88c7 staging: rtl8723bs: Fix indenting warning in os_dep/xmit_linux.c
>> 554c0a3 staging: Add rtl8723bs sdio wifi driver
>>
>> Any build from commit from d9c7dd5 to 6557ddf fail but commit e62bb92 to
>> 554c0a3
>> work. Within commit 6557ddf with the fix for kfree() fails, without it
>> works.
>>
>> Command line:
>>
>> root@ubuntu:~# cp r8723bs.ko-6557ddf r8723bs.ko
>> root@ubuntu:~# modinfo r8723bs.ko | grep depends
>> depends:        cfg80211
>> root@ubuntu:~# modprobe cfg80211
>> root@ubuntu:~# insmod r8723bs.ko
>> Segmentation fault
>> root@ubuntu:~#
>>
>> Extract from tail of dmesg:
>>
>> [  223.557686] r8723bs: loading out-of-tree module taints kernel.
>> [  223.558971] r8723bs: module verification failed: signature and/or
>> required
>> key missing - tainting kernel
>> [  223.565310] RTL8723BS: module init start
>> [  223.565318] RTL8723BS: rtl8723bs
>> v4.3.5.5_12290.20140916_BTCOEX20140507-4E40
>> [  223.565322] RTL8723BS: rtl8723bs BT-Coex version = BTCOEX20140507-4E40
>> [  223.665558] pnetdev = ffff8eb19e872000
>> [  223.732589] RTL8723BS: rtw_ndev_init(wlan0)
>> [  223.732662] ------------[ cut here ]------------
>> [  223.732741] kernel BUG at
>> /home/kernel/COD/linux/net/wireless/core.h:108!
>> [  223.732824] invalid opcode: 0000 [#1] SMP
>> [  223.732873] Modules linked in: r8723bs(OE+) cfg80211 bnep axp20x_pek
>> axp288_charger axp288_fuel_gauge extcon_axp288 axp288_adc gpio_keys
>> intel_spi_platform intel_spi spi_nor mtd intel_rapl intel_soc_dts_thermal
>> intel_soc_dts_iosf intel_powerclamp coretemp kvm_intel kvm cdc_ether
>> usbnet
>> irqbypass punit_atom_debug r8152 crct10dif_pclmul crc32_pclmul joydev mii
>> ghash_clmulni_intel snd_intel_sst_acpi input_leds pcbc aesni_intel
>> snd_soc_rt5670 snd_intel_sst_core aes_x86_64 snd_soc_rt5645 crypto_simd
>> snd_soc_sst_atom_hifi2_platform glue_helper snd_soc_rt5640 cryptd
>> snd_soc_sst_match bmc150_accel_spi bmc150_accel_i2c intel_cstate
>> snd_seq_midi
>> snd_soc_rl6231 snd_soc_tlv320aic31xx bmc150_accel_core snd_soc_core
>> snd_seq_midi_event industrialio_triggered_buffer kfifo_buf axp20x_i2c
>> hci_uart
>> axp20x snd_rawmidi
>> [  223.733721]  snd_hdmi_lpe_audio industrialio snd_compress ac97_bus
>> snd_pcm_dmaengine btbcm btqca snd_pcm btintel snd_seq snd_seq_device
>> bluetooth
>> snd_timer mac_hid soc_button_array dw_dmac dw_dmac_core rfkill_gpio
>> mei_txe snd
>> acpi_pad i2c_designware_platform mei soundcore i2c_designware_core lpc_ich
>> pwm_lpss_platform spi_pxa2xx_platform pwm_lpss 8250_dw parport_pc ppdev lp
>> parport ip_tables x_tables autofs4 isofs nls_iso8859_1 hid_logitech_hidpp
>> dm_mirror dm_region_hash dm_log hid_logitech_dj overlay hid_generic usbhid
>> uas
>> usb_storage i915 i2c_algo_bit mmc_block drm_kms_helper syscopyarea
>> sysfillrect
>> sysimgblt fb_sys_fops drm video i2c_hid hid sdhci_acpi sdhci
>> [  223.734445] CPU: 2 PID: 3164 Comm: insmod Tainted: G           OE
>> 4.11.0-041100rc8-generic #201704232131
>> [  223.734557] Hardware name: Intel Corporation STCK1A32WFC/STCK1A32WFC,
>> BIOS
>> FCBYT10H.86A.0032.2016.0831.1658 08/31/2016
>> [  223.734680] task: ffff8eb168cf0000 task.stack: ffffad4781238000
>> [  223.734793] RIP: 0010:cfg80211_netdev_notifier_call+0x454/0x620
>> [cfg80211]
>> [  223.734874] RSP: 0018:ffffad478123b928 EFLAGS: 00010246
>> [  223.734937] RAX: 0000000000000000 RBX: ffff8eb18b5a9000 RCX:
>> 0000000000000000
>> [  223.735020] RDX: ffffad478123ba98 RSI: 0000000000000010 RDI:
>> ffffffffc0b5d140
>> [  223.735103] RBP: ffffad478123ba18 R08: 0000000000000000 R09:
>> ffffffffc0b5d140
>> [  223.735186] R10: ffffad478123ba28 R11: ffffad478123b938 R12:
>> 0000000000000000
>> [  223.735269] R13: ffff8eb19e872000 R14: ffffad478123ba98 R15:
>> 0000000000000000
>> [  223.735353] FS:  00007fb8b1b0b700(0000) GS:ffff8eb1b9f00000(0000)
>> knlGS:0000000000000000
>> [  223.735447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  223.735515] CR2: 000056544b449498 CR3: 000000004b4fa000 CR4:
>> 00000000001006e0
>> [  223.735597] Call Trace:
>> [  223.735638]  ? proc_alloc_inum+0x49/0xe0
>> [  223.735690]  ? inetdev_event+0x47/0x4e0
>> [  223.735740]  ? skb_dequeue+0x59/0x70
>> [  223.735786]  notifier_call_chain+0x4a/0x70
>> [  223.735839]  raw_notifier_call_chain+0x16/0x20
>> [  223.735895]  call_netdevice_notifiers_info+0x35/0x60
>> [  223.735957]  register_netdevice+0x1fa/0x500
>> [  223.736009]  register_netdev+0x1a/0x30
>> [  223.736095]  rtw_drv_register_netdev+0x65/0x90 [r8723bs]
>> [  223.736187]  rtw_drv_init+0x220/0x250 [r8723bs]
>> [  223.736244]  sdio_bus_probe+0xec/0x130
>> [  223.736293]  driver_probe_device+0x2bb/0x460
>> [  223.736347]  __driver_attach+0xdf/0xf0
>> [  223.736395]  ? driver_probe_device+0x460/0x460
>> [  223.736451]  bus_for_each_dev+0x6c/0xc0
>> [  223.736500]  driver_attach+0x1e/0x20
>> [  223.736545]  bus_add_driver+0x170/0x270
>> [  223.736595]  driver_register+0x60/0xe0
>> [  223.736642]  ? 0xffffffffc0c54000
>> [  223.736685]  sdio_register_driver+0x20/0x30
>> [  223.736759]  rtw_drv_entry+0x58/0x1000 [r8723bs]
>> [  223.736816]  ? 0xffffffffc0c54000
>> [  223.736860]  do_one_initcall+0x52/0x1a0
>> [  223.736909]  ? kmem_cache_alloc_trace+0xd7/0x190
>> [  223.736969]  do_init_module+0x5f/0x200
>> [  223.737017]  load_module+0x1a15/0x1da0
>> [  223.737068]  ? ima_post_read_file+0x7e/0xa0
>> [  223.737121]  ? security_kernel_post_read_file+0x6b/0x80
>> [  223.737187]  SYSC_finit_module+0xdf/0x110
>> [  223.737237]  ? SYSC_finit_module+0xdf/0x110
>> [  223.737290]  SyS_finit_module+0xe/0x10
>> [  223.737338]  entry_SYSCALL_64_fastpath+0x1e/0xad
>> [  223.737394] RIP: 0033:0x7fb8b163edf9
>> [  223.737438] RSP: 002b:00007ffd134d7298 EFLAGS: 00000246 ORIG_RAX:
>> 0000000000000139
>> [  223.737528] RAX: ffffffffffffffda RBX: 00007fb8b18feb58 RCX:
>> 00007fb8b163edf9
>> [  223.737610] RDX: 0000000000000000 RSI: 0000561ecd674f8b RDI:
>> 0000000000000003
>> [  223.737694] RBP: 00007fb8b18feb00 R08: 0000000000000000 R09:
>> 00007fb8b1900ea0
>> [  223.737778] R10: 0000000000000003 R11: 0000000000000246 R12:
>> 00007fb8b18feb58
>> [  223.737862] R13: 0000000000001020 R14: 00007fb8b18feb58 R15:
>> 000000000000270e
>> [  223.737945] Code: fc ff ff 49 8b bc 24 90 fd ff ff e8 07 85 5b f8 89 c2
>> b8 85
>> 80 00 00 84 d2 0f 85 3c fc ff ff e9 2d fc ff ff 31 c0 e9 30 fc ff ff <0f>
>> 0b be
>> 4b 04 00 00 48 c7 c7 18 25 b5 c0 e8 e9 49 d8 f7 e9 f1
>> [  223.738253] RIP: cfg80211_netdev_notifier_call+0x454/0x620 [cfg80211]
>> RSP:
>> ffffad478123b928
>> [  223.768427] ---[ end trace ff517da1ae586e56 ]---
>> ubuntu@ubuntu:~$
>>
>> OS:
>> Ubuntu 17.04 ISO from http://releases.ubuntu.com/17.04/
>>
>> Kernel:
>> v4.11-rc8 from http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.11-rc8/
>>
>>
>> On 28 April 2017 at 00:05, Bastien Nocera <hadess@hadess.net
>> <mailto:hadess@hadess.net>> wrote:
>>
>>     On Fri, 2017-04-28 at 00:00 +1000, Ian W MORRISON wrote:
>>     > With the current code from linux-next an 'insmod r8723bs.ko'
>>     > immediately results in segmentation fault.
>>
>>     What's the error trace you get?
>>
>>     >  If I apply my 'patch' the insmod works and wifi is perfect. I
>> didn't
>>     > try removing the kfree() call altogether as I didn't feel I had
>>     > enough understanding of possible implications to do so.
>>     >
>>     > On 27 April 2017 at 23:47, Bastien Nocera <hadess@hadess.net
>>     <mailto:hadess@hadess.net>> wrote:
>>     > > On Thu, 2017-04-27 at 23:44 +1000, Ian W MORRISON wrote:
>>     > > > I tried building the RTL8723BS SDIO wifi driver which has just
>>     > > been
>>     > > > incorporated in staging for linux-next as an external module and
>>     > > > found that it fails with 'Segmentation Fault'. I've tracked this
>>     > > down
>>     > > > to commit 6557ddfec348c13d7798ea9e44f11b6459f2f652 (staging:
>>     > > > rtl8723bs: Fix various errors in os_dep/ioctl_cfg80211.c) which
>>     > > > includes the fix
>>     > > > 'drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:3547
>>     > > > rtw_wdev_alloc() info: ignoring unreachable code'. The moving of
>>     > > line
>>     > > > 'kfree((u8 *)wdev);' causes the segmentation error so I've
>>     > > included
>>     > > > the following patch to revert it.
>>     > >
>>     > > What error? Both versions look equally incorrect, eg. either it's
>>     > > leaking data in which case the kfree() is necessary and should be
>>     > > in a
>>     > > callable location, or it's not, and the call should be removed.
>
>
> First of all, please do not top post when you send E-mail to a list.
>

Noted and understood.

> When trying to find a bad commit, you should use bisection. You will save a
> lot of trials.
>

Thanks. I will in future.

> As Bastien says above, both of your commits are wrong. Your experiments
> appear to show that having that kfree() call there is wrong, thus the fix is
> to remove it, NOT move it to a place where it can never be called.
>
> As I do not have working hardware for this chip, I cannot test any of these
> patches. In retrospect, I should not have made the change in question, but
> it now seems that a patch removing the kfree() call is the right one. When
> the code eventually calls rtw_wdev_free(), the memory allocated to wdev will
> be freed. In any case, someone with the hardware should enable kmemleak in
> their kernel and test this driver for memory leaks.
>
> Please send a patch with the offending kfree() call removed.
>
> Larry
>
>
>

Here is the patch to remove the kfree() call as discussed. I have
built and tested the r8723bs.ko module on an Intel Compute Stick and
can confirm the wifi modules works without the kfree() call.

>From 68416cdd131e308585f67afcc218c28d9e764b05 Mon Sep 17 00:00:00 2001
From: Ian W Morrison <linuxium@linuxium.com.au>
Date: Fri, 28 Apr 2017 02:20:38 +1000
Subject: [PATCH] staging: rtl8723bs: remove a call to kfree in
 os_dep/ioctl_cfg80211.c

Signed-off-by: Ian W Morrison <linuxium@linuxium.com.au>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index f17f4fb..2ee9df5 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -3527,7 +3527,6 @@ int rtw_wdev_alloc(struct adapter *padapter,
struct device *dev)
                pwdev_priv->power_mgmt = true;
        else
                pwdev_priv->power_mgmt = false;
-       kfree((u8 *)wdev);

        return ret;

-- 
1.9.1
