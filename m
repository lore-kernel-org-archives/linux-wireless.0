Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36865 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751814AbYCBXmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 18:42:33 -0500
Message-ID: <47CB3B5E.4020701@gmx.at> (sfid-20080302_234250_620354_B59BDB8D)
Date: Mon, 03 Mar 2008 00:42:22 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 2 compile errors: rt2x00firmware.c and mesh.c
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

after downloading the latest
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2=
=2E6.tar.bz2
today (2.3.2008) I got these errors during make:

   CC [M]
=2E../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.o
=2E../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.c:=
116:
=46ehler: Redefinition von =BBrt2x00lib_load_firmware=AB
=3D Error: redefiniton of  =BBrt2x00lib_load_firmware=AB
=2E../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00lib.h:129:
=46ehler: Vorherige Definition von =BBrt2x00lib_load_firmware=AB war hi=
er
=3D Error: previous definition of  =BBrt2x00lib_load_firmware=AB was he=
re
=2E../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.c:=
138:
=46ehler: Redefinition von =BBrt2x00lib_free_firmware=AB
=2E../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00lib.h:133:
=46ehler: Vorherige Definition von =BBrt2x00lib_free_firmware=AB war hi=
er
make[4]: ***
[.../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.o]
=46ehler 1

My environment (Ubuntu gutsy):
kernel: 2.6.22-14-generic #1 SMP Tue Feb 12 07:42:25 UTC 2008 i686 GNU/=
Linux
cc: gcc-Version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
wlan card: MSI PC54G2 ... RaLink rt2500 chip


When I tried to "export CONFIG_CRC_ITU_T=3Dy" before "make",=20
rt2x00firmware.c compiled fine. (Probably this is not a good idea. I=20
just wanted to see, if it compiles then.)

-----------------
=2E.. but a bit later I got this error:

   CC [M]  .../compat-wireless-2.6/net/mac80211/mesh.o
=2E../compat-wireless-2.6/net/mac80211/mesh.c: In Funktion =BBieee80211=
s_init=AB:
=2E../compat-wireless-2.6/net/mac80211/mesh.c:28:
=46ehler: Zu wenige Argumente f=FCr Funktion =BBkmem_cache_create=AB
=3D Error: Not enough arguments for function =BBkmem_cache_create=AB

In /usr/src/linux-headers-2.6.22-14/include/linux/slab.h I found:
    struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
		unsigned long,
		void (*)(void *, struct kmem_cache *, unsigned long),
		void (*)(void *, struct kmem_cache *, unsigned long));
i.e. the old, 6-parameter version.

So, IMHO the #define kmem_cache_create in
- compat-wireless-2.6/include/net/compat.h, line 120 and
- compat-wireless-2.6/compat/compat.h, line 120
should be moved 2 lines downwards into the block named
/* Compat work for 2.6.22 and 2.6.23 */
Then it compiles fine.

Best regards,
=46ranz
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
