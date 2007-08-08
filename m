Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:39431 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296AbXHHXNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:13:18 -0400
Message-ID: <46BA4E24.3060400@aurel32.net>
Date: Thu, 09 Aug 2007 01:13:40 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif config
References: <200708071744.40287.mb@bu3sch.de> <20070808154813.abf55801.akpm@linux-foundation.org>
In-Reply-To: <20070808154813.abf55801.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton a =E9crit :
> mips allmodconfig:
>=20
> drivers/ssb/driver_pcicore.c: In function `ssb_fixup_pcibridge':
> drivers/ssb/driver_pcicore.c:98: error: implicit declaration of funct=
ion `pcibios_enable_device'
> drivers/ssb/driver_pcicore.c: At top level:
> drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expres=
sion
> drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expres=
sion

Those looks like real errors.

> drivers/ssb/driver_extif.c:125: error: redefinition of 'extif_read32'
> drivers/ssb/driver_extif.c:21: error: previous definition of 'extif_r=
ead32' was here
> drivers/ssb/driver_extif.c:130: error: redefinition of 'extif_write32=
'
> drivers/ssb/driver_extif.c:26: error: previous definition of 'extif_w=
rite32' was here
> drivers/ssb/driver_extif.c:136: error: redefinition of 'serial_exists=
'
> drivers/ssb/driver_extif.c:32: error: previous definition of 'serial_=
exists' was here
> drivers/ssb/driver_extif.c:150: error: redefinition of 'ssb_extif_ser=
ial_init'
> drivers/ssb/driver_extif.c:46: error: previous definition of 'ssb_ext=
if_serial_init' was here
> drivers/ssb/driver_extif.c:181: error: redefinition of 'ssb_extif_tim=
ing_init'
> drivers/ssb/driver_extif.c:77: error: previous definition of 'ssb_ext=
if_timing_init' was here
> drivers/ssb/driver_extif.c:203: error: redefinition of 'ssb_extif_get=
_clockcontrol'
> drivers/ssb/driver_extif.c:99: error: previous definition of 'ssb_ext=
if_get_clockcontrol' was here
>=20

All the versions of driver_extif.c I have seen have at maximum around
100 lines. It looks like a patch applied twice, which make the same cod=
e
appearing twice in the .c file.

--=20
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
