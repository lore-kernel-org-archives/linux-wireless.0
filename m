Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390AbXIGNY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:24:57 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gdQ8tQxgiYO/1uIYxk7m"
Date: Fri, 07 Sep 2007 02:45:44 +0200
Message-Id: <1189125944.28781.125.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gdQ8tQxgiYO/1uIYxk7m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 23:25 -0400, Rob Hussey wrote:

> > ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 18
> > phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003,
> > rev: 00000004
> > WARNING: at lib/kref.c:33 kref_get()
> > [<c0229da9>] kref_get+0x3d/0x44
>                             kobject_get
>                             kobject_shadow
>                             kobject_set_name
>                             device_add
>                             wiphy_register

Ok, this comes from
	WARN_ON(!atomic_read(&kref->refcount));
which means that somehow the refcount is zero.

> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 00000024

> EIP is at sysfs_addrm_start+0x21/0x87

> Call Trace:
> create_dir
> sysfs_create_dir
> kobject_get
> kobject_shadow_add
> kobject_set_name
> device_add
> wiphy_register

I wish x86 had proper backtraces. What are kobject_get and
kobject_set_name doing in there??? Can't people get proper machines?
powerpc has really nice backtraces... Anyhow, that appears to be sysfs
trying to access kobj->parent which appears to be NULL.

I have no idea what's going on here. Can you enable DEBUG_KOBJECT? Oh
also, what kernel is this with?

johannes

--=-gdQ8tQxgiYO/1uIYxk7m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4J84/ETPhpq3jKURAlLgAKCRzVekr4uhziR8lJYirQPBHjU66ACgkvuZ
LpxHABUCPhPfkJ5Y0DjJzkY=
=qvAq
-----END PGP SIGNATURE-----

--=-gdQ8tQxgiYO/1uIYxk7m--

