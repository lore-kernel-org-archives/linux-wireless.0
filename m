Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D4EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C226E217FA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=netorg783571.onmicrosoft.com header.i=@netorg783571.onmicrosoft.com header.b="GGPIsB2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfBLGAg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:00:36 -0500
Received: from mail-eopbgr10123.outbound.protection.outlook.com ([40.107.1.123]:26469
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725550AbfBLGAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 01:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netorg783571.onmicrosoft.com; s=selector1-aaronpb-me;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mhiahuxQgdIC0OrqZpRDVvJ9Aif5I3Ug7BLlYeJXzg=;
 b=GGPIsB2h1Cm4k6pD4i/ctbpYgjifX07y2TgQUNONTBtri/wdP2EiCuH0Bs0iuxCdg78rg0fFkhuqwYiUxj/+opuJhQZfU7l0aYl+qYkgYXu5puuccpwkiMF+pAoznQSaN42pM+xpEVCBwg/QatBvnXKKP7W2Qd7AH/bsDKcMI/E=
Received: from AM4PR0101MB2179.eurprd01.prod.exchangelabs.com (10.165.23.20)
 by AM4PR0101MB2212.eurprd01.prod.exchangelabs.com (10.165.38.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.24; Tue, 12 Feb
 2019 05:57:08 +0000
Received: from AM4PR0101MB2179.eurprd01.prod.exchangelabs.com
 ([fe80::c9f4:1d26:d935:5319]) by
 AM4PR0101MB2179.eurprd01.prod.exchangelabs.com
 ([fe80::c9f4:1d26:d935:5319%3]) with mapi id 15.20.1601.023; Tue, 12 Feb 2019
 05:57:08 +0000
From:   Aaron Blair <aaron@aaronpb.me>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
Subject: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
Thread-Topic: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
Thread-Index: AQHUwpfJXnw6ygRVkUy1zu5ei+CfRw==
Date:   Tue, 12 Feb 2019 05:57:08 +0000
Message-ID: <20190212055731.gxy3e3uulztketbf@datkip>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MEAPR01CA0026.ausprd01.prod.outlook.com (2603:10c6:201::14)
 To AM4PR0101MB2179.eurprd01.prod.exchangelabs.com (2603:10a6:200:54::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aaron@aaronpb.me; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [123.200.156.34]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM4PR0101MB2212;6:RhWU8bdtNn8X+W9HrF95/8TNdEEbNYR0pOJ7VFDBDeUlFZQ4iOXT/wYlvTVXUxoz7pZpsvEjuf7xPjGG5DI9xIzbAkcNCjV3fLuK2zzS1jAbiW0XU50vjiZbaprwpVcmB2Pm0I+TMB4HUew939ycWirNzVpyv7rg+lUYf+HOn+DPykIRsnuxuc1/Z14V+7QD8GNMojaQ8UphcWL73YRUzgOOJobw6OrJtbtBO2ttwKXkBofIJvnOh1Or0v0W1Kzs0GAw3F3M25VfxLDw0O56XSM8i1iH6G2dgR5Shs17+kmh1Ou526ClXjeunGEiaYkEsgrY1KWt3aMRNRLVQXoHHPqv6rBM6sooIekejO7QUKGthIvZ8tKjwxJ7rO9kt6C2iW6KqkCoLoUp8JcKI/g02TYS9YbUZ98YPESu4Jm5R1kHk2LCBWBj1cJiCmDn9rXSB/lq0yxn/R9j8A6eJT92VA==;5:Kbhvs65gs893SCvhLXtK305BKLgVb60PNqm4peoqjWg8GpAUHkiux8BAwJN8zMu7EHMgtR/d9fVyGbvDKYtzbju6qnKKv+DiQSxhgVZjbU73mLpqKWD2QfDWRL05O4cYDDEEpRpRP/pmXTM85YVXcWbj08UI7qZgiNtOHwdR+ggKSX1ex5GTNU+tmyWGG11efdmfrsJwqU8hx4s2bWecQA==;7:jT9RYZTEF+incwrwDxfIc4y9zeb4gxikYoyde9zOj/rLPA5VwER5dMQWbmbxHAluVwJ7c1Pol4Kq63NBK9juH7NNaM+GNEKLiOaw6G8rXX00Y6a+WofCipVChFoRmlx0LRXc70t3jwkebM2Op7TPJQ==
x-ms-office365-filtering-correlation-id: 047b84ee-4825-4880-0b9c-08d690aeeb9e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600110)(711020)(4605077)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:AM4PR0101MB2212;
x-ms-traffictypediagnostic: AM4PR0101MB2212:
x-microsoft-antispam-prvs: <AM4PR0101MB22127928C3FB31DD7594C810CE650@AM4PR0101MB2212.eurprd01.prod.exchangelabs.com>
x-forefront-prvs: 0946DC87A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(346002)(366004)(376002)(39830400003)(396003)(189003)(199004)(40224003)(74482002)(68736007)(45080400002)(6486002)(25786009)(4326008)(114624004)(6512007)(19627235002)(6306002)(99286004)(9686003)(52116002)(102836004)(26005)(6436002)(53936002)(71190400001)(71200400001)(33896004)(305945005)(1076003)(53946003)(256004)(14454004)(6506007)(5024004)(14444005)(386003)(486006)(966005)(508600001)(86362001)(186003)(33716001)(8676002)(99936001)(7736002)(8936002)(2906002)(476003)(30864003)(81156014)(106356001)(316002)(66066001)(110136005)(54906003)(3846002)(6116002)(97736004)(105586002)(81166006)(559001)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0101MB2212;H:AM4PR0101MB2179.eurprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aaronpb.me does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pLrUKZ8AIbtG6aXKLlVIMI+hz0EzZY0z3CK8sNAwPGkfh7ulnec6cIPn93PzFwc2IP9TOdzJWeDYElASH8xN72HbqtkfBzrCdsueO7Bh7i2l2qWkSLqq6spUotXrxxKlw0yzP5IqW9WtKPOmZ6w0uZGJrj6eV7dCbhw+LGfudrefEdVEmWZHtR3Qty2HS7tzbcUlJ1GpCxbJgpDE1bdX0tOE4FNs87EY1urxqBCiPLOA9CeWZMqI2PxBKraYu/5aNU5fb0c6TTfHMtnlYS9y1Jz4kGkhfk8H4af2pIUBhkDS8BYD8D/jv8JRpuRcabLkxRlJlI03it5nxY7eZnFQN3i+2bvMiOb5nL2h1qUGLQthFt3dZFZslP64iA7x2DIg0LYn0wut5bWxkjRdFeqZeBzKtA+gf4eXsIjIvHCK+tc=
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cz4f5ru7tf6x6263"
MIME-Version: 1.0
X-OriginatorOrg: aaronpb.me
X-MS-Exchange-CrossTenant-Network-Message-Id: 047b84ee-4825-4880-0b9c-08d690aeeb9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2019 05:57:03.5957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 8acfaf70-8168-4fef-8ae0-f16834eb6f43
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0101MB2212
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--cz4f5ru7tf6x6263
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I apologise if my report is lacking in detail; it is my first attempt at bu=
g/issue reporting in the kernel.
Please follow up if something is missing, or more detail/testing is require=
d.
It is certainly possible for me to provide more oops reports if required, a=
s they generally surface at least once a day.

Thank you.

[1.]=20
Oops - Null pointer dereference in brcm80211/brcmfmac [BCM4350]

[2.]=20
Seemingly randomly, when connected to a wireless network, my laptop will be=
gin failing to tx/rx data, and begin repeatedly reporting the following mes=
sages in the kernel ring buffer:

```
[18990.872335] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO failed, -=
12
[18990.872433] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18990.872439] brcmfmac: brcmf_cfg80211_get_tx_power: error (-12)
```

Upon trying to rmmod && modload brcmfmac, I receive the oops dump included =
below, and am unable to continue using the wireless NIC until I reboot.

This does not appear to have a pattern, except that it usually happens at l=
east once throughout a day of work.

It has been happening at least since 4.20.4, but potentially earlier (this =
machine wasn't in heavy use before then).

[3.] networking, brcmfmac, brcm80211, wireless, BCM4350

[4.]
[4.1.] Linux version 4.20.7-arch1-1-ARCH (builduser@heftig-13691) (gcc vers=
ion 8.2.1 20181127 (GCC)) #1 SMP PREEMPT Wed Feb 6 18:42:40 UTC 2019
[4.2.]=20
```
# SPDX-License-Identifier: GPL-2.0
#
# For a description of the syntax of this configuration file,
# see Documentation/kbuild/kconfig-language.txt.
#
mainmenu "Linux/$(ARCH) $(KERNELVERSION) Kernel Configuration"

comment "Compiler: $(CC_VERSION_TEXT)"

source "scripts/Kconfig.include"

source "init/Kconfig"

source "kernel/Kconfig.freezer"

source "fs/Kconfig.binfmt"

source "mm/Kconfig"

source "net/Kconfig"

source "drivers/Kconfig"

source "fs/Kconfig"

source "security/Kconfig"

source "crypto/Kconfig"

source "lib/Kconfig"

source "lib/Kconfig.debug"
```

[5.] Unfortunately I'm unsure, sorry.
[6.]
```
[18992.589383] usbcore: deregistering interface driver brcmfmac
[18992.601325] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18992.601329] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18992.601330] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18992.601331] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18992.601337] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in =
commonring
[18992.601339] brcmfmac: brcmf_cfg80211_get_tx_power: error (-12)
[18992.614167] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing t=
o do.
[18992.614169] brcmfmac: brcmf_link_down: WLC_DISASSOC failed (-5)
[18992.714226] brcmfmac: brcmf_netdev_start_xmit: xmit rejected state=3D0
[18993.140920] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing t=
o do.
[18993.145399] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing t=
o do.
[18993.154379] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing t=
o do.
[18993.154385] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
[18993.216393] audit: type=3D1130 audit(1549948871.453:123): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-rfkill comm=3D"s=
ystemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?=
 res=3Dsuccess'
[18993.221258] brcmfmac: brcmf_msgbuf_delete_flowring: FW unaware, flowring=
 will be removed !!
[18993.221279] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000010
[18993.221283] PGD 0 P4D 0=20
[18993.221288] Oops: 0000 [#1] PREEMPT SMP PTI
[18993.221293] CPU: 3 PID: 13381 Comm: rmmod Tainted: G           OE     4.=
20.7-arch1-1-ARCH #1
[18993.221295] Hardware name: Dell Inc. XPS 13 9350/0JXC1H, BIOS 1.7.0 01/1=
6/2018
[18993.221310] RIP: 0010:brcmf_txfinalize+0x26/0x70 [brcmfmac]
[18993.221313] Code: de 0f 1f 00 0f 1f 44 00 00 41 54 41 89 d4 55 48 89 f5 =
53 48 8b 86 d8 00 00 00 48 89 fb 66 81 78 0c 88 8e 74 1d 45 84 e4 75 0c <48=
> 8b 43 10 48 83 80 38 01 00 00 01 5b 48 89 ef 5d 41 5c e9 b2 f4
[18993.221316] RSP: 0018:ffffb119c6f8fd30 EFLAGS: 00010246
[18993.221319] RAX: ffff8c37bce42002 RBX: 0000000000000000 RCX: 00000000000=
00000
[18993.221322] RDX: 0000000000000000 RSI: ffff8c397b8f3200 RDI: 00000000000=
00000
[18993.221324] RBP: ffff8c397b8f3200 R08: 00000000f0000080 R09: 00000000000=
00000
[18993.221326] R10: ffff8c39f3c3b9e0 R11: fffff7a541863408 R12: 00000000000=
00000
[18993.221328] R13: 0000000000000000 R14: 0000000000000000 R15: dead0000000=
00100
[18993.221331] FS:  00007fd35a802b80(0000) GS:ffff8c39f6b80000(0000) knlGS:=
0000000000000000
[18993.221334] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18993.221336] CR2: 0000000000000010 CR3: 0000000032812006 CR4: 00000000003=
626e0
[18993.221338] Call Trace:
[18993.221355]  brcmf_flowring_delete+0xaa/0xd0 [brcmfmac]
[18993.221367]  brcmf_flowring_detach+0x42/0x90 [brcmfmac]
[18993.221378]  brcmf_proto_msgbuf_detach+0xce/0x160 [brcmfmac]
[18993.221393]  brcmf_proto_detach+0x5e/0x70 [brcmfmac]
[18993.221407]  brcmf_detach+0xc9/0xf0 [brcmfmac]
[18993.221421]  brcmf_pcie_remove+0x6c/0x1a0 [brcmfmac]
[18993.221428]  pci_device_remove+0x3b/0xc0
[18993.221433]  device_release_driver_internal+0x1af/0x270
[18993.221438]  driver_detach+0x37/0x68
[18993.221441]  bus_remove_driver+0x74/0xc6
[18993.221446]  pci_unregister_driver+0x3d/0x90
[18993.221461]  brcmfmac_module_exit+0x5/0x1c [brcmfmac]
[18993.221467]  __se_sys_delete_module+0x1a2/0x300
[18993.221473]  do_syscall_64+0x5b/0x170
[18993.221479]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[18993.221483] RIP: 0033:0x7fd35a92147b
[18993.221487] Code: 73 01 c3 48 8b 0d e5 19 0c 00 f7 d8 64 89 01 48 83 c8 =
ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 19 0c 00 f7 d8 64 89 01 48
[18993.221489] RSP: 002b:00007fff1e796fd8 EFLAGS: 00000206 ORIG_RAX: 000000=
00000000b0
[18993.221493] RAX: ffffffffffffffda RBX: 000055d2ff9b9760 RCX: 00007fd35a9=
2147b
[18993.221496] RDX: 000055d2ff9b97e0 RSI: 0000000000000a00 RDI: 000055d2ff9=
b97c8
[18993.221499] RBP: 0000000000000200 R08: 0000000000000000 R09: 00007fff1e7=
97038
[18993.221501] R10: 000055d2ff9b9010 R11: 0000000000000206 R12: 00007fff1e7=
97208
[18993.221504] R13: 00007fff1e7976b8 R14: 000055d2ff9b9260 R15: 000055d2ff9=
b9760
[18993.221508] Modules linked in: rfcomm fuse snd_hda_codec_hdmi snd_hda_co=
dec_realtek snd_hda_codec_generic ipt_MASQUERADE nf_conntrack_netlink nfnet=
link xfrm_user xfrm_algo iptable_nat nf_nat_ipv4 xt_addrtype iptable_filter=
 xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c b=
r_netfilter bridge stp llc overlay bnep snd_soc_skl intel_rapl snd_soc_hdac=
_hda i915 snd_hda_ext_core snd_soc_skl_ipc snd_soc_sst_ipc x86_pkg_temp_the=
rmal intel_powerclamp snd_soc_sst_dsp coretemp kvm_intel snd_soc_acpi_intel=
_match kvmgt vfio_mdev mdev vfio_iommu_type1 snd_soc_acpi vfio snd_soc_core=
 snd_usb_audio snd_compress iTCO_wdt iTCO_vendor_support dell_wmi cdc_ether=
 ac97_bus wmi_bmof intel_wmi_thunderbolt usbnet snd_pcm_dmaengine dell_lapt=
op snd_usbmidi_lib r8152 joydev kvm i2c_algo_bit snd_hda_intel mii dell_smb=
ios snd_rawmidi dell_wmi_descriptor drm_kms_helper dcdbas snd_seq_device bt=
usb nls_iso8859_1 nls_cp437 btrtl btbcm vfat snd_hda_codec mousedev brcmfma=
c(-) fat btintel drm
[18993.221560]  snd_hda_core bluetooth uvcvideo irqbypass videobuf2_vmalloc=
 intel_cstate videobuf2_memops snd_hwdep videobuf2_v4l2 intel_uncore intel_=
rapl_perf brcmutil videobuf2_common snd_pcm videodev psmouse snd_timer inpu=
t_leds pcspkr media ecdh_generic cfg80211 intel_gtt i2c_i801 snd soundcore =
rtsx_pci_ms memstick agpgart tpm_tis rfkill mei_me idma64 syscopyarea tpm_t=
is_core sysfillrect mei sysimgblt tpm intel_lpss_pci fb_sys_fops processor_=
thermal_device intel_lpss intel_soc_dts_iosf intel_pch_thermal wmi rng_core=
 battery i2c_hid intel_hid sparse_keymap evdev int3403_thermal int3400_ther=
mal ac int340x_thermal_zone acpi_thermal_rel mac_hid pcc_cpufreq vboxnetflt=
(OE) vboxnetadp(OE) vboxpci(OE) vboxdrv(OE) crypto_user ip_tables x_tables =
algif_skcipher af_alg hid_multitouch hid_generic usbhid hid dm_crypt dm_mod=
 crct10dif_pclmul crc32_pclmul rtsx_pci_sdmmc ghash_clmulni_intel mmc_core =
serio_raw atkbd libps2 aesni_intel ahci libahci aes_x86_64 crypto_simd liba=
ta cryptd glue_helper xhci_pci
[18993.221613]  scsi_mod xhci_hcd rtsx_pci i8042 serio ext4 crc32c_generic =
crc32c_intel crc16 mbcache jbd2 fscrypto
[18993.221626] CR2: 0000000000000010
[18993.221630] ---[ end trace 7b922944892a431b ]---
[18993.221643] RIP: 0010:brcmf_txfinalize+0x26/0x70 [brcmfmac]
[18993.221647] Code: de 0f 1f 00 0f 1f 44 00 00 41 54 41 89 d4 55 48 89 f5 =
53 48 8b 86 d8 00 00 00 48 89 fb 66 81 78 0c 88 8e 74 1d 45 84 e4 75 0c <48=
> 8b 43 10 48 83 80 38 01 00 00 01 5b 48 89 ef 5d 41 5c e9 b2 f4
[18993.221650] RSP: 0018:ffffb119c6f8fd30 EFLAGS: 00010246
[18993.221653] RAX: ffff8c37bce42002 RBX: 0000000000000000 RCX: 00000000000=
00000
[18993.221656] RDX: 0000000000000000 RSI: ffff8c397b8f3200 RDI: 00000000000=
00000
[18993.221659] RBP: ffff8c397b8f3200 R08: 00000000f0000080 R09: 00000000000=
00000
[18993.221662] R10: ffff8c39f3c3b9e0 R11: fffff7a541863408 R12: 00000000000=
00000
[18993.221664] R13: 0000000000000000 R14: 0000000000000000 R15: dead0000000=
00100
[18993.221668] FS:  00007fd35a802b80(0000) GS:ffff8c39f6b80000(0000) knlGS:=
0000000000000000
[18993.221671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18993.221673] CR2: 0000000000000010 CR3: 0000000032812006 CR4: 00000000003=
626e0
```

[7.] When NIC is no longer able to pass traffic, and "GET STA INFO failed" =
messages are appearing, run `rmmod brcmfmac`.

[8.]
[8.1.] ver_linux
```
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux scrubbed 4.20.7-arch1-1-ARCH #1 SMP PREEMPT Wed Feb 6 18:42:40 UTC 20=
19 x86_64 GNU/Linux

GNU C               	8.2.1
GNU Make            	4.2.1
Binutils            	2.31.1
Util-linux          	2.33.1
Mount               	2.33.1
Module-init-tools   	25
E2fsprogs           	1.44.5
Jfsutils            	1.1.15
Reiserfsprogs       	3.6.27
Xfsprogs            	4.19.0
Pcmciautils         	018
Linux C Library     	2.28
Dynamic linker (ldd)	2.28
Linux C++ Library   	6.0.25
Procps              	3.3.15
Net-tools           	2.10
Kbd                 	2.0.4
Console-tools       	2.0.4
Sh-utils            	8.30
Udev                	240
Wireless-tools      	30
Modules Loaded      	ac ac97_bus acpi_thermal_rel aesni_intel aes_x86_64 af=
_alg agpgart ahci algif_skcipher atkbd battery bluetooth bnep brcmfmac brcm=
util bridge br_netfilter btbcm btintel btrtl btusb cdc_ether cfg80211 coret=
emp crc16 crc32c_generic crc32c_intel crc32_pclmul crct10dif_pclmul cryptd =
crypto_simd crypto_user dcdbas dell_laptop dell_smbios dell_wmi dell_wmi_de=
scriptor dm_crypt dm_mod drm drm_kms_helper ecdh_generic evdev ext4 fat fb_=
sys_fops fscrypto fuse ghash_clmulni_intel glue_helper hid hid_generic hid_=
multitouch i2c_algo_bit i2c_hid i2c_i801 i8042 i915 idma64 input_leds int34=
00_thermal int3403_thermal int340x_thermal_zone intel_cstate intel_gtt inte=
l_hid intel_lpss intel_lpss_pci intel_pch_thermal intel_powerclamp intel_ra=
pl intel_rapl_perf intel_soc_dts_iosf intel_uncore intel_wmi_thunderbolt ip=
table_filter iptable_nat ip_tables ipt_MASQUERADE irqbypass iTCO_vendor_sup=
port iTCO_wdt jbd2 joydev kvm kvmgt kvm_intel libahci libata libcrc32c libp=
s2 llc mac_hid mbcache mdev media mei mei_me memstick mii mmc_core mousedev=
 nf_conntrack nf_conntrack_netlink nf_defrag_ipv4 nf_defrag_ipv6 nf_nat nf_=
nat_ipv4 nfnetlink nls_cp437 nls_iso8859_1 overlay pcc_cpufreq pcspkr proce=
ssor_thermal_device psmouse r8152 rfcomm rfkill rng_core rtsx_pci rtsx_pci_=
ms rtsx_pci_sdmmc scsi_mod serio serio_raw snd snd_compress snd_hda_codec s=
nd_hda_codec_generic snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_core =
snd_hda_ext_core snd_hda_intel snd_hwdep snd_pcm snd_pcm_dmaengine snd_rawm=
idi snd_seq_device snd_soc_acpi snd_soc_acpi_intel_match snd_soc_core snd_s=
oc_hdac_hda snd_soc_skl snd_soc_skl_ipc snd_soc_sst_dsp snd_soc_sst_ipc snd=
_timer snd_usb_audio snd_usbmidi_lib soundcore sparse_keymap stp syscopyare=
a sysfillrect sysimgblt tpm tpm_tis tpm_tis_core usbhid usbnet uvcvideo vbo=
xdrv vboxnetadp vboxnetflt vboxpci vfat vfio vfio_iommu_type1 vfio_mdev vid=
eobuf2_common videobuf2_memops videobuf2_v4l2 videobuf2_vmalloc videodev wm=
i wmi_bmof x86_pkg_temp_thermal xfrm_algo xfrm_user xhci_hcd xhci_pci x_tab=
les xt_addrtype xt_conntrack
```

[8.2.] /proc/cpuinfo
```
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 78
model name	: Intel(R) Core(TM) i7-6560U CPU @ 2.20GHz
stepping	: 3
microcode	: 0xc2
cpu MHz		: 522.569
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rd=
tscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nons=
top_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl=
 vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe =
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefet=
ch cpuid_fault epb invpcid_single pti ibrs ibpb stibp tpr_shadow vnmi flexp=
riority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpci=
d mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dt=
herm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
bogomips	: 4417.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 78
model name	: Intel(R) Core(TM) i7-6560U CPU @ 2.20GHz
stepping	: 3
microcode	: 0xc2
cpu MHz		: 669.868
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rd=
tscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nons=
top_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl=
 vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe =
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefet=
ch cpuid_fault epb invpcid_single pti ibrs ibpb stibp tpr_shadow vnmi flexp=
riority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpci=
d mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dt=
herm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
bogomips	: 4417.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 78
model name	: Intel(R) Core(TM) i7-6560U CPU @ 2.20GHz
stepping	: 3
microcode	: 0xc2
cpu MHz		: 544.814
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rd=
tscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nons=
top_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl=
 vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe =
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefet=
ch cpuid_fault epb invpcid_single pti ibrs ibpb stibp tpr_shadow vnmi flexp=
riority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpci=
d mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dt=
herm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
bogomips	: 4417.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 78
model name	: Intel(R) Core(TM) i7-6560U CPU @ 2.20GHz
stepping	: 3
microcode	: 0xc2
cpu MHz		: 620.636
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rd=
tscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nons=
top_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl=
 vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe =
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefet=
ch cpuid_fault epb invpcid_single pti ibrs ibpb stibp tpr_shadow vnmi flexp=
riority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpci=
d mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dt=
herm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
bogomips	: 4417.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:
```

[8.3.] /proc/modules
```
fuse 131072 3 - Live 0x0000000000000000
rfcomm 86016 4 - Live 0x0000000000000000
snd_hda_codec_hdmi 61440 1 - Live 0x0000000000000000
snd_hda_codec_realtek 122880 1 - Live 0x0000000000000000
snd_hda_codec_generic 90112 1 snd_hda_codec_realtek, Live 0x0000000000000000
ipt_MASQUERADE 20480 3 - Live 0x0000000000000000
nf_conntrack_netlink 53248 0 - Live 0x0000000000000000
nfnetlink 16384 2 nf_conntrack_netlink, Live 0x0000000000000000
xfrm_user 45056 1 - Live 0x0000000000000000
xfrm_algo 16384 1 xfrm_user, Live 0x0000000000000000
iptable_nat 16384 1 - Live 0x0000000000000000
nf_nat_ipv4 16384 2 ipt_MASQUERADE,iptable_nat, Live 0x0000000000000000
xt_addrtype 16384 2 - Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
xt_conntrack 16384 3 - Live 0x0000000000000000
nf_nat 40960 1 nf_nat_ipv4, Live 0x0000000000000000
nf_conntrack 159744 5 ipt_MASQUERADE,nf_conntrack_netlink,nf_nat_ipv4,xt_co=
nntrack,nf_nat, Live 0x0000000000000000
nf_defrag_ipv6 24576 1 nf_conntrack, Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack, Live 0x0000000000000000
libcrc32c 16384 2 nf_nat,nf_conntrack, Live 0x0000000000000000
br_netfilter 28672 0 - Live 0x0000000000000000
bridge 200704 1 br_netfilter, Live 0x0000000000000000
stp 16384 1 bridge, Live 0x0000000000000000
llc 16384 2 bridge,stp, Live 0x0000000000000000
overlay 131072 0 - Live 0x0000000000000000
snd_soc_skl 122880 0 - Live 0x0000000000000000
snd_soc_hdac_hda 24576 1 snd_soc_skl, Live 0x0000000000000000
snd_hda_ext_core 32768 2 snd_soc_skl,snd_soc_hdac_hda, Live 0x0000000000000=
000
snd_soc_skl_ipc 69632 1 snd_soc_skl, Live 0x0000000000000000
uvcvideo 114688 0 - Live 0x0000000000000000
snd_soc_sst_ipc 20480 1 snd_soc_skl_ipc, Live 0x0000000000000000
snd_soc_sst_dsp 40960 1 snd_soc_skl_ipc, Live 0x0000000000000000
videobuf2_vmalloc 20480 1 uvcvideo, Live 0x0000000000000000
bnep 28672 2 - Live 0x0000000000000000
videobuf2_memops 20480 1 videobuf2_vmalloc, Live 0x0000000000000000
snd_soc_acpi_intel_match 24576 1 snd_soc_skl, Live 0x0000000000000000
snd_soc_acpi 16384 2 snd_soc_skl,snd_soc_acpi_intel_match, Live 0x000000000=
0000000
videobuf2_v4l2 28672 1 uvcvideo, Live 0x0000000000000000
videobuf2_common 57344 2 uvcvideo,videobuf2_v4l2, Live 0x0000000000000000
snd_soc_core 278528 2 snd_soc_skl,snd_soc_hdac_hda, Live 0x0000000000000000
videodev 229376 3 uvcvideo,videobuf2_v4l2,videobuf2_common, Live 0x00000000=
00000000
snd_usb_audio 262144 0 - Live 0x0000000000000000
cdc_ether 20480 0 - Live 0x0000000000000000
snd_compress 28672 1 snd_soc_core, Live 0x0000000000000000
i915 2109440 9 - Live 0x0000000000000000
ac97_bus 16384 1 snd_soc_core, Live 0x0000000000000000
media 57344 4 uvcvideo,videobuf2_v4l2,videobuf2_common,videodev, Live 0x000=
0000000000000
usbnet 49152 1 cdc_ether, Live 0x0000000000000000
btusb 57344 0 - Live 0x0000000000000000
intel_rapl 28672 0 - Live 0x0000000000000000
snd_pcm_dmaengine 16384 1 snd_soc_core, Live 0x0000000000000000
btrtl 20480 1 btusb, Live 0x0000000000000000
x86_pkg_temp_thermal 20480 0 - Live 0x0000000000000000
snd_usbmidi_lib 36864 1 snd_usb_audio, Live 0x0000000000000000
iTCO_wdt 16384 0 - Live 0x0000000000000000
btbcm 16384 1 btusb, Live 0x0000000000000000
iTCO_vendor_support 16384 1 iTCO_wdt, Live 0x0000000000000000
snd_rawmidi 40960 1 snd_usbmidi_lib, Live 0x0000000000000000
btintel 28672 1 btusb, Live 0x0000000000000000
kvmgt 32768 0 - Live 0x0000000000000000
r8152 73728 0 - Live 0x0000000000000000
vfio_mdev 16384 0 - Live 0x0000000000000000
mdev 24576 2 kvmgt,vfio_mdev, Live 0x0000000000000000
intel_powerclamp 20480 0 - Live 0x0000000000000000
mii 16384 2 usbnet,r8152, Live 0x0000000000000000
snd_seq_device 16384 1 snd_rawmidi, Live 0x0000000000000000
snd_hda_intel 49152 4 - Live 0x0000000000000000
vfio_iommu_type1 32768 0 - Live 0x0000000000000000
bluetooth 651264 27 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live 0x000000000=
0000000
coretemp 20480 0 - Live 0x0000000000000000
dell_wmi 20480 0 - Live 0x0000000000000000
intel_wmi_thunderbolt 20480 0 - Live 0x0000000000000000
snd_hda_codec 155648 5 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_cod=
ec_generic,snd_soc_hdac_hda,snd_hda_intel, Live 0x0000000000000000
wmi_bmof 16384 0 - Live 0x0000000000000000
vfio 36864 3 kvmgt,vfio_mdev,vfio_iommu_type1, Live 0x0000000000000000
kvm_intel 245760 0 - Live 0x0000000000000000
brcmfmac 393216 0 - Live 0x0000000000000000
ecdh_generic 24576 1 bluetooth, Live 0x0000000000000000
nls_iso8859_1 16384 1 - Live 0x0000000000000000
joydev 28672 0 - Live 0x0000000000000000
mousedev 24576 0 - Live 0x0000000000000000
nls_cp437 20480 1 - Live 0x0000000000000000
dell_laptop 24576 1 - Live 0x0000000000000000
vfat 20480 1 - Live 0x0000000000000000
snd_hda_core 98304 8 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec=
_generic,snd_soc_skl,snd_soc_hdac_hda,snd_hda_ext_core,snd_hda_intel,snd_hd=
a_codec, Live 0x0000000000000000
fat 81920 1 vfat, Live 0x0000000000000000
brcmutil 20480 1 brcmfmac, Live 0x0000000000000000
dell_smbios 32768 2 dell_wmi,dell_laptop, Live 0x0000000000000000
snd_hwdep 16384 2 snd_usb_audio,snd_hda_codec, Live 0x0000000000000000
dell_wmi_descriptor 20480 2 dell_wmi,dell_smbios, Live 0x0000000000000000
kvm 741376 2 kvmgt,kvm_intel, Live 0x0000000000000000
snd_pcm 135168 10 snd_hda_codec_hdmi,snd_soc_skl,snd_hda_ext_core,snd_soc_c=
ore,snd_usb_audio,snd_pcm_dmaengine,snd_hda_intel,snd_hda_codec,snd_hda_cor=
e, Live 0x0000000000000000
dcdbas 20480 1 dell_smbios, Live 0x0000000000000000
cfg80211 778240 1 brcmfmac, Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
drm_kms_helper 208896 1 i915, Live 0x0000000000000000
snd_timer 40960 1 snd_pcm, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
intel_cstate 16384 0 - Live 0x0000000000000000
psmouse 172032 0 - Live 0x0000000000000000
intel_uncore 135168 0 - Live 0x0000000000000000
snd 102400 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generi=
c,snd_soc_core,snd_usb_audio,snd_compress,snd_usbmidi_lib,snd_rawmidi,snd_s=
eq_device,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, Live 0x0=
000000000000000
drm 499712 7 i915,drm_kms_helper, Live 0x0000000000000000
intel_rapl_perf 16384 0 - Live 0x0000000000000000
rtsx_pci_ms 24576 0 - Live 0x0000000000000000
pcspkr 16384 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
memstick 20480 1 rtsx_pci_ms, Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
intel_gtt 24576 1 i915, Live 0x0000000000000000
i2c_i801 36864 0 - Live 0x0000000000000000
tpm_tis 16384 0 - Live 0x0000000000000000
rfkill 28672 7 bluetooth,dell_laptop,cfg80211, Live 0x0000000000000000
tpm_tis_core 24576 1 tpm_tis, Live 0x0000000000000000
mei_me 45056 0 - Live 0x0000000000000000
agpgart 53248 2 drm,intel_gtt, Live 0x0000000000000000
idma64 20480 0 - Live 0x0000000000000000
tpm 69632 2 tpm_tis,tpm_tis_core, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
processor_thermal_device 16384 0 - Live 0x0000000000000000
i2c_hid 32768 0 - Live 0x0000000000000000
mei 114688 1 mei_me, Live 0x0000000000000000
intel_soc_dts_iosf 20480 1 processor_thermal_device, Live 0x0000000000000000
wmi 32768 5 dell_wmi,intel_wmi_thunderbolt,wmi_bmof,dell_smbios,dell_wmi_de=
scriptor, Live 0x0000000000000000
intel_lpss_pci 20480 0 - Live 0x0000000000000000
intel_lpss 16384 1 intel_lpss_pci, Live 0x0000000000000000
intel_pch_thermal 16384 0 - Live 0x0000000000000000
rng_core 16384 1 tpm, Live 0x0000000000000000
battery 24576 0 - Live 0x0000000000000000
intel_hid 20480 0 - Live 0x0000000000000000
sparse_keymap 16384 2 dell_wmi,intel_hid, Live 0x0000000000000000
int3403_thermal 16384 0 - Live 0x0000000000000000
int340x_thermal_zone 16384 2 processor_thermal_device,int3403_thermal, Live=
 0x0000000000000000
evdev 24576 30 - Live 0x0000000000000000
int3400_thermal 20480 0 - Live 0x0000000000000000
acpi_thermal_rel 16384 1 int3400_thermal, Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
pcc_cpufreq 20480 0 - Live 0x0000000000000000
ac 16384 0 - Live 0x0000000000000000
vboxnetflt 32768 0 - Live 0x0000000000000000 (OE)
vboxnetadp 28672 0 - Live 0x0000000000000000 (OE)
vboxpci 28672 0 - Live 0x0000000000000000 (OE)
vboxdrv 499712 3 vboxnetflt,vboxnetadp,vboxpci, Live 0x0000000000000000 (OE)
crypto_user 20480 0 - Live 0x0000000000000000
ip_tables 32768 2 iptable_nat,iptable_filter, Live 0x0000000000000000
x_tables 49152 5 ipt_MASQUERADE,xt_addrtype,iptable_filter,xt_conntrack,ip_=
tables, Live 0x0000000000000000
algif_skcipher 16384 0 - Live 0x0000000000000000
af_alg 32768 1 algif_skcipher, Live 0x0000000000000000
hid_multitouch 28672 0 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 61440 0 - Live 0x0000000000000000
hid 143360 4 i2c_hid,hid_multitouch,hid_generic,usbhid, Live 0x000000000000=
0000
dm_crypt 40960 1 - Live 0x0000000000000000
dm_mod 151552 12 dm_crypt, Live 0x0000000000000000
crct10dif_pclmul 16384 1 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
rtsx_pci_sdmmc 32768 0 - Live 0x0000000000000000
ahci 40960 0 - Live 0x0000000000000000
mmc_core 180224 2 brcmfmac,rtsx_pci_sdmmc, Live 0x0000000000000000
serio_raw 20480 0 - Live 0x0000000000000000
libahci 40960 1 ahci, Live 0x0000000000000000
atkbd 36864 0 - Live 0x0000000000000000
libps2 20480 2 psmouse,atkbd, Live 0x0000000000000000
libata 278528 2 ahci,libahci, Live 0x0000000000000000
aesni_intel 200704 2 - Live 0x0000000000000000
xhci_pci 20480 0 - Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
scsi_mod 258048 1 libata, Live 0x0000000000000000
crypto_simd 16384 1 aesni_intel, Live 0x0000000000000000
xhci_hcd 262144 1 xhci_pci, Live 0x0000000000000000
cryptd 28672 4 ghash_clmulni_intel,aesni_intel,crypto_simd, Live 0x00000000=
00000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
rtsx_pci 77824 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0x0000000000000000
i8042 32768 1 dell_laptop, Live 0x0000000000000000
serio 28672 6 psmouse,serio_raw,atkbd,i8042, Live 0x0000000000000000
ext4 749568 2 - Live 0x0000000000000000
crc32c_generic 16384 0 - Live 0x0000000000000000
crc32c_intel 24576 5 - Live 0x0000000000000000
crc16 16384 2 bluetooth,ext4, Live 0x0000000000000000
mbcache 16384 1 ext4, Live 0x0000000000000000
jbd2 131072 1 ext4, Live 0x0000000000000000
fscrypto 32768 1 ext4, Live 0x0000000000000000
```

[8.4.] /proc/ioports + /proc/iomem
``` /proc/ioports
0000-0000 : PCI Bus 0000:00
  0000-0000 : dma1
  0000-0000 : pic1
  0000-0000 : timer0
  0000-0000 : timer1
  0000-0000 : keyboard
  0000-0000 : keyboard
  0000-0000 : rtc0
  0000-0000 : dma page reg
  0000-0000 : pic2
  0000-0000 : dma2
  0000-0000 : fpu
  0000-0000 : iTCO_wdt
    0000-0000 : iTCO_wdt
  0000-0000 : pnp 00:00
  0000-0000 : PNP0C09:00
    0000-0000 : EC data
  0000-0000 : PNP0C09:00
    0000-0000 : EC cmd
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
    0000-0000 : ACPI PM1a_EVT_BLK
    0000-0000 : ACPI PM1a_CNT_BLK
    0000-0000 : ACPI PM_TMR
    0000-0000 : iTCO_wdt
      0000-0000 : iTCO_wdt
    0000-0000 : ACPI PM2_CNT_BLK
    0000-0000 : pnp 00:02
    0000-0000 : ACPI GPE0_BLK
  0000-0000 : PCI Bus 0000:01
    0000-0000 : PCI Bus 0000:02
      0000-0000 : PCI Bus 0000:04
  0000-0000 : 0000:00:02.0
  0000-0000 : 0000:00:1f.4
    0000-0000 : i801_smbus
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : pnp 00:07
  0000-0000 : pnp 00:00
    0000-0000 : pnp 00:00
      0000-0000 : pnp 00:00
```

``` /proc/iomem
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : Video ROM
00000000-00000000 : System ROM
00000000-00000000 : System RAM
00000000-00000000 : System RAM
00000000-00000000 : System RAM
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : ACPI Tables
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : RAM buffer
00000000-00000000 : Reserved
  00000000-00000000 : Graphics Stolen Memory
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : PCI Bus 0000:01
    00000000-00000000 : PCI Bus 0000:02
      00000000-00000000 : PCI Bus 0000:04
  00000000-00000000 : PCI Bus 0000:01
    00000000-00000000 : PCI Bus 0000:02
      00000000-00000000 : PCI Bus 0000:04
      00000000-00000000 : PCI Bus 0000:39
        00000000-00000000 : 0000:39:00.0
          00000000-00000000 : xhci-hcd
      00000000-00000000 : PCI Bus 0000:03
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : PCI Bus 0000:3a
    00000000-00000000 : 0000:3a:00.0
    00000000-00000000 : 0000:3a:00.0
  00000000-00000000 : PCI Bus 0000:3c
    00000000-00000000 : 0000:3c:00.0
      00000000-00000000 : nvme
  00000000-00000000 : PCI Bus 0000:3b
    00000000-00000000 : 0000:3b:00.0
      00000000-00000000 : rtsx_pci
  00000000-00000000 : 0000:00:1f.3
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:14.0
    00000000-00000000 : xhci-hcd
  00000000-00000000 : 0000:00:04.0
  00000000-00000000 : 0000:00:1f.3
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:1f.2
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:1f.4
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:16.0
    00000000-00000000 : mei_me
  00000000-00000000 : 0000:00:15.1
    00000000-00000000 : lpss_dev
      00000000-00000000 : lpss_dev
    00000000-00000000 : lpss_priv
    00000000-00000000 : idma64.1
      00000000-00000000 : idma64.1
  00000000-00000000 : 0000:00:15.0
    00000000-00000000 : lpss_dev
      00000000-00000000 : lpss_dev
    00000000-00000000 : lpss_priv
    00000000-00000000 : idma64.0
      00000000-00000000 : idma64.0
  00000000-00000000 : 0000:00:14.2
    00000000-00000000 : Intel PCH thermal driver
  00000000-00000000 : pnp 00:05
00000000-00000000 : PCI MMCONFIG 0000 [bus 00-ff]
  00000000-00000000 : Reserved
    00000000-00000000 : pnp 00:05
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : pnp 00:06
  00000000-00000000 : INT344B:00
    00000000-00000000 : INT344B:00
  00000000-00000000 : pnp 00:06
  00000000-00000000 : INT344B:00
    00000000-00000000 : INT344B:00
  00000000-00000000 : INT344B:00
    00000000-00000000 : INT344B:00
  00000000-00000000 : pnp 00:06
    00000000-00000000 : iTCO_wdt
      00000000-00000000 : iTCO_wdt
  00000000-00000000 : Reserved
  00000000-00000000 : pnp 00:08
  00000000-00000000 : pnp 00:08
  00000000-00000000 : pnp 00:06
  00000000-00000000 : pnp 00:06
  00000000-00000000 : pnp 00:06
00000000-00000000 : Reserved
  00000000-00000000 : IOAPIC 0
00000000-00000000 : HPET 0
  00000000-00000000 : PNP0103:00
00000000-00000000 : pnp 00:05
00000000-00000000 : pnp 00:05
00000000-00000000 : pnp 00:05
00000000-00000000 : pnp 00:05
00000000-00000000 : TPM
00000000-00000000 : pnp 00:05
00000000-00000000 : dmar0
00000000-00000000 : dmar1
00000000-00000000 : Local APIC
  00000000-00000000 : Reserved
00000000-00000000 : Reserved
  00000000-00000000 : INT0800:00
    00000000-00000000 : pnp 00:05
00000000-00000000 : System RAM
  00000000-00000000 : Kernel code
  00000000-00000000 : Kernel data
  00000000-00000000 : Kernel bss
00000000-00000000 : RAM buffer
```

[8.5.] lspci -vvv
```
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen C=
ore Processor Host Bridge/DRAM Registers (rev 09)
	Subsystem: Dell Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bri=
dge/DRAM Registers
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D10 <?>
	Kernel driver in use: skl_uncore

00:02.0 VGA compatible controller: Intel Corporation Iris Graphics 540 (rev=
 0a) (prog-if 00 [VGA controller])
	DeviceName:  Onboard IGD
	Subsystem: Dell Iris Graphics 540
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 132
	Region 0: Memory at db000000 (64-bit, non-prefetchable) [size=3D16M]
	Region 2: Memory at 90000000 (64-bit, prefetchable) [size=3D256M]
	Region 4: I/O ports at f000 [size=3D64]
	[virtual] Expansion ROM at 000c0000 [disabled] [size=3D128K]
	Capabilities: [40] Vendor Specific Information: Len=3D0c <?>
	Capabilities: [70] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not S=
upported
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
	Capabilities: [ac] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee00018  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Process Address Space ID (PASID)
		PASIDCap: Exec+ Priv-, Max PASID Width: 14
		PASIDCtl: Enable- Exec- Priv-
	Capabilities: [200 v1] Address Translation Service (ATS)
		ATSCap:	Invalidate Queue Depth: 00
		ATSCtl:	Enable-, Smallest Translation Unit: 00
	Capabilities: [300 v1] Page Request Interface (PRI)
		PRICtl: Enable- Reset-
		PRISta: RF- UPRGI- Stopped-
		Page Request Capacity: 00008000, Page Request Allocation: 00000000
	Kernel driver in use: i915
	Kernel modules: i915

00:04.0 Signal processing controller: Intel Corporation Xeon E3-1200 v5/E3-=
1500 v5/6th Gen Core Processor Thermal Subsystem (rev 09)
	Subsystem: Dell Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal =
Subsystem
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at dc720000 (64-bit, non-prefetchable) [size=3D32K]
	Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
	Kernel driver in use: proc_thermal
	Kernel modules: processor_thermal_device

00:14.0 USB controller: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Con=
troller (rev 21) (prog-if 30 [XHCI])
	Subsystem: Dell Sunrise Point-LP USB 3.0 xHCI Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 128
	Region 0: Memory at dc710000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0-,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [80] MSI: Enable+ Count=3D1/8 Maskable- 64bit+
		Address: 00000000fee00338  Data: 0000
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci

00:14.2 Signal processing controller: Intel Corporation Sunrise Point-LP Th=
ermal subsystem (rev 21)
	Subsystem: Dell Sunrise Point-LP Thermal subsystem
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at dc738000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Kernel driver in use: intel_pch_thermal
	Kernel modules: intel_pch_thermal

00:15.0 Signal processing controller: Intel Corporation Sunrise Point-LP Se=
rial IO I2C Controller #0 (rev 21)
	Subsystem: Dell Sunrise Point-LP Serial IO I2C Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at dc737000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D3 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] Vendor Specific Information: Len=3D14 <?>
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci

00:15.1 Signal processing controller: Intel Corporation Sunrise Point-LP Se=
rial IO I2C Controller #1 (rev 21)
	Subsystem: Dell Sunrise Point-LP Serial IO I2C Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at dc736000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D3 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] Vendor Specific Information: Len=3D14 <?>
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci

00:16.0 Communication controller: Intel Corporation Sunrise Point-LP CSME H=
ECI #1 (rev 21)
	Subsystem: Dell Sunrise Point-LP CSME HECI
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 131
	Region 0: Memory at dc735000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee00398  Data: 0000
	Kernel driver in use: mei_me
	Kernel modules: mei_me

00:17.0 SATA controller: Intel Corporation Sunrise Point-LP SATA Controller=
 [AHCI mode] (rev 21) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Sunrise Point-LP SATA Controller [AHCI mode]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 130
	Region 0: Memory at dc730000 (32-bit, non-prefetchable) [size=3D8K]
	Region 1: Memory at dc734000 (32-bit, non-prefetchable) [size=3D256]
	Region 2: I/O ports at f090 [size=3D8]
	Region 3: I/O ports at f080 [size=3D4]
	Region 4: I/O ports at f060 [size=3D32]
	Region 5: Memory at dc733000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee00378  Data: 0000
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1c.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Por=
t #1 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Bus: primary=3D00, secondary=3D01, subordinate=3D39, sec-latency=3D0
	I/O behind bridge: 00002000-00003fff [size=3D8K]
	Memory behind bridge: c4000000-da0fffff [size=3D353M]
	Prefetchable memory behind bridge: 00000000a0000000-00000000c1ffffff [size=
=3D544M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 8GT/s, Width x2, ASPM not supported
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x2 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #4, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not Suppo=
rted ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, Equali=
zationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Sunrise Point-LP PCI Express Root Port
	Capabilities: [a0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
		RootCmd: CERptEn- NFERptEn- FERptEn-
		RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
			 FirstFatal- NonFatalMsg- FatalMsg- IntMsg 0
		ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
	Capabilities: [140 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd- EgressCtrl=
- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl=
- DirectTrans-
	Capabilities: [200 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D40us PortTPowerOnTime=3D10us
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
			   T_CommonMode=3D0us LTR1.2_Threshold=3D0ns
		L1SubCtl2: T_PwrOn=3D10us
	Capabilities: [220 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Por=
t #5 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Bus: primary=3D00, secondary=3D3a, subordinate=3D3a, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff [empty]
	Memory behind bridge: dc000000-dc4fffff [size=3D5M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [empt=
y]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 8GT/s, Width x1, ASPM L1, Exit Latency L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (downgraded), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #8, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR-, OBFF Not Suppo=
rted ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Sunrise Point-LP PCI Express Root Port
	Capabilities: [a0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
		RootCmd: CERptEn- NFERptEn- FERptEn-
		RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
			 FirstFatal- NonFatalMsg- FatalMsg- IntMsg 0
		ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
	Capabilities: [140 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd- EgressCtrl=
- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl=
- DirectTrans-
	Capabilities: [200 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D40us PortTPowerOnTime=3D10us
		L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
			   T_CommonMode=3D40us LTR1.2_Threshold=3D163840ns
		L1SubCtl2: T_PwrOn=3D50us
	Capabilities: [220 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Por=
t #6 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Bus: primary=3D00, secondary=3D3b, subordinate=3D3b, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff [empty]
	Memory behind bridge: dc600000-dc6fffff [size=3D1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [empt=
y]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 8GT/s, Width x1, ASPM L1, Exit Latency L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s (downgraded), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #9, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not Suppo=
rted ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Sunrise Point-LP PCI Express Root Port
	Capabilities: [a0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
		RootCmd: CERptEn- NFERptEn- FERptEn-
		RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
			 FirstFatal- NonFatalMsg- FatalMsg- IntMsg 0
		ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
	Capabilities: [140 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd- EgressCtrl=
- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl=
- DirectTrans-
	Capabilities: [220 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

00:1d.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Por=
t #9 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Bus: primary=3D00, secondary=3D3c, subordinate=3D3c, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff [empty]
	Memory behind bridge: dc500000-dc5fffff [size=3D1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [empt=
y]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #9, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #12, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not Suppo=
rted ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, Equali=
zationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Sunrise Point-LP PCI Express Root Port
	Capabilities: [a0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
		RootCmd: CERptEn- NFERptEn- FERptEn-
		RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
			 FirstFatal- NonFatalMsg- FatalMsg- IntMsg 0
		ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
	Capabilities: [140 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd- EgressCtrl=
- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl=
- DirectTrans-
	Capabilities: [200 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D40us PortTPowerOnTime=3D10us
		L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
			   T_CommonMode=3D40us LTR1.2_Threshold=3D163840ns
		L1SubCtl2: T_PwrOn=3D10us
	Capabilities: [220 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Sunrise Point-LP LPC Controller (rev =
21)
	Subsystem: Dell Sunrise Point-LP LPC Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:1f.2 Memory controller: Intel Corporation Sunrise Point-LP PMC (rev 21)
	Subsystem: Dell Sunrise Point-LP PMC
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at dc72c000 (32-bit, non-prefetchable) [disabled] [size=
=3D16K]

00:1f.3 Audio device: Intel Corporation Sunrise Point-LP HD Audio (rev 21) =
(prog-if 80)
	Subsystem: Dell Sunrise Point-LP HD Audio
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 134
	Region 0: Memory at dc728000 (64-bit, non-prefetchable) [size=3D16K]
	Region 4: Memory at dc700000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0-,D1-,D2-,D3hot+,D3co=
ld+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee003d8  Data: 0000
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_soc_skl

00:1f.4 SMBus: Intel Corporation Sunrise Point-LP SMBus (rev 21)
	Subsystem: Dell Sunrise Point-LP SMBus
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at dc732000 (64-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at f040 [size=3D32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c_i801

01:00.0 PCI bridge: Intel Corporation DSL6340 Thunderbolt 3 Bridge [Alpine =
Ridge 2C 2015] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 16
	Bus: primary=3D01, secondary=3D02, subordinate=3D39, sec-latency=3D0
	I/O behind bridge: 00002000-00002fff [size=3D4K]
	Memory behind bridge: c4000000-da0fffff [size=3D353M]
	Prefetchable memory behind bridge: 00000000a0000000-00000000c1ffffff [size=
=3D544M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [88] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [ac] Subsystem: Device 2222:1111
	Capabilities: [c0] Express (v2) Upstream Port, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ SlotPowerLimit 25.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <2u=
s, L1 <4us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x2 (downgraded)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF Not S=
upported
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+, Equaliza=
tionPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [100 v1] Device Serial Number a3-21-c0-79-f9-23-04-00
	Capabilities: [200 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP+ Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [300 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [400 v1] Power Budgeting <?>
	Capabilities: [500 v1] Vendor Specific Information: ID=3D1234 Rev=3D1 Len=
=3D0d8 <?>
	Capabilities: [600 v1] Latency Tolerance Reporting
		Max snoop latency: 71680ns
		Max no snoop latency: 71680ns
	Capabilities: [700 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

02:00.0 PCI bridge: Intel Corporation DSL6340 Thunderbolt 3 Bridge [Alpine =
Ridge 2C 2015] (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 16
	Bus: primary=3D02, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff [empty]
	Memory behind bridge: da000000-da0fffff [size=3D1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [empt=
y]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D3 NoSoftRst+ PME-Enable+ DSel=3D0 DScale=3D0 PME-
	Capabilities: [88] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [ac] Subsystem: Device 2222:1111
	Capabilities: [c0] Express (v2) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <=
2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF Not S=
upported ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Device Serial Number a3-21-c0-79-f9-23-04-00
	Capabilities: [200 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [300 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending+ InProgress-
	Capabilities: [400 v1] Power Budgeting <?>
	Capabilities: [500 v1] Vendor Specific Information: ID=3D1234 Rev=3D1 Len=
=3D0d8 <?>
	Capabilities: [700 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

02:01.0 PCI bridge: Intel Corporation DSL6340 Thunderbolt 3 Bridge [Alpine =
Ridge 2C 2015] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 17
	Bus: primary=3D02, secondary=3D04, subordinate=3D38, sec-latency=3D0
	I/O behind bridge: 00002000-00002fff [size=3D4K]
	Memory behind bridge: c4000000-d9efffff [size=3D351M]
	Prefetchable memory behind bridge: 00000000a0000000-00000000c1ffffff [size=
=3D544M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [88] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [ac] Subsystem: Device 2222:1111
	Capabilities: [c0] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <=
2us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF Not S=
upported ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Device Serial Number a3-21-c0-79-f9-23-04-00
	Capabilities: [200 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [300 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending+ InProgress-
	Capabilities: [400 v1] Power Budgeting <?>
	Capabilities: [500 v1] Vendor Specific Information: ID=3D1234 Rev=3D1 Len=
=3D0d8 <?>
	Capabilities: [700 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

02:02.0 PCI bridge: Intel Corporation DSL6340 Thunderbolt 3 Bridge [Alpine =
Ridge 2C 2015] (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 18
	Bus: primary=3D02, secondary=3D39, subordinate=3D39, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff [empty]
	Memory behind bridge: d9f00000-d9ffffff [size=3D1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [empt=
y]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [88] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [ac] Subsystem: Device 2222:1111
	Capabilities: [c0] Express (v2) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <=
2us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF Not S=
upported ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Device Serial Number a3-21-c0-79-f9-23-04-00
	Capabilities: [200 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [300 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [400 v1] Power Budgeting <?>
	Capabilities: [500 v1] Vendor Specific Information: ID=3D1234 Rev=3D1 Len=
=3D0d8 <?>
	Capabilities: [700 v1] Secondary PCI Express <?>
	Kernel driver in use: pcieport

39:00.0 USB controller: Intel Corporation DSL6340 USB 3.1 Controller [Alpin=
e Ridge] (prog-if 30 [XHCI])
	Subsystem: Device 2222:1111
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 129
	Region 0: Memory at d9f00000 (32-bit, non-prefetchable) [size=3D64K]
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [88] MSI: Enable+ Count=3D1/8 Maskable- 64bit+
		Address: 00000000fee00358  Data: 0000
	Capabilities: [c0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <8us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <=
2us, L1 <4us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+, OBFF Not Support=
ed
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Device Serial Number a3-21-c0-79-f9-23-04-00
	Capabilities: [200 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [300 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [400 v1] Power Budgeting <?>
	Capabilities: [500 v1] Vendor Specific Information: ID=3D1234 Rev=3D1 Len=
=3D0d8 <?>
	Capabilities: [600 v1] Latency Tolerance Reporting
		Max snoop latency: 71680ns
		Max no snoop latency: 71680ns
	Capabilities: [700 v1] Secondary PCI Express <?>
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci

3a:00.0 Network controller: Broadcom Inc. and subsidiaries BCM4350 802.11ac=
 Wireless Network Adapter (rev 08)
	Subsystem: Dell BCM4350 802.11ac Wireless Network Adapter
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 133
	Region 0: Memory at dc400000 (64-bit, non-prefetchable) [size=3D32K]
	Region 2: Memory at dc000000 (64-bit, non-prefetchable) [size=3D4M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [58] MSI: Enable+ Count=3D1/16 Maskable- 64bit+
		Address: 00000000fee003b8  Data: 0000
	Capabilities: [68] Vendor Specific Information: Len=3D44 <?>
	Capabilities: [ac] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 10.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <=
2us, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Via WAKE#
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, Equali=
zationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [13c v1] Device Serial Number 00-00-bf-ff-ff-30-74-df
	Capabilities: [150 v1] Power Budgeting <?>
	Capabilities: [160 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [1b0 v1] Latency Tolerance Reporting
		Max snoop latency: 3145728ns
		Max no snoop latency: 3145728ns
	Capabilities: [220 v1] Resizable BAR <?>
	Capabilities: [240 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D0us PortTPowerOnTime=3D50us
		L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
			   T_CommonMode=3D0us LTR1.2_Threshold=3D163840ns
		L1SubCtl2: T_PwrOn=3D50us
	Kernel driver in use: brcmfmac
	Kernel modules: brcmfmac

3b:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PC=
I Express Card Reader (rev 01)
	Subsystem: Dell RTS525A PCI Express Card Reader
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 127
	Region 1: Memory at dc600000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee00318  Data: 0000
	Capabilities: [b0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 10.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s unl=
imited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s (ok), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF Via m=
essage/WAKE#
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCC=
hkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [148 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
	Capabilities: [158 v1] Latency Tolerance Reporting
		Max snoop latency: 3145728ns
		Max no snoop latency: 3145728ns
	Capabilities: [160 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D60us PortTPowerOnTime=3D60us
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
			   T_CommonMode=3D0us LTR1.2_Threshold=3D0ns
		L1SubCtl2: T_PwrOn=3D10us
	Kernel driver in use: rtsx_pci
	Kernel modules: rtsx_pci

3c:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD=
 Controller SM981/PM981 (prog-if 02 [NVM Express])
	Subsystem: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	NUMA node: 0
	Region 0: Memory at dc500000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 25.000W
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Not Supp=
orted
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+, Equaliza=
tionPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [b0] MSI-X: Enable+ Count=3D33 Masked-
		Vector table: BAR=3D0 offset=3D00003000
		PBA: BAR=3D0 offset=3D00002000
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCC=
hkEn-
			MultHdrRecCap+ MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [148 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [158 v1] Power Budgeting <?>
	Capabilities: [168 v1] Secondary PCI Express <?>
	Capabilities: [188 v1] Latency Tolerance Reporting
		Max snoop latency: 3145728ns
		Max no snoop latency: 3145728ns
	Capabilities: [190 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=3D10us PortTPowerOnTime=3D10us
		L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
			   T_CommonMode=3D0us LTR1.2_Threshold=3D163840ns
		L1SubCtl2: T_PwrOn=3D10us
	Kernel driver in use: nvme

```

[8.6.] /proc/scsi/scsi
```
Attached devices:
<blank>
```

[8.7.] Other information: N/A

Thank you.
--=20
- Aaron
PGP Key: 0x136159E6
https://pgp.mit.edu/pks/lookup?op=3Dget&search=3D0x0B551238136159E6

--cz4f5ru7tf6x6263
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElnIuPl3BRN/sHHOzC1USOBNhWeYFAlxiYEcACgkQC1USOBNh
Wea9ng/9FofjkgKKbn2b+kDgco/JrUjG5th3i8rbUEdOHa+PZb8uMxtpOPFZIys3
EOZfBiFk/VflB5bzWDAD/GBlyGzVe9WbRYVO6WG6cCa/Ws9Vx4ivA/AAB2uHR8Pr
WuBhnodkQCQBHt0QKGxDVv3XmgCWCHjJxiO2ivLZ3dxdi1Ddcjx82QknPOQ+qOfL
WMW56ZbefOUCn6oXyt1RN9lXf91p1RSUcmfZJvHm7XTMMP0XPU7ikjaPf14B+ukV
ZxTZY1QaQZ3jCoL7ZNSqeJD8pJgrdYx/VXRH3qTnDTOtnZJp8aDGDXSxlrJh53EM
832Z+lAJF8irygq73uTAQHoSbgyDgOmdeUD4WjBpxZzubAXHr5aDnvtri3lfLeIy
mQpk5CNktprg0snAa9AOHLBqRuDt+QDeJ1BirU5+BLBdA8J2m9eHmOqnZiklstFj
4MVEVuPdyVPUa2Zx+723vm9qnzNOp/ADGmpDlxS0s0KaV8qsOfGuBenvu39p9LFn
wo2jpYKXfN6xfDBAD8j0cE7ROV7jvh1rQiFg8yNd2J6PHXe8bKFbIZLvuvWYp2KH
EBYJPqeRrWrGl05POA1WseRtRyHrZRSE2/s9pNt/IAD5A+VHpiBUJ6tI2xcK3l8r
Phez9CKRcrnPRdLykC2ncJUYoRB/keAlCVN3XzYgc46/iOfaN68=
=VtRV
-----END PGP SIGNATURE-----

--cz4f5ru7tf6x6263--
