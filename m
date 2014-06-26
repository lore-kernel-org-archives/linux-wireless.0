Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.evertz.com ([204.187.63.106]:31245 "EHLO mail.evertz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbaFZOhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 10:37:52 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: Stack trace during RTL8821AE driver init in 3.15.1 kernel
Date: Thu, 26 Jun 2014 10:37:47 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFA03D9038B@otis.burlington.evertz.tv> (sfid-20140626_163805_021200_021FB519)
From: "Kevin Folz" <kfolz@evertz.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have a Gigabyte Brix GB-BXi7-4770R running Ubuntu Saucy 13.10, with an Azurewave AW-CB161H (Realtek RTL8821AE) mini-pcie card. 

Dmesg shows a stack trace during driver init. Full dmesg output can be found: http://pastebin.com/U0YMP6ti

root@brix:~# dpkg -l | grep linux-
ii  linux-firmware                        1.131                                      all          Firmware for Linux kernel drivers
ii  linux-headers-3.15.1-031501           3.15.1-031501.201406161841                 all          Header files related to Linux kernel version 3.15.1
ii  linux-headers-3.15.1-031501-generic   3.15.1-031501.201406161841                 amd64        Linux kernel headers for version 3.15.1 on 64 bit x86 SMP
ii  linux-image-3.15.1-031501-generic     3.15.1-031501.201406161841                 amd64        Linux kernel image for version 3.15.1 on 64 bit x86 SMP

A similar error message was present in 3.14.1.
[    3.653712] WARNING: CPU: 1 PID: 572 at /home/apw/COD/linux/net/wireless/reg.c:1388 wiphy_apply_custom_regulatory+0xc5/0xf0 [cfg80211]()

If I can help in any way, please let me know.

-----
[    4.119673] ------------[ cut here ]------------
[    4.119687] WARNING: CPU: 5 PID: 510 at /home/apw/COD/linux/net/wireless/reg.c:1508 wiphy_apply_custom_regulatory+0xbc/0xe0 [cfg80211]()
[    4.119688] wiphy should have REGULATORY_CUSTOM_REG
[    4.119689] Modules linked in: rtl8821ae(C+) mac80211 x86_pkg_temp_thermal snd_soc_rt5640 intel_powerclamp coretemp snd_soc_core snd_compress kvm crct10dif_pclmul crc32_pclmul cfg80211 btusb ghash_clmulni_intel aesni_intel mei_me(+) aes_x86_64 snd_seq_midi lrw gf128mul mei glue_helper snd_hda_intel(+) snd_seq_midi_event ablk_helper snd_hda_controller bluetooth cryptd snd_hda_codec snd_hwdep snd_rawmidi i915(+) snd_seq snd_pcm 6lowpan_iphc snd_seq_device lpc_ich snd_timer snd drm_kms_helper drm i2c_hid hid 8250_dw dw_dmac i2c_algo_bit i2c_designware_platform dw_dmac_core snd_soc_sst_acpi i2c_designware_core video soundcore spi_pxa2xx_platform mac_hid lp parport nls_iso8859_1 nls_utf8 cifs fscache ahci r8169 libahci mii sdhci_acpi sdhci
[    4.119713] CPU: 5 PID: 510 Comm: systemd-udevd Tainted: G         C    3.15.1-031501-generic #201406161841
[    4.119714] Hardware name: GIGABYTE M4HM87P-00/M4HM87P-00, BIOS F4 03/10/2014
[    4.119715]  00000000000005e4 ffff8800d600fa38 ffffffff8176e144 000000000000428a
[    4.119716]  ffff8800d600fa88 ffff8800d600fa78 ffffffff8106ce2c 0000000000000000
[    4.119718]  ffffffffa0704080 ffff880212398220 ffffffffa06bf5a0 ffff880212816098
[    4.119719] Call Trace:
[    4.119724]  [<ffffffff8176e144>] dump_stack+0x46/0x58
[    4.119726]  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
[    4.119736]  [<ffffffffa06bf5a0>] ? rtl_regd_init+0x310/0x310 [rtl8821ae]
[    4.119737]  [<ffffffff8106cf16>] warn_slowpath_fmt+0x46/0x50
[    4.119745]  [<ffffffffa045aa5c>] wiphy_apply_custom_regulatory+0xbc/0xe0 [cfg80211]
[    4.119751]  [<ffffffffa06bf5a0>] ? rtl_regd_init+0x310/0x310 [rtl8821ae]
[    4.119755]  [<ffffffffa06bf3e2>] rtl_regd_init+0x152/0x310 [rtl8821ae]
[    4.119760]  [<ffffffffa06ba771>] rtl_init_core+0x41/0x170 [rtl8821ae]
[    4.119767]  [<ffffffffa06ce7bd>] rtl_pci_probe+0x28d/0x920 [rtl8821ae]
[    4.119769]  [<ffffffff813bf99e>] local_pci_probe+0x4e/0xa0
[    4.119772]  [<ffffffff8124b092>] ? kernfs_create_link+0x52/0xa0
[    4.119773]  [<ffffffff813c0db9>] __pci_device_probe+0xb9/0xf0
[    4.119774]  [<ffffffff813c0e2a>] pci_device_probe+0x3a/0x60
[    4.119776]  [<ffffffff814b4581>] really_probe+0x91/0x380
[    4.119777]  [<ffffffff814b49f7>] driver_probe_device+0x47/0xa0
[    4.119779]  [<ffffffff814b4afb>] __driver_attach+0xab/0xb0
[    4.119780]  [<ffffffff814b4a50>] ? driver_probe_device+0xa0/0xa0
[    4.119782]  [<ffffffff814b288e>] bus_for_each_dev+0x5e/0x90
[    4.119783]  [<ffffffff814b413e>] driver_attach+0x1e/0x20
[    4.119784]  [<ffffffff814b3c44>] bus_add_driver+0x124/0x260
[    4.119789]  [<ffffffffa050f000>] ? 0xffffffffa050efff
[    4.119790]  [<ffffffff814b5214>] driver_register+0x64/0xf0
[    4.119792]  [<ffffffffa050f000>] ? 0xffffffffa050efff
[    4.119794]  [<ffffffff813bfd1c>] __pci_register_driver+0x4c/0x50
[    4.119799]  [<ffffffffa050f02b>] rtl8821ae_module_init+0x2b/0x1000 [rtl8821ae]
[    4.119801]  [<ffffffff8100217a>] do_one_initcall+0xfa/0x1b0
[    4.119803]  [<ffffffff8105db33>] ? set_memory_nx+0x43/0x50
[    4.119808]  [<ffffffff8176322c>] do_init_module+0x80/0x1d1
[    4.119811]  [<ffffffff810edcc1>] load_module+0x4e1/0x600
[    4.119812]  [<ffffffff810eb2d0>] ? show_initstate+0x50/0x50
[    4.119814]  [<ffffffff810ede94>] SyS_init_module+0xb4/0x100
[    4.119817]  [<ffffffff8178487f>] tracesys+0xe1/0xe6
[    4.119818] ---[ end trace 52ffc03936ebe53b ]---

Thanks,
Kevin Folz - Embedded Platform Engineer - Evertz
