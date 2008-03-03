Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:46067 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYCCDw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 22:52:28 -0500
Date: Sun, 2 Mar 2008 22:52:22 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Franz Apeltauer <franz.apeltauer@gmx.at>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Message-ID: <20080303035222.GP28995@ruslug.rutgers.edu> (sfid-20080303_035239_703459_7E344ABB)
References: <47CB3B5E.4020701@gmx.at> <1204504331.3917.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1204504331.3917.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 03, 2008 at 01:32:11AM +0100, Johannes Berg wrote:
>=20
> >    CC [M]
> > .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.=
o
> > .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.=
c:116:
> > Fehler: Redefinition von =BBrt2x00lib_load_firmware=AB
> > =3D Error: redefiniton of  =BBrt2x00lib_load_firmware=AB
> >=20
> > When I tried to "export CONFIG_CRC_ITU_T=3Dy" before "make",=20
> > rt2x00firmware.c compiled fine. (Probably this is not a good idea. =
I=20
> > just wanted to see, if it compiles then.)
>=20
> That's odd because the latest config.mk should check for CRC_ITU_T
> before... Ivo could there be a problem with rt2x00 when crc-itu-t isn=
't
> available?

=46or now I'll disable rt2x00 in compat-wireless.

> > In /usr/src/linux-headers-2.6.22-14/include/linux/slab.h I found:
> >     struct kmem_cache *kmem_cache_create(const char *, size_t, size=
_t,
> > 		unsigned long,
> > 		void (*)(void *, struct kmem_cache *, unsigned long),
> > 		void (*)(void *, struct kmem_cache *, unsigned long));
> > i.e. the old, 6-parameter version.
> >=20
> > So, IMHO the #define kmem_cache_create in
> > - compat-wireless-2.6/include/net/compat.h, line 120 and
> > - compat-wireless-2.6/compat/compat.h, line 120
> > should be moved 2 lines downwards into the block named
> > /* Compat work for 2.6.22 and 2.6.23 */
> > Then it compiles fine.
>=20
> Ok, indeed, it should be moved then, I was working on .21 when I noti=
ced
> that needed to be done.

OK -- this required a just slightly different approach to handle the
different kernel versions. Below is the approach I took. If you
apply this patch manually don't forget to

cp compat/compat.h include/net/compat.h

as this is what the autogeneration tool does.

=46orced a new tarball out with new changes applied, would appreciate
some testing on 2.6.21, 2.6.22. You can get the tarball from the
usual place:

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2=
=2E6.tar.bz2

=46or those cloning please pull latest changes in.

diff --git a/compat/compat.h b/compat/compat.h
index ec966de..4ae26ac 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -130,23 +130,36 @@ static inline void pci_clear_mwi(struct pci_dev *=
dev)
 #define list_first_entry(ptr, type, member) \
         list_entry((ptr)->next, type, member)
=20
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)) */
+
+/* Compat work for 2.6.21, 2.6.22 and 2.6.23 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
+
 /*
  * Force link bug if constructor is used, can't be done compatibly
  * because constructor arguments were swapped since then!
  */
 extern void __incompatible_kmem_cache_create(void);
=20
+/* 2.6.21 and 2.6.22 kmem_cache_create() takes 6 arguments */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
 #define kmem_cache_create(name, objsize, align, flags, ctor) 	\
 	({							\
 		if (ctor) __incompatible_kmem_cache_create();	\
 		kmem_cache_create((name), (objsize), (align),	\
 				  (flags), NULL, NULL);		\
 	})
-
 #endif
=20
-/* Compat work for 2.6.22 and 2.6.23 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
+/* 2.6.23 kmem_cache_create() takes 5 arguments */
+#if (LINUX_VERSION_CODE =3D=3D KERNEL_VERSION(2,6,23))
+#define kmem_cache_create(name, objsize, align, flags, ctor) 	\
+	({							\
+		if (ctor) __incompatible_kmem_cache_create();	\
+		kmem_cache_create((name), (objsize), (align),	\
+				  (flags), NULL);		\
+	})
+#endif
=20
 /* From include/linux/mod_devicetable.h */
=20
@@ -254,7 +267,7 @@ int compat_is_pcie(struct pci_dev *pdev);
=20
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)) */
=20
-/* Compat work for 2.6.22 */
+/* Compat work for kernels <=3D 2.6.22 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
=20
 /* dev_mc_list was replaced with dev_addr_list as of 2.6.23 */
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
