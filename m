Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34212 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0KLLGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 06:06:55 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PGrT2-0000DS-6V
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 12:06:52 +0100
Received: from function.justgohome.co.uk ([217.169.15.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:06:52 +0100
Received: from rb-oss-3 by function.justgohome.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:06:52 +0100
To: linux-wireless@vger.kernel.org
From: Robie Basak <rb-oss-3@justgohome.co.uk>
Subject: Re: r8187se panic
Date: Fri, 12 Nov 2010 11:06:40 +0000 (UTC)
Message-ID: <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
 <4CDC9FA5.10002@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/11/2010 06:41 PM, Robie Basak wrote:
>> I'm getting a panic when I to turn off the wireless using the Fn-F2
>> combination on my Asus Eee PC 701SDX. Although I'm using Ubuntu 10.10,
>> I've tried it using the mainline kernel (as supplied by Ubuntu for
>> testing bugs against mainline). So far I've reproduced consistently
>> against Ubuntu's 2.6.35-22-generic-pae as well as Ubuntu-supplied
>> mainstream 2.6.35-02063504.201008271919 and
>> 2.6.37-020637rc1.201011020905.
>
> Is Fn-F2 the radio kill switch?

Yes, that's right.

> At this point, I see no point in building a mainstream kernel.
>
> Do you have another host that might be setup as a net console?

Yes, I managed to get net console working (eventually):

(the first four lines are from when I modprobed r8187se)

[  941.787361] r8187se: module is from the staging directory, the quality is unknown, you have been warned.
[  941.821968] rtl8180_init:Error channel plan! Set to default.
[  941.825000] Dot11d_Init()
[  941.877241] r8180: WW:**PLEASE** REPORT SUCCESSFUL/UNSUCCESSFUL TO Realtek!
[  947.318002] ------------[ cut here ]------------
[  947.321315] WARNING: at /home/kernel-ppa/COD/linux/fs/proc/generic.c:816 remove_proc_entry+0x1e5/0x240()
[  947.328160] Hardware name: 701SDX
[  947.331607] name 'wlan0'
[  947.334987] Modules linked in: r8187se(C) netconsole eeprom_93cx6 parport_pc ppdev binfmt_misc snd_hda_codec_realtek snd_hda_intel i915 snd_hda_codec snd_hwdep snd_pcm drm_kms_helper joydev snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq drm snd_timer snd_seq_device intel_agp i2c_algo_bit intel_gtt snd psmouse eeepc_laptop video shpchp soundcore serio_raw agpgart sparse_keymap snd_page_alloc output led_class lp parport atl1e configfs [last unloaded: r8187se]
[  947.354968] Pid: 1350, comm: kworker/0:2 Tainted: G        WC  2.6.37-020637rc1-generic #201011020905
[  947.363331] Call Trace:
[  947.367541]  [<c02700d5>] ? remove_proc_entry+0x1e5/0x240
[  947.371870]  [<c02700d5>] ? remove_proc_entry+0x1e5/0x240
[  947.376103]  [<c014f7c1>] warn_slowpath_common+0x81/0xa0
[  947.380279]  [<c02700d5>] ? remove_proc_entry+0x1e5/0x240
[  947.384481]  [<c014f883>] warn_slowpath_fmt+0x33/0x40
[  947.388672]  [<c02700d5>] remove_proc_entry+0x1e5/0x240
[  947.392856]  [<c050c847>] ? netdev_refcnt_read+0x37/0x50
[  947.397022]  [<e02c4d3b>] rtl8180_proc_remove_one+0x6b/0x80 [r8187se]
[  947.401375]  [<e02dd876>] rtl8180_pci_remove+0x36/0x107 [r8187se]
[  947.405780]  [<c0420206>] ? __pm_runtime_resume+0x46/0x60
[  947.410280]  [<c038372a>] pci_device_remove+0x3a/0xc0
[  947.414794]  [<c0418301>] __device_release_driver+0x51/0xa0
[  947.419234]  [<c0418855>] device_release_driver+0x25/0x40
[  947.423530]  [<c0417c07>] bus_remove_device+0x57/0x80
[  947.427800]  [<c041556f>] device_del+0xff/0x160
[  947.432005]  [<c04155e0>] device_unregister+0x10/0x20
[  947.436160]  [<c037eabd>] pci_stop_dev+0x3d/0x50
[  947.440196]  [<c037eaee>] pci_stop_bus_device+0x1e/0x30
[  947.444076]  [<c037ec59>] pci_remove_bus_device+0x19/0x50
[  947.447790]  [<e0101306>] eeepc_rfkill_hotplug+0x126/0x160 [eeepc_laptop]
[  947.451614]  [<c03afe84>] ? acpi_bus_get_device+0x25/0x37
[  947.455483]  [<e0101407>] eeepc_rfkill_notify+0x17/0x20 [eeepc_laptop]
[  947.459306]  [<c03bd2a4>] acpi_ev_notify_dispatch+0x58/0x6a
[  947.463010]  [<c03adb3f>] acpi_os_execute_deferred+0x22/0x2d
[  947.466599]  [<c0168819>] process_one_work+0xd9/0x330
[  947.470019]  [<c03adb1d>] ? acpi_os_execute_deferred+0x0/0x2d
[  947.473369]  [<c0169413>] worker_thread+0xb3/0x210
[  947.476555]  [<c0169360>] ? worker_thread+0x0/0x210
[  947.479606]  [<c016c935>] kthread+0x75/0x80
[  947.482648]  [<c016c8c0>] ? kthread+0x0/0x80
[  947.485659]  [<c01032fe>] kernel_thread_helper+0x6/0x10
[  947.488760] ---[ end trace ff99ebfd52b415a2 ]---
[  947.491911] Kernel panic - not syncing: HwThreeWire(): CmdReg: 0XFF RE|WE bits are not clear!!
[  947.491916] 
[  947.498375] Pid: 1350, comm: kworker/0:2 Tainted: G        WC  2.6.37-020637rc1-generic #201011020905
[  947.505177] Call Trace:
[  947.508561]  [<c014f90f>] panic+0x5f/0x190
[  947.511965]  [<e02ccd3f>] HwHSSIThreeWire+0x4f/0x270 [r8187se]
[  947.515424]  [<e02ccfd2>] RF_WriteReg+0x32/0x40 [r8187se]
[  947.518877]  [<e02cb29a>] rtl8225z2_rf_close+0x1a/0x50 [r8187se]
[  947.522384]  [<e02dd885>] rtl8180_pci_remove+0x45/0x107 [r8187se]
[  947.525861]  [<c0420206>] ? __pm_runtime_resume+0x46/0x60
[  947.529347]  [<c038372a>] pci_device_remove+0x3a/0xc0
[  947.532819]  [<c0418301>] __device_release_driver+0x51/0xa0
[  947.536370]  [<c0418855>] device_release_driver+0x25/0x40
[  947.539862]  [<c0417c07>] bus_remove_device+0x57/0x80
[  947.543417]  [<c041556f>] device_del+0xff/0x160
[  947.546974]  [<c04155e0>] device_unregister+0x10/0x20
[  947.550492]  [<c037eabd>] pci_stop_dev+0x3d/0x50
[  947.553947]  [<c037eaee>] pci_stop_bus_device+0x1e/0x30
[  947.557330]  [<c037ec59>] pci_remove_bus_device+0x19/0x50
[  947.560682]  [<e0101306>] eeepc_rfkill_hotplug+0x126/0x160 [eeepc_laptop]
[  947.564130]  [<c03afe84>] ? acpi_bus_get_device+0x25/0x37
[  947.567535]  [<e0101407>] eeepc_rfkill_notify+0x17/0x20 [eeepc_laptop]
[  947.571020]  [<c03bd2a4>] acpi_ev_notify_dispatch+0x58/0x6a
[  947.574490]  [<c03adb3f>] acpi_os_execute_deferred+0x22/0x2d
[  947.577982]  [<c0168819>] process_one_work+0xd9/0x330
[  947.581465]  [<c03adb1d>] ? acpi_os_execute_deferred+0x0/0x2d
[  947.585032]  [<c0169413>] worker_thread+0xb3/0x210
[  947.588588]  [<c0169360>] ? worker_thread+0x0/0x210
[  947.592117]  [<c016c935>] kthread+0x75/0x80
[  947.595463]  [<c016c8c0>] ? kthread+0x0/0x80
[  947.598740]  [<c01032fe>] kernel_thread_helper+0x6/0x10
[  947.601954] panic occurred, switching back to text console

