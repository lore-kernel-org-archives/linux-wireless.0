Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1185533E36A;
	Thu, 16 Jul 2026 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784198187; cv=none; b=XA+KBk580809VklKqBue5GLpOyHHNTRqmn8hrKl4d1hvocgMNM+XU/9dRPjeavCArN+ll0iK8SLo8WFOG7TPGpxshff3TNRYDS8HUD+6/vC1rqd7XRyhBCYfPf+aled/eyTKgTTBK7cRah6r3fRseBI3yIgh7wpkgImD7CltiPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784198187; c=relaxed/simple;
	bh=yIuC1tZDmtbBmWwCctT3tF6ITJQ0FaMMuPuA6Vb5L3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/+sXFo5RHrAKFIzkCcWDyNmi/jmaign+8bpB12hdjtjyEYrbX0K5u4jXLNy6R+1Db/V/y9Clyuzibb+lePhxR6+2BAiDHnJrRi9ai6eUzWHhyuGqGPwp0PS0IT/72UYGBljWeelbylFl5XS5hvnTWMGJaZZAPCfr2Y3ibvA4qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=invisiblethingslab.com; spf=pass smtp.mailfrom=invisiblethingslab.com; dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b=Awx1/z0v; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=P3/gDy93; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="Awx1/z0v";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P3/gDy93"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 489A9EC0019;
	Thu, 16 Jul 2026 06:36:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 16 Jul 2026 06:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1784198185;
	 x=1784284585; bh=Bq5SiXQdvGgLoHu7EgLWV7/NQXQqbTWRtJAzXu8VVqY=; b=
	Awx1/z0vURkAFSUxyST+EKEoGRJuAfeOP0QtwThhNkF4Kc52KKiOELuoRvWWN00e
	q5P2ZNqva2ltslhc1Xpkpi0lRUmTm6NFtsBuKANMe1jjJM1ciu8/N2RPvn9J14Qc
	FBpIB0zS29kzMDAXcPIdzQNPI/JKRUaoU13+iJGow7iLM76AAWYodPF5yzO2sqiE
	TVXuRLdUHsImW+2UMbx/bcIj9DXvzLnVXej87y+3L4WgRVS4tjDm6JMSpO0MoweJ
	d1dFXoKHJ6N3gQqhW5DW+kaRM0j0LJPg0CP99YbRStxHaQPI1se/JowHo0R5jbm5
	ub9HCZiHNW/EaACG+ac/vA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784198185; x=1784284585; bh=Bq5SiXQdvGgLoHu7EgLWV7/NQXQqbTWRtJA
	zXu8VVqY=; b=P3/gDy93hWChDmJVGBRgEnUy1euFzrh+XFCep7KduOLOvd426QX
	EfmSHQOwG5RSFXJm6eaHRwwAo0c3Y+nxA2mztfIkZSPzOtp+zTzPFVjQwuTkRXG8
	892fur8cW8Fyf0luMP1dEN99XXsjzRAfOMagsxQIPDqap0598xmW1P2c+JzQixdb
	9ixSMbd1Ys03ZWnXJcgZXwkjeAKaD1DqYDw0kceLUp11PaMgoldw513WYuEoj6XI
	goHfrgrW6vm0oqiN+/SVtGcrETTU0uTBPiirigpkq6Gkhvknz6dPqm1c+YawxJjN
	Nu5+c5VjQX8WJsnjtInrWZw9e+NJXWG3Zvg==
X-ME-Sender: <xms:KbRYanFR6Td0W7B16svz-3YnVpaCNqsQFH0s0l6ogsqTD98eB0nSbQ>
    <xme:KbRYasG2eWi8yCjr9pimNTWEebsn4c0edkOfzeSvcvu5ADyNEYGtJ2_pACT4xqPF_
    u6WmKGqBxKEn55k_Ojot5tIf2YyqeCJPDOqg_0eM3-WR7H5xg>
X-ME-Received: <xmr:KbRYasOxURjp21v_jvfv4u3RbvsuE5JF6SYP9uPeR-MZlVnN25fFryTTWfBmv4I84cpuLZbAMVYux4eWPpim7PSp0uj0XdqjXWI>
X-ME-Proxy-Cause: dmFkZTFaTqSn0Mah82Euv/8C4ni3Bi7FEOMfDEWfFsEmEJETMuGbCupIDfBLIcf4l9cP4j
    UBFPX3BOGBSowajV+LSF0BQdoh1+QGOf9rSKKyziscPW5Hcj8FQaXOXFPnFIwBZbju+e0I
    82/1QpypZBDZHc3rJDF86frPXEaxytTjvZ/NTAdcl8fkblJic/mpfrhye9zC8L8dfbBWan
    9aXkzLkqb0R2leME0Kj7p85ry3x84aUc1dsNdFE+eEYoaaR9i6xW5hM96gZiPlKTmgLHOj
    3w1Ep7F7XUrM5FpzABN+kJFEuj1zwGszszMJ2ofaMHROT4HXHtNGTJMylkjTtR6EzzHirQ
    G35hs0zhq4A0JvccHFG3FrA6hHt284xXhnK2+K9T1ECFSbwhgS4J2d26tm+CTDJajVhLl/
    gNxWECJwgeyTVe78SszfcKFkwlR1BO+aAoxHeMyp4EFC1lADakayru90c9o4DTDFnTYHMt
    XYNKhTqBSBa3h3k5rmv6H/U7BT+miY5J6lARUX2n0XrBI49CpkNJkel61vqXR/8iSfsJxu
    uzRw1fIEhSzaYl8dLAvW7CU1FpAVvHHcNP7BraI+rJMFE+6i+D8sSjohZqeqb3Z9n4LNmk
    qnFJvuojqsflIuPsnMgDKYeKu8s/JpyjQ6/daV6ufMpFj4x14t6CKlAsshKQ
X-ME-Proxy: <xmx:KbRYajFj08RaRudJCh2dPuakEOEapaZI7nYAqLKC6hF1nO8OrSoD3w>
    <xmx:KbRYarNLHhYKJAGK8icylV8JqiS6v3-YIaZtW4NzauGhPgIKmfJO9A>
    <xmx:KbRYas_NGwmfjiuhLWRkj0mhJvk8AlZQAt7cRb6wkbxcNyPb84WLrg>
    <xmx:KbRYavSofIYG2K7DQXz8k57Ye33l7xoxpnA_rbI2a_dOWfTO00oW_g>
    <xmx:KbRYahivsxTQQPfoooR0UPwUK0l37KzWHBK42ATGh9JvXGXImKGhrLXw>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Jul 2026 06:36:24 -0400 (EDT)
Date: Thu, 16 Jul 2026 12:36:22 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:634 (kfree) when unbinding device from
 iwlwifi
Message-ID: <ali0JisW1DsSwP7S@mail-itl>
References: <aleaCWlvrmiUcLhT@mail-itl>
 <DS0PR11MB788064B1ADCB2A98542F75A1A3F82@DS0PR11MB7880.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tYuQD5Q7E+T9GpsU"
Content-Disposition: inline
In-Reply-To: <DS0PR11MB788064B1ADCB2A98542F75A1A3F82@DS0PR11MB7880.namprd11.prod.outlook.com>

--tYuQD5Q7E+T9GpsU
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 12:36:22 +0200
From: Marek =?utf-8?B?PT91dGYtOD9RP01hcmN6eWtvd3NraS1HPUMzPUIzcmVja2k/PQ==?= <marmarek@invisiblethingslab.com>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:634 (kfree) when unbinding device from
 iwlwifi

On Wed, Jul 15, 2026 at 05:22:44PM +0000, Korenblit, Miriam Rachel wrote:
>=20
>=20
> > -----Original Message-----
> > From: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
> > Sent: Wednesday, July 15, 2026 5:33 PM
> > To: Korenblit, Miriam Rachel <miriam.rachel.korenblit@intel.com>
> > Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: kernel BUG at mm/slub.c:634 (kfree) when unbinding device from=
 iwlwifi
> >=20
> > Hello,
> >=20
> > I get a kernel panic when unbinding device (8086:0085) from the iwlwifi=
 driver
> > (via writing to the "unbind" file in sysfs), while the wifi connection =
is active. I can
> > reproduce it on Thinkpad X230, but other devices might be affected too.=
 The
> > specific crash is:
> >=20
> >     [  286.908182] kernel BUG at mm/slub.c:634!
> >     [  286.908201] Oops: invalid opcode: 0000 [#1] SMP PTI
> >     [  286.908221] CPU: 1 UID: 0 PID: 1959 Comm: prepare-suspend Not ta=
inted
> > 6.18.15-1.qubes.fc41.x86_64 #1 PREEMPT(full)
> >     [  286.908255] Hardware name: Xen HVM domU, BIOS 4.19.4 03/17/2026
> >     [  286.908275] RIP: 0010:kfree+0x3a8/0x470
> >     [  286.908292] Code: 5d 41 5e 41 5f 5d e9 67 bb ff ff 4d 89 f1 41 b=
8 01 00 00 00
> > 48 89 d9 48 89 da 4c 89 ee 4c 89 e7 e8 ad 2c 00 00 e9 bd fd ff ff <0f> =
0b 89 c8 4c
> > 8d 04 03 40 f6 c6 80 0f 84 41 ff ff ff 83 e6 08 0f
> >     [  286.908347] RSP: 0018:ffffcfce8280bb50 EFLAGS: 00010246
> >     [  286.908365] RAX: ffff8b2dcef2c800 RBX: ffff8b2dcef2c800 RCX:
> > ffff8b2dcef2c830
> >     [  286.908389] RDX: 00000000000be001 RSI: 0000000000000000 RDI:
> > ffff8b2dcef2c880
> >     [  286.908414] RBP: ffffcfce8280bba0 R08: ffff8b2dcef2c860 R09:
> > 0000000000000000
> >     [  286.908438] R10: ffff8b2dcef2c860 R11: 0000000000000000 R12:
> > ffff8b2dd2841600
> >     [  286.908462] R13: fffff077003bcb00 R14: ffffffffc093c480 R15:
> > 0000000000000060
> >     [  286.908487] FS:  00007b10286cd740(0000) GS:ffff8b2e19c6c000(0000)
> > knlGS:0000000000000000
> >     [  286.908511] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     [  286.908532] CR2: 00007fb93027bc70 CR3: 00000000034f0005 CR4:
> > 00000000001706f0
> >     [  286.908559] Call Trace:
> >     [  286.908570]  <TASK>
> >     [  286.908581]  ? _raw_spin_unlock_bh+0xe/0x20
> >     [  286.908599]  iwl_pcie_txq_free+0x130/0x170 [iwlwifi]
> >     [  286.908644]  iwl_pcie_tx_free+0x66/0xe0 [iwlwifi]
> >     [  286.908681]  iwl_trans_pcie_free+0x1df/0x250 [iwlwifi]
> >     [  286.908719]  pci_device_remove+0x42/0xb0
> >     [  286.908736]  device_release_driver_internal+0x19c/0x200
> >     [  286.908755]  unbind_store+0xa1/0xb0
> >     [  286.908771]  kernfs_fop_write_iter+0x150/0x200
> >     [  286.908790]  vfs_write+0x25d/0x450
> >     [  286.908806]  ksys_write+0x6b/0xe0
> >     [  286.908825]  do_syscall_64+0x84/0x800
> >     [  286.908842]  ? syscall_exit_work+0x108/0x140
> >     [  286.908861]  ? do_syscall_64+0xbb/0x800
> >     [  286.908876]  ? ksys_dup3+0x63/0xf0
> >     [  286.908892]  ? syscall_exit_work+0x108/0x140
> >     [  286.911388]  ? do_syscall_64+0xbb/0x800
> >     [  286.911408]  ? do_sys_openat2+0xa4/0xe0
> >     [  286.911423]  ? syscall_exit_work+0x108/0x140
> >     [  286.911443]  ? do_syscall_64+0xbb/0x800
> >     [  286.911458]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >     [  286.911477] RIP: 0033:0x7b102873ec5e
> >     [  286.911493] Code: 4d 89 d8 e8 34 bd 00 00 4c 8b 5d f8 41 8b 93 0=
8 03 00 00
> > 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c=
9> c3 83 e2
> > 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
> >     [  286.911549] RSP: 002b:00007ffd94bc3100 EFLAGS: 00000202 ORIG_RAX:
> > 0000000000000001
> >     [  286.911575] RAX: ffffffffffffffda RBX: 00007b10288ba5c0 RCX:
> > 00007b102873ec5e
> >     [  286.911600] RDX: 000000000000000d RSI: 00006385db4f8020 RDI:
> > 0000000000000001
> >     [  286.911625] RBP: 00007ffd94bc3110 R08: 0000000000000000 R09:
> > 0000000000000000
> >     [  286.911650] R10: 0000000000000000 R11: 0000000000000202 R12:
> > 000000000000000d
> >     [  286.911674] R13: 000000000000000d R14: 00006385db4f8020 R15:
> > 00006385db4f5b30
> >     [  286.911701]  </TASK>
> >     [  286.911711] Modules linked in: iwldvm iwlwifi mac80211 ehci_pci =
ehci_hcd
> > nft_nat nft_flow_offload nf_flow_table_inet nf_flow_table qrtr
> > nf_conntrack_netlink nft_reject_ipv6 nf_reject_ipv6 nft_reject_ipv4
> > nf_reject_ipv4 nft_reject nft_ct nft_masq nft_chain_nat nf_nat nf_connt=
rack
> > nf_defrag_ipv6 nf_defrag_ipv4 nf_tables joydev libarc4 intel_rapl_msr
> > intel_rapl_common polyval_clmulni ghash_clmulni_intel cfg80211 e1000e
> > ata_generic rfkill i2c_piix4 pata_acpi i2c_smbus pcspkr floppy vfat fat=
 serio_raw
> > xen_scsiback target_core_mod xen_netback xen_privcmd xen_gntdev
> > xen_gntalloc xen_blkback xen_evtchn i2c_dev fuse loop nfnetlink overlay
> > xen_blkfront [last unloaded: iwlwifi]
> >     [  286.911967] ---[ end trace 0000000000000000 ]---
> >=20
> > This is running in a VM (HVM) under Xen, with relevant PCI device attac=
hed, but I
> > don't think it's relevant for this bug.
> >=20
> > I've got reports about the issue in Linux 6.18.15 initially (after upda=
ting from
> > 6.12), but later tests identified it's a regression somewhere between 6=
=2E15.11 and
> > 6.16.8.
>=20
> Hi, could you please test the attached patch?=20
> It is based on 6.18

Yes, the patch fixes it!

Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--tYuQD5Q7E+T9GpsU
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmpYtCYACgkQ24/THMrX
1ywRRgf/TNU6P6KRBtgqbVqCvDeaShogJJ9JpetMFVEXHgcS2L3u/VSHG8K7UzPJ
gBxD/Giu1CNnuAHsOkhCCT2Kqlxouy/VJ6FyTnbOOaFBgOI0B13y/CJRW7MoS8ZY
4UfNU09ecIGmt0jUFRhXXs24fz2vcdOCK0tEBnBgqn886PKID9iOevJ2N229QeKb
IY73AGF45YXej3IVRB9wfGqUo7jSmaNp2/8NrP3jY0/GEV4zW3LgSNugaqY3BtTh
2qv/eQMvzQtzfXTIvo2FqajSOYOvwI/wsXGunbPqiPPKeDlL5dl7JyED2JNg9dh3
JGeu780gdXmHj0bq3kYjNgVhMUrRkA==
=hMAL
-----END PGP SIGNATURE-----

--tYuQD5Q7E+T9GpsU--
