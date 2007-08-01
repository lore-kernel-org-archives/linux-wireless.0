Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbXHAChO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 22:37:14 -0400
Subject: Re: libertas: blows chunks on failed firmware load
From: Dan Williams <dcbw@redhat.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46AF913F.9010006@warmcat.com>
References: <46AF913F.9010006@warmcat.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 22:34:38 -0400
Message-Id: <1185935678.17940.38.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-31 at 20:45 +0100, Andy Green wrote:
> Hi folks -
> 
> I realize I am slightly pushing my luck, but I added this el-cheapo
> 88W8338 -based "Compoint EVWL-GI-700S" USB stick's USB ID "0x1286,
> 0x1fab" to libertas/usb8xxx.c and chanced my arm.

If it's 8338, it's certainly not gonna work with this driver.  Did you
add the USB ID yourself?

Dan

> 
> I was rewarded with
> 
> PM: Adding info for No Bus:msh0
> PM: Adding info for No Bus:5-4
> PM: Removing info for No Bus:5-4
> libertas: request_firmware() failed with 0xfffffffe
> libertas: firmware usb8388.bin not found
> libertas: firmware init failed
> PM: Removing info for No Bus:msh0
> kfree_debugcheck: out of range ptr 6b6b6b6bh.
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:2825!
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in: usb8xxx libertas ieee80211 ieee80211_crypt iwl3945
> rt73usb rt2x00usb rt2x00lib rfkill input_polldev crc_itu_t mac80211
> cfg80211 vfat fat vmnet(P) vmmon(P) snd_rtctimer usb_storage autofs4 aes
> nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state
> nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables
> cpufreq_ondemand acpi_cpufreq video output sbs button dock battery ac lp
> loop snd_hda_intel snd_seq_dummy arc4 snd_seq_oss ecb blkcipher
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sr_mod
> snd_mixer_oss snd_pcm rtc_cmos cdrom snd_timer snd b44 ssb parport
> iTCO_wdt iTCO_vendor_support soundcore serio_raw ata_piix rtc_core
> rtc_lib ata_generic snd_page_alloc mii sg ahci libata sd_mod scsi_mod
> ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
> CPU:    1
> EIP:    0060:[<c047b122>]    Tainted: P        VLI
> EFLAGS: 00010086   (2.6.23-rc1 #1)
> EIP is at kfree_debugcheck+0x29/0x2f
> eax: 00000031   ebx: f48c2600   ecx: c0422e7d   edx: c8ea9060
> esi: ea1d1338   edi: 6b6b6b6b   ebp: e3a0ed6c   esp: e3a0ed64
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process modprobe (pid: 6761, ti=e3a0e000 task=c8ea9060 task.ti=e3a0e000)
> Stack: c06c7131 6b6b6b6b e3a0ed84 c047ba96 00000202 f48c2600 ea1d1338
> ea1d12e0
>        e3a0edc0 f8dd4b28 f8dd00d8 ffffff10 c0447a00 f8dd6ec8 e3a0edb0
> c0579b2d
>        f8dd6ec8 ee3602c0 d9a926b8 ed449e38 ee3602c0 f8dd6d40 f8dd6d90
> e3a0edd0
> Call Trace:
>  [<c0405f35>] show_trace_log_lvl+0x1a/0x2f
>  [<c0405fe5>] show_stack_log_lvl+0x9b/0xa3
>  [<c04061a5>] show_registers+0x1b8/0x289
>  [<c0406389>] die+0x113/0x246
>  [<c0622f98>] do_trap+0x8a/0xa3
>  [<c040677b>] do_invalid_op+0x88/0x92
>  [<c0622d6a>] error_code+0x72/0x78
>  [<c047ba96>] kfree+0x25/0xdb
>  [<f8dd4b28>] if_usb_probe+0x412/0x427 [usb8xxx]
>  [<c057a77f>] usb_probe_interface+0x6a/0xa0
>  [<c0562bb8>] driver_probe_device+0xe9/0x16a
>  [<c0562d62>] __driver_attach+0x76/0xaf
>  [<c05620bb>] bus_for_each_dev+0x3a/0x5f
>  [<c0562a03>] driver_attach+0x19/0x1b
>  [<c05623d9>] bus_add_driver+0x79/0x181
>  [<c0562f65>] driver_register+0x67/0x6c
>  [<c057a2b9>] usb_register_driver+0x7e/0xe5
>  [<f8dd3a4f>] if_usb_init_module+0x76/0xcc [usb8xxx]
>  [<c044eb0d>] sys_init_module+0x13b5/0x1503
>  [<c0404ed2>] sysenter_past_esp+0x5f/0x99
>  =======================
> Code: 5d c3 55 89 c2 8d 80 00 00 00 40 89 e5 c1 e8 0c 83 ec 08 3b 05 04
> 33 a8 c0 72 14 89 54 24 04 c7 04 24 31 71 6c c0 e8 a8 ff fa ff <0f> 0b
> eb fe c9 c3 55 89 e5 57 31 ff 56 89 c6 53 89 d3 83 ec 10
> EIP: [<c047b122>] kfree_debugcheck+0x29/0x2f SS:ESP 0068:e3a0ed64
> 
> Basically the error path for "can't load firmware" seems to double free?
> 
> It seems that by the time we arrive at kfree(priv->adapter); at
> if_usb.c:234 in if_usb_probe(), priv has already been freed or crapped
> on to point to somewhere that has been freed.
> 
> I had a quick look around, it looked to me like there might be a mistake
>  in main.c:867, in int libertas_activate_card(wlan_private *priv, char
> *fw_name) where it might jump to the wrong level of error unpicking
> code, but it didn't fix it.
> 
> 	if (priv->hw_register_dev(priv) < 0) {
> 		lbs_pr_err("failed to register WLAN device\n");
> 		goto err_registerdev;
> 	}
> 
> 	/* init FW and HW */
> 	if (fw_name && libertas_init_fw(priv, fw_name)) {
> 		lbs_pr_err("firmware init failed\n");
> //		goto err_registerdev; // !!!  <--- seems wrong
> 		goto err_init_fw;
> 	}
> 
> 	if (register_netdev(dev)) {
> 		lbs_pr_err("cannot register ethX device\n");
> 		goto err_init_fw;
> 	}
> 
> 	lbs_pr_info("%s: Marvell WLAN 802.11 adapter\n", dev->name);
> 
> 	libertas_debugfs_init_one(priv, dev);
> 
> 	ret = 0;
> 	goto done;
> 
> err_init_fw:
> 	priv->hw_unregister_dev(priv);
> err_registerdev:
> 	destroy_workqueue(priv->assoc_thread);
> 	/* Stop the thread servicing the interrupts */
> 
> 
> Even when I provided it with firmware, it dropped dead the same way just
> with this additional info before:
> 
> PM: Adding info for No Bus:msh0
> PM: Adding info for No Bus:5-4
> PM: Removing info for No Bus:5-4
> usb8xxx: failed to load fw, resetting device!
> usb 5-4: reset high speed USB device using ehci_hcd and address 3
> usb 5-4: device descriptor read/64, error -71
> usb 5-4: device descriptor read/64, error -71
> usb 5-4: reset high speed USB device using ehci_hcd and address 3
> usb 5-4: device descriptor read/64, error -71
> usb 5-4: device descriptor read/64, error -71
> usb 5-4: reset high speed USB device using ehci_hcd and address 3
> usb 5-4: device descriptor read/8, error 0
> usb 5-4: device descriptor read/8, error 0
> usb 5-4: reset high speed USB device using ehci_hcd and address 3
> usb 5-4: device descriptor read/8, error 0
> usb 5-4: device descriptor read/8, error 0
> usb 5-4: USB disconnect, address 3
> libertas: firmware init failed
> PM: Removing info for No Bus:msh0
> kfree_debugcheck: out of range ptr 6b6b6b6bh.
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:2825!
> ...
> 
> Of course this can be due to the luck-pushing, but it seemed it might
> also be a genuine problem with the error handling.
> 
> -Andy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

