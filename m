Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:49229 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbXCQENI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 00:13:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id 03900108061
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 14:46:14 +1100 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (betty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 11016-02-31 for <linux-wireless@vger.kernel.org>;
	Sat, 17 Mar 2007 14:46:12 +1100 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.91])
	by mail.cbit.net.au (Postfix) with ESMTP id 96EF010802E
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 14:46:12 +1100 (EST)
Date: Sat, 17 Mar 2007 14:46:07 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Message-ID: <20070317034607.GA1522@keitarou>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I was just giving the prism54pci code a whirl, with my NetComm NP5430
Cardbus card, and it BUGged the kernel during driver load (or
immediately after driver load failed, I guess) as follows:

Mar 17 02:34:23 su kernel: pccard: CardBus card inserted into slot 0
Mar 17 02:34:23 su kernel: PCI: Enabling device 0001:11:00.0 (0000 -> 0002)
Mar 17 02:34:23 su kernel: p54: LM86 firmware
Mar 17 02:34:25 su kernel: 0001:11:00.0 (prism54pci): Cannot read eeprom!
Mar 17 02:34:25 su kernel: prism54pci: probe of 0001:11:00.0 failed with er=
ror -22
Mar 17 02:34:25 su kernel: pci 0001:11:00.0: Error adding device, continuing
Mar 17 02:34:25 su kernel: ------------[ cut here ]------------
Mar 17 02:34:25 su kernel: kernel BUG at drivers/pci/bus.c:127!
Mar 17 02:34:25 su kernel: Oops: Exception in kernel mode, sig: 5 [#1]
Mar 17 02:34:25 su kernel: PREEMPT=20
Mar 17 02:34:25 su kernel: Modules linked in: prism54pci prism54common cdc_=
subset cdc_ether usbnet binfmt_misc rfcomm ipv6 af_packet fuse hci_usb l2ca=
p bluetooth cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conse=
rvative i2c_dev snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd=
_seq snd_seq_device radeon drm therm_adt746x sbp2 scsi_mod snd_aoa_codec_ta=
s snd_aoa_fabric_layout snd_aoa snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss sn=
d_pcm snd_timer snd_page_alloc snd pcmcia soundcore firmware_class ssb snd_=
aoa_soundbus mac80211 yenta_socket rsrc_nonstatic pcmcia_core evdev uninort=
h_agp agpgart cfg80211 ext3 jbd mbcache sungem sungem_phy ohci1394 ieee1394=
 ide_cd cdrom
Mar 17 02:34:25 su kernel: NIP: C0107A2C LR: C01079E8 CTR: C002636C
Mar 17 02:34:25 su kernel: REGS: c2601e80 TRAP: 0700   Tainted: GF      (2.=
6.20)
Mar 17 02:34:25 su kernel: MSR: 00029032 <EE,ME,IR,DR>  CR: 28000024  XER: =
00000000
Mar 17 02:34:25 su kernel: TASK =3D c241b210[1462] 'pccardd' THREAD: c26000=
00
Mar 17 02:34:25 su kernel: GPR00: 00000001 C2601F30 C241B210 C257100C 00000=
001 00000000 00000000 00000000=20
Mar 17 02:34:25 su kernel: GPR08: 00000000 D9EA8008 00004336 C2600000 00000=
000 00000000 00000000 00000000=20
Mar 17 02:34:25 su kernel: GPR16: 00000000 00000000 00000000 00000000 00000=
000 41400000 016AE808 016AEA24=20
Mar 17 02:34:25 su kernel: GPR24: 00000000 00327000 DFFF5900 C28EBCE8 00000=
002 C2571014 C2571000 D9EA8000=20
Mar 17 02:34:25 su kernel: NIP [C0107A2C] pci_bus_add_devices+0x94/0x164
Mar 17 02:34:25 su kernel: LR [C01079E8] pci_bus_add_devices+0x50/0x164
Mar 17 02:34:25 su kernel: Call Trace:
Mar 17 02:34:25 su kernel: [C2601F30] [C01079E8] pci_bus_add_devices+0x50/0=
x164 (unreliable)
Mar 17 02:34:25 su kernel: [C2601F50] [E2261684] cb_alloc+0xe0/0x100 [pcmci=
a_core]
Mar 17 02:34:25 su kernel: [C2601F70] [E225DA0C] socket_insert+0x100/0x140 =
[pcmcia_core]
Mar 17 02:34:25 su kernel: [C2601F80] [E225E028] pccardd+0x1a8/0x258 [pcmci=
a_core]
Mar 17 02:34:25 su kernel: [C2601FC0] [C004261C] kthread+0xc4/0x100
Mar 17 02:34:25 su kernel: [C2601FF0] [C00121C4] kernel_thread+0x44/0x60
Mar 17 02:34:25 su kernel: Instruction dump:
Mar 17 02:34:25 su kernel: 7c00022c 3bbf0008 381e0014 7f9d0000 7fe3fb78 409=
effa4 813e0014 480000b0=20
Mar 17 02:34:25 su kernel: 801f0000 7c00fa78 7c000034 5400d97e <0f000000> 8=
17f0014 2f8b0000 419e008c=20

When I then pulled the card out, the machine hardlocked. >_< (Hooray for
sync!)

It's a Debian-sourced 2.6.20 kernel with the Intel mac80211 4.0.4
patchset applied as well as a patch to revert the bad get_order changes.

The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
CardBus Atheros card I've got lying around with dadwifi-openhal, it
fails with some sort of hardware error.  (ie. it _might_ be a dodgey
Cardbus port, although both cardbus cards used to work in this machine,
using prism54 hardmac and the dadwifi with atheros hal driver
respectively)

(Albeit the hardmach driver never managed to WPA, and as of 2.6.20 still
doesn't, haven't tried the version in wireless-dev yet)

The card reports itself in lspci as:
0001:11:00.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Pri=
sm Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
0001:11:00.0 0280: 1260:3890 (rev 01)

The machine is a PowerBook G4 15", PowerPC.

The drivers are from wireless-dev 4533da881f2d8c3e0dbb5b3dbc7a919e12438a8a
built with the following shell script:

#! /bin/sh
KERN=3D2.6.20
KPATH=3D/usr/src/linux-headers-$KERN/
cd build/ssb
make -C $KPATH CFLAGS_MODULE=3D"-DMODULE -I"$PWD"/../include -DCONFIG_SSB=
=3Dm -DCONFIG_SSB_PCIHOST=3Dy -DCONFIG_SSB_DRIVER_PCICORE=3Dy" M=3D"$PWD" C=
ONFIG_SSB=3Dm CONFIG_SSB_PCIHOST=3Dy CONFIG_SSB_DRIVER_PCICORE=3Dy $*
cd ../..
cd build/bcm43xx
make -C $KPATH CFLAGS_MODULE=3D"-DMODULE -I"$PWD"/../include -DCONFIG_SSB=
=3Dm -DCONFIG_SSB_PCIHOST=3Dy -DCONFIG_SSB_DRIVER_PCICORE=3Dy -DCONFIG_BCM4=
3XX_MAC80211=3Dm -DCONFIG_BCM43XX_MAC80211_PCI=3Dy -DCONFIG_BCM43XX_MAC8021=
1_DEBUG=3Dy -DCONFIG_BCM43XX_MAC80211_DMA=3Dy -DCONFIG_BCM43XX_MAC80211_PIO=
=3Dy" M=3D"$PWD" CONFIG_SSB=3Dm CONFIG_SSB_PCIHOST=3Dy CONFIG_SSB_DRIVER_PC=
ICORE=3Dy CONFIG_BCM43XX_MAC80211=3Dm CONFIG_BCM43XX_MAC80211_PCI=3Dy CONFI=
G_BCM43XX_MAC80211_DEBUG=3Dy CONFIG_BCM43XX_MAC80211_DMA=3Dy CONFIG_BCM43XX=
_MAC80211_PIO=3Dy $*
cd ../..
cd build/p54
make -C $KPATH CFLAGS_MODULE=3D"-DMODULE -DCONFIG_P54_COMMON=3Dm -DCONFIG_P=
54_PCI=3Dm" M=3D"$PWD" CONFIG_P54_COMMON=3Dm CONFIG_P54_PCI=3Dm $*

The prism54 firmwares in /lib/firmware are:

09f9da7ea757173c9de1a0322a1f9782  /lib/firmware/isl3886
tbble@su:~$ hd /lib/firmware/isl3886 |head
00000000  00 00 a0 e1 80 f3 9f e5  00 00 00 00 00 00 00 00 |...............=
=2E|
00000010  00 00 00 00 01 00 00 80  01 00 00 00 4c 4d 38 36 |............LM8=
6|
00000020  02 00 00 80 06 00 00 00  32 2e 37 2e 30 2e 30 00 |........2.7.0.0=
=2E|

8bd4310971772a486b9784c77f8a6df9  /lib/firmware/isl3890
tbble@su:~$ hd /lib/firmware/isl3890 |head
00000000  36 00 00 ea 35 00 00 ea  34 00 00 ea 33 00 00 ea |6...5...4...3..=
=2E|
00000010  32 00 00 ea 01 00 00 80  01 00 00 00 4c 43 4c 31 |2...........LCL=
1|
00000020  02 00 00 80 06 00 00 00  31 2e 30 2e 34 2e 33 00 |........1.0.4.3=
=2E|

The code where it BUGS:

/**
 * add a single device
 * @dev: device to add
 *
 * This adds a single pci device to the global
 * device list and adds sysfs and procfs entries
 */
int __devinit pci_bus_add_device(struct pci_dev *dev)
{
	int retval;
	retval =3D device_add(&dev->dev);
	if (retval)
		return retval;

	down_write(&pci_bus_sem);
	list_add_tail(&dev->global_list, &pci_devices);
	up_write(&pci_bus_sem);

	pci_proc_attach_device(dev);
	pci_create_sysfs_dev_files(dev);
	return 0;
}

/**
 * pci_bus_add_devices - insert newly discovered PCI devices
 * @bus: bus to check for new devices
 *
 * Add newly discovered PCI devices (which are on the bus->devices
 * list) to the global PCI device list, add the sysfs and procfs
 * entries.  Where a bridge is found, add the discovered bus to
 * the parents list of child buses, and recurse (breadth-first
 * to be compatible with 2.4)
 *
 * Call hotplug for each new devices.
 */
void __devinit pci_bus_add_devices(struct pci_bus *bus)
{
	struct pci_dev *dev;
	int retval;

	list_for_each_entry(dev, &bus->devices, bus_list) {
		/*
		 * Skip already-present devices (which are on the
		 * global device list.)
		 */
		if (!list_empty(&dev->global_list))
			continue;
		retval =3D pci_bus_add_device(dev);
		if (retval)
			dev_err(&dev->dev, "Error adding device, continuing\n");
	}

	list_for_each_entry(dev, &bus->devices, bus_list) {

127:	BUG_ON(list_empty(&dev->global_list));

		/*
		 * If there is an unattached subordinate bus, attach
		 * it and then scan for unattached PCI devices.
		 */
		if (dev->subordinate) {
		       if (list_empty(&dev->subordinate->node)) {
			       down_write(&pci_bus_sem);
			       list_add_tail(&dev->subordinate->node,
					       &dev->bus->children);
			       up_write(&pci_bus_sem);
			}
			pci_bus_add_devices(dev->subordinate);
			retval =3D sysfs_create_link(&dev->subordinate->class_dev.kobj,
						   &dev->dev.kobj, "bridge");
			if (retval)
				dev_err(&dev->dev, "Error creating sysfs "
					"bridge symlink, continuing...\n");
		}
	}
}

In this case, I get the 'Error adding device', which means
list_add_tail(&dev->global_list, &pci_devices) wasn't called in
pci_bus_add_device. This implies that the failure path for
device_add (in this case, AttachError: calling bus_attach_device in
drivers/base/core.c, which ends up collecting the -EINVAL from the
probe) should be removing the device from bus->devices (I think...)
but I guess it's not.

So maybe the BUG isn't a problem with the p54 driver, but I'd appreciate
help with making it find the eeprom so it doesn't happen...

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+2R/exDuohKLFuARAs2MAJ9TYpcQnaWUIebsahPx2c7Vt/iBgACfduCV
oSfzTICncdimc8Vc+EpOLX0=
=AJEX
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
