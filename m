Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXH3Lx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:53:59 -0400
Received: from [131.234.75.247]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IQiar-0002T7-BA
	for linux-wireless@vger.kernel.org; Thu, 30 Aug 2007 12:53:50 +0100
Subject: bad mac80211/softmac/xfs interaction
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tldMWYAbiNDi5PyXiKsA"
Date: Wed, 29 Aug 2007 16:21:41 +0200
Message-Id: <1188397301.8048.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tldMWYAbiNDi5PyXiKsA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

When I run something like "make" at the same time as my zd1211rw dongle
with softmac using wpa_supplicant, associated with an AP on the same
machine (!) using b43/hostapd, and then hit ctrl-c to abort
wpa_supplicant, I fairly frequently have some code try to run a freed
work struct.

Does anybody have an idea what could be the cause of this? I suppose the
XFS interaction is there so that the work item isn't immediately done,
and I can't reproduce easily if I don't run them both on the same
machine.

For completeness, log below.

johannes

[  216.200315] Unable to handle kernel paging request for data at address 0=
x6b6b6b6b
[  216.201488] Faulting instruction address: 0xc0040188
[  216.202451] Oops: Kernel access of bad area, sig: 11 [#1]
[  216.203361] PREEMPT PowerMac
[  216.204139] Modules linked in: ieee80211_crypt_ccmp af_packet b43 rc8021=
1_simple mac80211 cfg80211 zd1211rw ieee80211softmac ieee80211 ieee80211_cr=
ypt radeon drm binfmt_misc hci_usb rfcomm l2cap bluetooth configfs nls_utf8=
 hfsplus nls_base fuse dm_snapshot dm_mirror sha256 snd_aoa_codec_tas arc4 =
snd_aoa_fabric_layout snd_aoa joydev snd_aoa_i2sbus appletouch usbhid snd_p=
cm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd soundcore evdev s=
nd_aoa_soundbus ehci_hcd ohci_hcd ohci1394 ieee1394 usbcore ssb yenta_socke=
t rsrc_nonstatic pcmcia uninorth_agp pcmcia_core firmware_class agpgart uni=
x
[  216.210765] NIP: c0040188 LR: c00401e8 CTR: c0026210
[  216.211630] REGS: effd3ea0 TRAP: 0300   Not tainted  (2.6.23-rc3-g0347a7=
c8-dirty)
[  216.212579] MSR: 00001032 <ME,IR,DR>  CR: 22002028  XER: 00000000
[  216.213739] DAR: 6b6b6b6b, DSISR: 42000000
[  216.214573] TASK =3D effd0000[5] 'events/0' THREAD: effd2000
[  216.214776] GPR00: 00000000 effd3f50 effd0000 effe9070 c0008f20 00000000=
 e38e38e3 00000000=20
[  216.216136] GPR08: 241afd80 6b6b6b6b 10000000 6b6b6b6b 22002028 00000000=
 017855d0 0179db38=20
[  216.217518] GPR16: 00240e68 00240e1c 00240e20 017857b0 0178656c c038a8b4=
 c038a87c c03acb00=20
[  216.218889] GPR24: effd01f8 effd0000 effe9080 effd2000 6b6b6b6b edd22a34=
 effe9070 edd22a38=20
[  216.222013] NIP [c0040188] run_workqueue+0x78/0x15c
[  216.223016] LR [c00401e8] run_workqueue+0xd8/0x15c
[  216.223993] Call Trace:
[  216.224855] [effd3f50] [c00401e8] run_workqueue+0xd8/0x15c (unreliable)
[  216.225959] [effd3f90] [c0040658] worker_thread+0xa0/0x124
[  216.227014] [effd3fd0] [c00449f0] kthread+0x48/0x84
[  216.228039] [effd3ff0] [c0011944] kernel_thread+0x44/0x60
[  216.229113] Instruction dump:
[  216.230067] 3d20c03b 7c591378 543b0024 3aaba8b4 3ae9cb00 3b0201f8 3bbfff=
fc 7fc3f378=20
[  216.231480] 839d000c 93be0030 817f0004 813f0000 <912b0000> 91690004 93ff=
0000 93ff0004=20
[  216.233560] note: events/0[5] exited with preempt_count 1
[  216.234717] BUG: sleeping function called from invalid context at kernel=
/sched.c:4550
[  216.235844] in_atomic():1, irqs_disabled():0
[  216.236889] Call Trace:
[  216.237859] [effd3c90] [c0008a48] show_stack+0x4c/0x1ac (unreliable)
[  216.239129] [effd3cd0] [c0028228] __might_sleep+0xd0/0xf0
[  216.240341] [effd3ce0] [c0029078] __cond_resched+0x24/0x60
[  216.241519] [effd3cf0] [c0029dfc] cond_resched_lock+0x60/0x70
[  216.242739] [effd3d00] [c00a3c40] prune_dcache+0x54/0x204
[  216.243925] [effd3d40] [c00a3f5c] shrink_dcache_parent+0xfc/0x13c
[  216.245176] [effd3d70] [c00cdcb8] proc_flush_task+0x60/0x1f8
[  216.246384] [effd3dc0] [c002fcc4] release_task+0x30c/0x458
[  216.247612] [effd3e00] [c0031564] do_exit+0x6c0/0x888
[  216.248838] [effd3e50] [c000f404] kernel_bad_stack+0x0/0x4c
[  216.250072] [effd3e80] [c0014904] bad_page_fault+0x90/0xd8
[  216.251291] [effd3e90] [c0010ee4] handle_page_fault+0x7c/0x80
[  216.252550] --- Exception: 300 at run_workqueue+0x78/0x15c
[  216.253740]     LR =3D run_workqueue+0xd8/0x15c
[  216.254852] [effd3f90] [c0040658] worker_thread+0xa0/0x124
[  216.256074] [effd3fd0] [c00449f0] kthread+0x48/0x84
[  216.257284] [effd3ff0] [c0011944] kernel_thread+0x44/0x60
[  217.397232] BUG: spinlock lockup on CPU#0, swapper/0, effe9070
[  217.398470] Call Trace:
[  217.399556] [c0655ca0] [c0008a48] show_stack+0x4c/0x1ac (unreliable)
[  217.400901] [c0655ce0] [c01a24f8] _raw_spin_lock+0x154/0x180
[  217.402171] [c0655d10] [c030aa3c] _spin_lock_irqsave+0x30/0x48
[  217.403430] [c0655d30] [c004087c] __queue_work+0x1c/0x50
[  217.404679] [c0655d50] [c004097c] queue_work+0x8c/0xb4
[  217.405912] [c0655d70] [c01b5240] cursor_timer_handler+0x20/0x48
[  217.407169] [c0655d90] [c00376d8] run_timer_softirq+0x188/0x1f0
[  217.408410] [c0655de0] [c0033914] __do_softirq+0x84/0xf8
[  217.409643] [c0655e00] [c0006738] do_softirq+0x58/0x5c
[  217.410855] [c0655e10] [c00335ac] irq_exit+0x60/0x80
[  217.412037] [c0655e20] [c000e330] timer_interrupt+0x260/0x5c0
[  217.413231] [c0655eb0] [c00110f0] ret_from_except+0x0/0x14
[  217.414422] --- Exception: 901 at cpu_idle+0x98/0xf8
[  217.415588]     LR =3D cpu_idle+0x98/0xf8
[  217.416653] [c0655f70] [c0009e2c] cpu_idle+0xdc/0xf8 (unreliable)
[  217.417899] [c0655f90] [c03077fc] rest_init+0x7c/0x90
[  217.419060] [c0655fb0] [c03d1a34] start_kernel+0x264/0x2e4
[  217.420218] [c0655ff0] [00003860] 0x3860


--=-tldMWYAbiNDi5PyXiKsA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1YD1/ETPhpq3jKURArZHAKCE+rTp9f6Y4EfQCltwOn5EX2agPACgiwfv
7pKUpfEgBpxCfjciDICC/1s=
=illx
-----END PGP SIGNATURE-----

--=-tldMWYAbiNDi5PyXiKsA--

