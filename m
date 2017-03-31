Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36453 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933217AbdCaRK1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 13:10:27 -0400
Received: by mail-qk0-f173.google.com with SMTP id p22so72084200qka.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 10:10:26 -0700 (PDT)
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Thalmeier <michael.thalmeier@hale.at>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Laura Abbott <labbott@redhat.com>
Subject: DMA on stack in pn533
Message-ID: <b70620ac-5261-1005-9ca4-3f2e84a3032b@redhat.com> (sfid-20170331_191101_860055_EB1A9B2F)
Date: Fri, 31 Mar 2017 10:10:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Fedora got a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1436866
of DMA on the stack:

[ 6292.462827] ------------[ cut here ]------------
[ 6292.462841] WARNING: CPU: 3 PID: 6314 at drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x37f/0x570
[ 6292.462842] transfer buffer not dma capable
[ 6292.462843] Modules linked in: pn533_usb(+) pn533 nfc rfcomm ccm xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_raw ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_security ip6table_mangle iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_security iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) cmac bnep vboxdrv(OE) arc4 vfat fat tpm_crb iTCO_wdt i2c_designware_platform iTCO_vendor_support mei_wdt i2c_designware_core dell_wmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm uvcvideo irqbypass videobuf2_vmalloc videobuf2_memops
[ 6292.462887]  videobuf2_v4l2 crct10dif_pclmul videobuf2_core crc32_pclmul videodev ghash_clmulni_intel btusb media btrtl snd_hda_codec_hdmi dell_led dell_smbios dcdbas ath10k_pci ath10k_core mac80211 ath cfg80211 snd_hda_codec_realtek hci_uart snd_hda_codec_generic btbcm rtsx_pci_ms memstick btqca joydev btintel bluetooth snd_hda_intel snd_hda_codec snd_hda_core pinctrl_sunrisepoint snd_hwdep rfkill dell_smo8800 snd_seq pinctrl_intel snd_seq_device intel_hid i2c_i801 intel_lpss_acpi mei_me snd_pcm idma64 i2c_smbus sparse_keymap mei snd_timer shpchp processor_thermal_device snd int3400_thermal intel_lpss_pci soundcore acpi_thermal_rel intel_lpss intel_soc_dts_iosf tpm_tis acpi_als kfifo_buf tpm_tis_core industrialio tpm int3403_thermal int340x_thermal_zone acpi_pad nfsd auth_rpcgss nfs_acl lockd grace
[ 6292.462935]  sunrpc mmc_block hid_multitouch nouveau i915 rtsx_pci_sdmmc mmc_core mxm_wmi ttm i2c_algo_bit drm_kms_helper crc32c_intel drm nvme serio_raw rtsx_pci nvme_core i2c_hid video wmi fjes
[ 6292.462951] CPU: 3 PID: 6314 Comm: systemd-udevd Tainted: G           OE   4.9.14-200.fc25.x86_64 #1
[ 6292.462952] Hardware name: Dell Inc. XPS 15 9560/05FFDN, BIOS 1.0.3 01/09/2017
[ 6292.462957]  ffffb59bc560b858 ffffffffa33f4cfd ffffb59bc560b8a8 0000000000000000
[ 6292.462962]  ffffb59bc560b898 ffffffffa30a305b 0000063000000100 ffff9f372a4d6a80
[ 6292.462966]  0000000000000000 ffff9f3618d60000 0000000000000001 ffff9f372cfda000
[ 6292.462971] Call Trace:
[ 6292.462987]  [<ffffffffa33f4cfd>] dump_stack+0x63/0x86
[ 6292.462990]  [<ffffffffa30a305b>] __warn+0xcb/0xf0
[ 6292.462992]  [<ffffffffa30a30df>] warn_slowpath_fmt+0x5f/0x80
[ 6292.462998]  [<ffffffffa341482d>] ? list_del+0xd/0x30
[ 6292.463001]  [<ffffffffa35ed90f>] usb_hcd_map_urb_for_dma+0x37f/0x570
[ 6292.463004]  [<ffffffffa35ee0fa>] usb_hcd_submit_urb+0x35a/0xb50
[ 6292.463007]  [<ffffffffa33f56c2>] ? get_from_free_list+0x42/0x50
[ 6292.463008]  [<ffffffffa33f6879>] ? ida_get_new_above+0x1e9/0x210
[ 6292.463011]  [<ffffffffa35efaa4>] usb_submit_urb+0x2f4/0x560
[ 6292.463017]  [<ffffffffa3230fff>] ? __kmalloc+0x16f/0x1f0
[ 6292.463019]  [<ffffffffa35ef529>] ? usb_alloc_urb+0x19/0x50
[ 6292.463027]  [<ffffffffc100f963>] pn533_usb_probe+0x353/0x4ff [pn533_usb]
[ 6292.463031]  [<ffffffffa35f4d69>] usb_probe_interface+0x159/0x2d0
[ 6292.463033]  [<ffffffffa354c703>] driver_probe_device+0x223/0x430
[ 6292.463035]  [<ffffffffa354c9ef>] __driver_attach+0xdf/0xf0
[ 6292.463037]  [<ffffffffa354c910>] ? driver_probe_device+0x430/0x430
[ 6292.463045]  [<ffffffffa354a0ec>] bus_for_each_dev+0x6c/0xc0
[ 6292.463047]  [<ffffffffa354be4e>] driver_attach+0x1e/0x20
[ 6292.463050]  [<ffffffffa354b880>] bus_add_driver+0x170/0x270
[ 6292.463052]  [<ffffffffa354d310>] driver_register+0x60/0xe0
[ 6292.463054]  [<ffffffffa35f3631>] usb_register_driver+0x81/0x140
[ 6292.463056]  [<ffffffffc03b0000>] ? 0xffffffffc03b0000
[ 6292.463060]  [<ffffffffc03b001e>] pn533_usb_driver_init+0x1e/0x1000 [pn533_usb]
[ 6292.463065]  [<ffffffffa3002190>] do_one_initcall+0x50/0x180
[ 6292.463069]  [<ffffffffa322fbe9>] ? kmem_cache_alloc_trace+0x159/0x1b0
[ 6292.463077]  [<ffffffffa31c07ea>] ? do_init_module+0x27/0x1ef
[ 6292.463080]  [<ffffffffa31c0822>] do_init_module+0x5f/0x1ef
[ 6292.463084]  [<ffffffffa3130231>] load_module+0x25b1/0x2980
[ 6292.463086]  [<ffffffffa312cb10>] ? __symbol_put+0x60/0x60
[ 6292.463089]  [<ffffffffa3130773>] SYSC_init_module+0x173/0x190
[ 6292.463091]  [<ffffffffa31308ae>] SyS_init_module+0xe/0x10
[ 6292.463098]  [<ffffffffa381dc77>] entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 6292.463100] ---[ end trace fade6511ac15b696 ]---

It looks like several of the functions (e.g. pn533_acr122_poweron_rdr,
pn533_usb_send_ack) use commands directly from the stack which
no longer works with CONFIG_VMAP_STACK. I haven't made time to
attempt a fix so this is just a report. Perhaps someone else can
get the fix faster than I can.

Thanks,
Laura
