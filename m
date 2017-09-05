Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip1.cmyers.org ([64.62.231.219]:45860 "EHLO mail.cmyers.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbdIEQvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 12:51:13 -0400
Date: Tue, 5 Sep 2017 09:51:12 -0700
From: Carl Myers <cmyers@cmyers.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: Bug Report for iwlwifi kernel module
Message-ID: <20170905165112.GF7829@cmyers.org> (sfid-20170905_185136_063165_8D059E95)
References: <20170903191552.GE7829@cmyers.org>
 <1504510477.5400.23.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
In-Reply-To: <1504510477.5400.23.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luca,

On Mon, Sep 04, 2017 at 10:34:37AM +0300, Luca Coelho wrote:
> Date: Mon, 04 Sep 2017 10:34:37 +0300
> From: Luca Coelho <luca@coelho.fi>
> To: Carl Myers <cmyers@cmyers.org>, linux-wireless@vger.kernel.org
> Cc: linuxwifi@intel.com
> Subject: Re: Bug Report for iwlwifi kernel module
>=20
> Hi Carl,
>=20
> On Sun, 2017-09-03 at 12:15 -0700, Carl Myers wrote:
> > Greetings all,
> >=20
> > Apologies if any of this is wrong, this is my first attempt to report a=
 bug in
> > the linux kernel =3D)
> >=20
> > I got here by running the get_maintainer script on the iwlwifi director=
y of a
> > linux kernel checkout.
> >=20
> > I am running debian stock kernel 4.8.15, and using the built in iwlwifi
> > driver
> >=20
> > $=E2=AE=80 uname -a
> > Linux powerhouse 4.8.0-2-amd64 #1 SMP Debian 4.8.15-2 (2017-01-04) x86_=
64 GNU/Linux
> > $=E2=AE=80 dpkg -l | grep iwlwifi
> > ii  firmware-iwlwifi                      20160110-1~bpo8+1            =
     all          Binary firmware for Intel Wireless cards
> >=20
> > I am on a slightly  older firmware and kernel due to the currently-outs=
tanding bug:
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D849330
> >=20
> > This is the newest combination of kernel/firmware I've been able to mak=
e work.
> >=20
> > Here is the lspci -v output for my wifi:
> > 03:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
> >         Subsystem: Intel Corporation Wireless 8260
> >         Flags: bus master, fast devsel, latency 0, IRQ 136
> >         Memory at df200000 (64-bit, non-prefetchable) [size=3D8K]
> >         Capabilities: <access denied>
> >         Kernel driver in use: iwlwifi
> >         Kernel modules: iwlwifi
>=20
> First of all, what makes you think this is a bug in the iwlwifi driver
> module?
>=20
>=20
Ok, good question.  It's been giving me problems and I was mucking with it.
Every so often, my wifi just quits working and I have a script that unloads=
 and
reloads the module, whih generally fixes it for a time.  I thought it was l=
ikely
the cause because I was messing with it at the time and it was first in the=
 list
of modules, but now that you mention it, I guess it was only listed first
because it was recently removed and re-added.

> > Recently, while testing a 2nd panda wifi card (trying to make a hotspot=
 and use
> > the iwl card as a gateway device), I got a kernel panic.  Here is the r=
elevant
> > excerpt from kern.log:
> >=20
> > Sep  3 11:37:49 powerhouse kernel: [21394.510512] ------------[ cut her=
e ]------------
> > Sep  3 11:37:49 powerhouse kernel: [21394.510514] kernel BUG at /build/=
linux-zDY19G/linux-4.8.15/kernel/module.c:890!
> > Sep  3 11:37:49 powerhouse kernel: [21394.510515] invalid opcode: 0000 =
[#1] SMP
> > Sep  3 11:37:49 powerhouse kernel: [21394.510516] Modules linked in: iw=
lmvm iwlwifi ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_nat_h323 nf_conntrack_h=
323 nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre n=
f_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conn=
track_irc nf_nat_ftp nf_conntrack_ftp hid_generic rt2800usb rt2x00usb rt280=
0lib rt2x00lib crc_ccitt ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack=
_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_def=
rag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack br_netfil=
ter bridge stp overlay iptable_filter appletalk ax25 ipx p8023 p8022 psnap =
llc bnep snd_hda_codec_hdmi arc4 binfmt_misc nls_ascii nls_cp437 vfat fat m=
ac80211 snd_hda_codec_realtek intel_rapl x86_pkg_temp_thermal mxm_wmi intel=
_powerclamp coretemp snd_hda_codec_generic kvm_intel kvm efi_pstore irqbypa=
ss snd_hda_intel intel_cstate snd_hda_codec uvcvideo videobuf2_vmalloc rtsx=
_pci_ms videobuf2_memops snd_hda_core videobuf2_v4l2 iTCO_wdt videobuf2_cor=
e snd_hwdep intel_uncore videodev joydev btusb intel_rapl_perf evdev media =
btrtl cfg80211 serio_raw pcspkr efivars memstick iTCO_vendor_support snd_pc=
m snd_timer mei_me hci_uart snd mei soundcore btbcm btqca btintel bluetooth=
 rfkill wmi video intel_lpss_acpi intel_lpss shpchp battery acpi_pad ac tpm=
_tis button tpm_tis_core tpm nvidia_drm(POE) drm_kms_helper drm nvidia_mode=
set(POE) nvidia(POE) parport_pc ppdev lp parport efivarfs ip_tables x_table=
s autofs4 ext4 crc16 jbd2 crc32c_generic fscrypto ecb mbcache algif_skciphe=
r af_alg dm_crypt dm_mod hid_logitech_hidpp hid_logitech_dj usbhid rtsx_pci=
_sdmmc mmc_core crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_in=
tel aesni_intel ahci libahci aes_x86_64 lrw gf128mul glue_helper xhci_pci a=
blk_helper cryptd libata xhci_hcd psmouse usbcore nvme scsi_mod i2c_i801 nv=
me_core i2c_smbus rtsx_pci r8169 mii mfd_core usb_common thermal i2c_hid hi=
d fjes [last unloaded: iwlwifi]
> > Sep  3 11:37:49 powerhouse kernel: [21394.510561] CPU: 4 PID: 8122 Comm=
: rmmod Tainted: P  R        OE   4.8.0-2-amd64 #1 Debian 4.8.15-2
> > Sep  3 11:37:49 powerhouse kernel: [21394.510562] Hardware name: System=
76, Inc. Oryx Pro/Oryx Pro, BIOS 1.05.09RSA1 11/16/2015
> > Sep  3 11:37:49 powerhouse kernel: [21394.510563] task: ffff8dec4a3e000=
0 task.stack: ffff8decf4cd4000
> > Sep  3 11:37:49 powerhouse kernel: [21394.510564] RIP: 0010:[<ffffffffb=
ccf98b9>]  [<ffffffffbccf98b9>] SyS_delete_module+0x259/0x260
> > Sep  3 11:37:49 powerhouse kernel: [21394.510568] RSP: 0018:ffff8decf4c=
d7ef0  EFLAGS: 00010297
> > Sep  3 11:37:49 powerhouse kernel: [21394.510569] RAX: 00000000ffffffff=
 RBX: ffffffffc1aa71c0 RCX: 0000000000000005
> > Sep  3 11:37:49 powerhouse kernel: [21394.510570] RDX: ffffffffc1aa74a0=
 RSI: ffffffffc1aa74c8 RDI: ffffffffc1aa71d8
> > Sep  3 11:37:49 powerhouse kernel: [21394.510571] RBP: 000055fb472021f0=
 R08: 0000000000000000 R09: 000000000000006d
> > Sep  3 11:37:49 powerhouse kernel: [21394.510572] R10: 000055fb472011c0=
 R11: 8080808080808080 R12: 0000000000000a00
> > Sep  3 11:37:49 powerhouse kernel: [21394.510572] R13: 0000000000000a00=
 R14: 00007fff6cd8d4f8 R15: 0000000000000000
> > Sep  3 11:37:49 powerhouse kernel: [21394.510573] FS:  00007f498ef22700=
(0000) GS:ffff8ded76500000(0000) knlGS:0000000000000000
> > Sep  3 11:37:49 powerhouse kernel: [21394.510574] CS:  0010 DS: 0000 ES=
: 0000 CR0: 0000000080050033
> > Sep  3 11:37:49 powerhouse kernel: [21394.510575] CR2: 00007f498eacf801=
 CR3: 0000000fa99d0000 CR4: 00000000003406e0
> > Sep  3 11:37:49 powerhouse kernel: [21394.510576] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
> > Sep  3 11:37:49 powerhouse kernel: [21394.510576] DR3: 0000000000000000=
 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Sep  3 11:37:49 powerhouse kernel: [21394.510577] Stack:
> > Sep  3 11:37:49 powerhouse kernel: [21394.510578]  00006d766d6c7769 000=
0000000000002 ffff8decf4cd4000 ffffffffbcc03290
> > Sep  3 11:37:49 powerhouse kernel: [21394.510579]  ffff8decf4cd7f58 fff=
f8decf4cd4000 0000000000000050 00000000520cd409
> > Sep  3 11:37:49 powerhouse kernel: [21394.510581]  00007fff6cd8d338 000=
055fb472021f0 00007fff6cd8d508 00007fff6cd8ebbb
> > Sep  3 11:37:49 powerhouse kernel: [21394.510582] Call Trace:
> > Sep  3 11:37:49 powerhouse kernel: [21394.510586]  [<ffffffffbcc03290>]=
 ? exit_to_usermode_loop+0xa0/0xc0
> > Sep  3 11:37:49 powerhouse kernel: [21394.510588]  [<ffffffffbd1e8cb6>]=
 ? system_call_fast_compare_end+0xc/0x96
> > Sep  3 11:37:49 powerhouse kernel: [21394.510588] Code: fe ff ff 41 f7 =
c4 00 02 00 00 48 c7 c5 f0 ff ff ff 0f 84 5c fe ff ff be 01 00 00 00 bf 03 =
00 00 00 e8 0c b3 f7 ff e9 b7 fe ff ff <0f> 0b e8 90 b4 f7 ff 0f 1f 44 00 0=
0 31 c0 c3 0f 1f 84 00 00 00=20
> > Sep  3 11:37:49 powerhouse kernel: [21394.510605] RIP  [<ffffffffbccf98=
b9>] SyS_delete_module+0x259/0x260
> > Sep  3 11:37:49 powerhouse kernel: [21394.510607]  RSP <ffff8decf4cd7ef=
0>
> > Sep  3 11:37:49 powerhouse kernel: [21394.510608] ---[ end trace 5b24b9=
3b49e857eb ]---
> > Sep  3 11:37:49 powerhouse kernel: [21409.372738] ieee80211 phy3: rt2x0=
0usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 w=
ith error -110
> > Sep  3 11:38:05 powerhouse kernel: [21425.406196] INFO: rcu_sched detec=
ted stalls on CPUs/tasks:
> > Sep  3 11:38:20 powerhouse kernel: [21425.406201] 	4-...: (0 ticks this=
 GP) idle=3D02d/140000000000000/0 softirq=3D277173/277173 fqs=3D8=20
> > Sep  3 11:38:20 powerhouse kernel: [21425.406202] 	(detected by 7, t=3D=
7721 jiffies, g=3D246559, c=3D246558, q=3D936)
> > Sep  3 11:38:20 powerhouse kernel: [21425.406204] Task dump for CPU 4:
> > Sep  3 11:38:20 powerhouse kernel: [21425.406206] rmmod           R  ru=
nning task        0  8122   8121 0x00000008
> > Sep  3 11:38:20 powerhouse kernel: [21425.406209]  0000000000000002 fff=
f8decf4cd7e48 ffffffffbd3df853 0000000000000000
> > Sep  3 11:38:20 powerhouse kernel: [21425.406211]  0000000000000000 fff=
fffffbcccc3d3 0000000000000246 000000000000000b
> > Sep  3 11:38:20 powerhouse kernel: [21425.406214]  ffffffffbcc289f8 000=
0000000000006 ffff8decf4cd7e48 0000000000000004
> > Sep  3 11:38:20 powerhouse kernel: [21425.406216] Call Trace:
> > Sep  3 11:38:20 powerhouse kernel: [21425.406222]  [<ffffffffbcccc3d3>]=
 ? kmsg_dump+0x93/0xb0
> > Sep  3 11:38:20 powerhouse kernel: [21425.406225]  [<ffffffffbcc289f8>]=
 ? oops_end+0x78/0xd0
> > Sep  3 11:38:20 powerhouse kernel: [21425.406228]  [<ffffffffbcc26446>]=
 ? do_error_trap+0x86/0x100
> > Sep  3 11:38:20 powerhouse kernel: [21425.406976]  [<ffffffffbccf98b9>]=
 ? SyS_delete_module+0x259/0x260
> > Sep  3 11:38:20 powerhouse kernel: [21425.406979]  [<ffffffffbcdda242>]=
 ? kmem_cache_alloc+0x122/0x530
> > Sep  3 11:38:20 powerhouse kernel: [21425.406982]  [<ffffffffbd1e9a2e>]=
 ? invalid_op+0x1e/0x30
> > Sep  3 11:38:20 powerhouse kernel: [21425.407276]  [<ffffffffbccf98b9>]=
 ? SyS_delete_module+0x259/0x260
> > Sep  3 11:38:20 powerhouse kernel: [21425.407277] perf: interrupt took =
too long (8612 > 2500), lowering kernel.perf_event_max_sample_rate to 23000
> > Sep  3 11:3Sep  3 11:39:51 powerhouse kernel: [    0.000000] Linux vers=
ion 4.8.0-2-amd64 (debian-kernel@lists.debian.org) (gcc version 5.4.1 20161=
202 (Debian 5.4.1-4) ) #1 SMP Debian 4.8.15-2 (2017-01-04)
> > Sep  3 11:39:51 powerhouse kernel: [    0.000000] Command line: BOOT_IM=
AGE=3D/vmlinuz-4.8.0-2-amd64 root=3D/dev/mapper/powerhouse--vg-root ro quiet
> >=20
> > Obviously, I'm not certain the bug is in this kernel module or even has
> > anything to do with it, but I thought this was a good place to start.  =
Advice
> > welcome, happy to help however I can, I am a software engineer but not =
very
> > experienced at kernel hacking.
>=20
> The bug you're seeing is happening in the module removal code[1].=20
> Apparently the system is getting a bad value in refcnt and it's becoming
> negative, which should never happen.  Have you been trying to force-
> remove modules or something like that?
>=20
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it/tree/kernel/module.c?h=3Dlinux-4.8.y#n890=C2=A0
>=20
> In any case, this doesn't seem like a iwlwifi bug at all.
>=20
> HTH.

Yeeeeahh, I don't normally force-remove it, but now that you mention it I d=
id
have to force remove it earlier that day, I think, I think I hadn't rebooted
since that.  So that very well could be the cause.  I guess if you do things
like force-remove kernel modules, then the results aren't necessarily a bug,
huh? =3D)

That was very helpful, thanks very much for your time!

I'd love to figure out how to make this module more stable for me, but I'm =
not
sure where to even get started, and since I am on old firmware (due to the
previously mentioned bug), I'm not sure it's worth poking until I can get o=
n the
tip version first.

Thanks again for your time!
-Carl

>=20
> --
> Cheers,
> Luca.

--=20
Carl Myers=20
PGP Key ID 3537595B
PGP Key fingerprint 9365 0FAF 721B 992A 0A20  1E0D C795 2955 3537 595B


--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlmu1gAACgkQx5UpVTU3WVuDZwCfVGTMVkAHuVMb3pptzCf3EMCn
VdYAl3Rqlw8lRzp9UEa6tKSVbk7W/UA=
=TIy4
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
