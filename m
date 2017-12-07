Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:39833 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbdLGEuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 23:50:19 -0500
Received: by mail-wm0-f47.google.com with SMTP id i11so10614738wmf.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Dec 2017 20:50:19 -0800 (PST)
MIME-Version: 1.0
From: Pandi Vijayaraj <pandivijayaraj@gmail.com>
Date: Thu, 7 Dec 2017 10:20:17 +0530
Message-ID: <CABP2bZCukuuSsBR4ZcLBmSirF+7A__=jTU0Y0dfW8vtwfLJS4A@mail.gmail.com> (sfid-20171207_055031_233767_B8A65539)
Subject: RE: SDIO supend / Resume issue debugging
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

currently I am working in linux wifi driver for a wifi card interfaced via SDIO.
I am using a ubuntu PC with the kernel 4.13.3 for driver development.
The wifi driver is able to talk to the module via SDIO and basic scan,
connect functions are successful.
I am facing an issue in testing SDIO SUSPEND/Resume mechanism.
the suspend / resume code is below.

static int g_sdio_suspend(struct device *dev)
{
    int ret;
    struct sdio_func *func;
    struct g_sdio_privd *g_sdio;
    mmc_pm_flag_t flags;

    dev_info(dev, "SDIO interface suspend received \n");

    func  = dev_to_sdio_func(dev);

    g_sdio = sdio_get_drvdata(func);

    flags = sdio_get_host_pm_caps(func);

    dev_info(dev, "SDIO Host PM caps flags = %d\n", flags);

    if (!(flags & MMC_PM_KEEP_POWER)||
            !(flags & MMC_PM_WAKE_SDIO_IRQ))
        return -EINVAL;

    ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
    if (ret) {
        dev_info(dev, "SDIO host pm flags set fail"
                " : Keep power set = %d", ret);
    }

    ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
    if (ret) {
        dev_info(dev, "SDIO host pm flags set fail"
                " : Wake IRQ set = %d", ret);
    }

    return ret;
}

static int g_sdio_resume(struct device *dev)
{
    dev_info(dev, "SDIO interface resume received \n");

    return 0;
}

I am testing suspend by issuing the command "sudo pm-suspend".
The debug message after issuing the suspend command is given below.

>From the dmesg, it is seen that below sequence occured.

    sdhci_resume_host() -> disable_irq_wake()-> irq_set_irq_wake().

After that MMC timeout is happening.
I have tried to debug this for sometime. But I could not proceed
further in this issue.
kindly help me debug this issue.

 [ 1007.779365] PM: Suspending system (mem)
 [ 1007.779385] Suspending console(s) (use no_console_suspend to debug)
 [ 1007.779591] g_wlan_sdio mmc0:0001:1: SDIO interface suspend received
 [ 1007.779596] g_wlan_sdio mmc0:0001:1: SDIO Host PM caps flags = 3
 [ 1010.693547] usb 1-1.4: reset full-speed USB device number 5 using ehci-pci
 [ 1010.785620] Unbalanced IRQ 16 wake disable
 [ 1010.785629] ------------[ cut here ]------------
 [ 1010.785637] WARNING: CPU: 2 PID: 4099 at kernel/irq/manage.c:596
irq_set_irq_wake+0x125/0x130
 [ 1010.785638] Modules linked in: g_sdio(OE) rfcomm bnep uvcvideo
videobuf2_vmalloc videobuf2_memops btusb videobuf2_v4l2 btrtl
videobuf2_core intel_rapl btbcm btintel videodev bluetooth
x86_pkg_temp_thermal ecdh_generic media intel_powerclamp coretemp
snd_hda_codec_hdmi kvm irqbypass snd_hda_codec_realtek arc4
snd_hda_codec_generic iwldvm crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel mac80211 pcbc aesni_intel aes_x86_64 crypto_simd
snd_hda_intel glue_helper joydev input_leds snd_hda_codec cryptd
snd_hda_core serio_raw snd_hwdep wmi_bmof iwlwifi snd_pcm
thinkpad_acpi mei_me snd_seq_midi snd_seq_midi_event nvram snd_rawmidi
snd_seq mei snd_seq_device cfg80211 snd_timer snd soundcore shpchp
lpc_ich mac_hid parport_pc ppdev lp parport autofs4 mmc_block i915
psmouse ahci i2c_algo_bit libahci drm_kms_helper
 [ 1010.785694]  sdhci_pci syscopyarea e1000e sdhci sysfillrect
sysimgblt fb_sys_fops drm ptp pps_core wmi video
 [ 1010.785707] CPU: 2 PID: 4099 Comm: kworker/u16:47 Tainted: G
    OE   4.13.3 #1
 [ 1010.785708] Hardware name: LENOVO 2349J8Q/2349J8Q, BIOS G1ET41WW
(1.16 ) 05/25/2012
 [ 1010.785712] Workqueue: events_unbound async_run_entry_fn
 [ 1010.785715] task: ffff91a4193e9e00 task.stack: ffff9f6d03540000
 [ 1010.785718] RIP: 0010:irq_set_irq_wake+0x125/0x130
 [ 1010.785720] RSP: 0000:ffff9f6d03543cf0 EFLAGS: 00010086
 [ 1010.785722] RAX: 000000000000001e RBX: ffff91a41895f400 RCX:
ffffffff82e56ca8
 [ 1010.785723] RDX: 0000000000000000 RSI: 0000000000000086 RDI:
0000000000000002
 [ 1010.785724] RBP: ffff9f6d03543d18 R08: 0000000000000000 R09:
000000000000001e
 [ 1010.785725] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000010
 [ 1010.785727] R13: 0000000000000000 R14: 0000000000000000 R15:
ffffffff82d029ed
 [ 1010.785729] FS:  0000000000000000(0000) GS:ffff91a41e280000(0000)
knlGS:0000000000000000
 [ 1010.785730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [ 1010.785732] CR2: 0000000000000000 CR3: 0000000072e09000 CR4:
00000000001406e0
 [ 1010.785733] Call Trace:
 [ 1010.785743]  sdhci_resume_host+0x8b/0x110 [sdhci]
 [ 1010.785748]  sdhci_pci_resume_host+0x2e/0x50 [sdhci_pci]
 [ 1010.785751]  ricoh_mmc_resume+0x1f/0x30 [sdhci_pci]
 [ 1010.785755]  sdhci_pci_resume+0x29/0x40 [sdhci_pci]
 [ 1010.785760]  pci_pm_resume+0x64/0xa0
 [ 1010.785764]  dpm_run_callback+0x56/0x150
 [ 1010.785767]  ? pci_pm_freeze+0xe0/0xe0
 [ 1010.785769]  device_resume+0xe1/0x1f0
 [ 1010.785772]  async_resume+0x1d/0x50
 [ 1010.785774]  async_run_entry_fn+0x36/0x150
 [ 1010.785778]  process_one_work+0x156/0x3f0
 [ 1010.785781]  worker_thread+0x4b/0x410
 [ 1010.785785]  kthread+0x109/0x140
 [ 1010.785788]  ? process_one_work+0x3f0/0x3f0
 [ 1010.785791]  ? kthread_create_on_node+0x70/0x70
 [ 1010.785795]  ret_from_fork+0x25/0x30
 [ 1010.785797] Code: 00 00 81 20 ff bf ff ff e9 62 ff ff ff b8 ea ff
ff ff e9 6c ff ff ff e8 2a f3 f9 ff 44 89 e6 48 c7 c7 08 ad c9 82 e8
2c e1 ff ff <0f> ff e9 3a ff ff ff 0f 1f 40 00 0f 1f 44 00 00 55 89 fe
48 c7
 [ 1010.785834] ---[ end trace 28557b45b8d2e530 ]---
 [ 1010.881561] usb 1-1.6: reset high-speed USB device number 6 using ehci-pci
 [ 1010.940861] psmouse serio1: synaptics: queried max coordinates: x
[..5470], y [..4498]
 [ 1012.547072] irq 16: nobody cared (try booting with the "irqpoll" option)
 [ 1012.547074] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  OE
 4.13.3 #1
 [ 1012.547075] Hardware name: LENOVO 2349J8Q/2349J8Q, BIOS G1ET41WW
(1.16 ) 05/25/2012
 [ 1012.547075] Call Trace:
 [ 1012.547077]  <IRQ>
 [ 1012.547081]  dump_stack+0x63/0x82
 [ 1012.547084]  __report_bad_irq+0x36/0xc0
 [ 1012.547086]  note_interrupt+0x259/0x2a0
 [ 1012.547088]  handle_irq_event_percpu+0x57/0x80
 [ 1012.547089]  handle_irq_event+0x41/0x70
 [ 1012.547091]  handle_fasteoi_irq+0x9d/0x160
 [ 1012.547093]  handle_irq+0x1d/0x30
 [ 1012.547095]  do_IRQ+0x46/0xd0
 [ 1012.547096]  common_interrupt+0x89/0x89
 [ 1012.547100] RIP: 0010:cpuidle_enter_state+0x130/0x2e0
 [ 1012.547101] RSP: 0018:ffffffff82e03de0 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff8e
 [ 1012.547102] RAX: 0000000000000000 RBX: 0000000000000001 RCX:
000000000000001f
 [ 1012.547103] RDX: 0000000000000000 RSI: 000000003350f940 RDI:
0000000000000000
 [ 1012.547104] RBP: ffffffff82e03e18 R08: 0000000000000003 R09:
0000000000000008
 [ 1012.547104] R10: ffffffff82e03db0 R11: 000000000000000a R12:
0000000000000001
 [ 1012.547105] R13: ffff91a41e224e00 R14: ffffffff82ecbdb8 R15:
000000ebc0821b71
 [ 1012.547106]  </IRQ>
 [ 1012.547109]  cpuidle_enter+0x17/0x20
 [ 1012.547111]  call_cpuidle+0x23/0x40
 [ 1012.547113]  do_idle+0x18c/0x1f0
 [ 1012.547115]  cpu_startup_entry+0x73/0x80
 [ 1012.547116]  rest_init+0xb8/0xc0
[ 1012.547119]  start_kernel+0x459/0x47a
[ 1012.547121]  ? early_idt_handler_array+0x120/0x120
[ 1012.547122]  x86_64_start_reservations+0x24/0x26
[ 1012.547123]  x86_64_start_kernel+0x144/0x167
[ 1012.547126]  secondary_startup_64+0x9f/0x9f
[ 1012.547128] handlers:
[ 1012.547130] [<ffffffff8267fea0>] usb_hcd_irq

-- 
Regards,

Pandi Vijayaraj
