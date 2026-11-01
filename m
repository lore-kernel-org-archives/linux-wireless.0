Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.203.120.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793531830;
	b=s+w1g8hSh/kiMv3CCtj8QZivhkhaZ13ImjbJxrn0tuVoLZANqu28mmMw3tPE7NFt5g+N
	 1Dn/brXHu+F+mTvSB3RbHjBAP0o0dLXS/WGAvmL/moWA+ythSqU4KyVuJM+N76OUH8VtR
	 2vSG3mN5aHMVdwgVboCRhk8FWSlK1MtIO6BsmEP9yNU0NdRHHNxxudM2J8yxJcSkDyYUu
	 wUe2OwtKzmD/i2eLyO/rLPTh11+ThQGhUi08vf7zxIsm+qJR5QkTMs98ahwze9q2Y+LfN
	 L4WoOxY1W8YxhsAf9UURemBBuIug0LcZNPUCbMNm0l67kBVJQe+qnPeL50gIDWjjoFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793531830;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type;
	bh=TMrZkLW/GUaOnTSrgGZ443NIKNcySYmGHLxG0eVmY7I=;
	b=jNI3ymIzgvwwNwGRi40uGTN7Zhc58sOkRBiIajWkD54UffNFo/iIOrJV4wWTqEbQ51VB
	 vdBRActBshTdrLOkKhFl9yGwuf6v6B19+f0bYQpYXDxnF8cQZgn3F2m56KlHb9GgLZxOO
	 18+taahAPf5mtGOl/L0JVJ/lOo4qMMYqXIBZq1RsTaX1nC0b5jy2EyZGv0TszTLb9MlWx
	 A41U2guxyF6pa3raTBVk4jTeZ3JguvEcZSuI9f0SMof4behzAcw7hK9lMCt2ndUYMy9Xk
	 6X16F2kYblDZIyjYkTOQ9uz4d+uON9CEtqMbQK222QsBIUxAKJkWnCS/J/ciouxXq2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bues.ch;
	spf=pass smtp.mailfrom=bues.ch;
	dkim=pass header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=ALrRmhAv;
	arc=none smtp.remote-ip=116.203.120.240
Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB02606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 11:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DB02606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=ALrRmhAv
Date: Sun, 1 Nov 2026 12:13:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1793531820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=TMrZkLW/GUaOnTSrgGZ443NIKNcySYmGHLxG0eVmY7I=;
	b=ALrRmhAvn++z403K1JFGBrIOlHtzUX6Jwalr54Qrtl0laOl9PPVIAy6s1WUqd9keKaFfZD
	rQU05Xo5kdW3NJhwkek2Y+bUWHVXMIkTKq9GjxU84aGF1mjoV9HASuHpuvhlrq30mHY+FR
	GStX2O4XfNRHH44RWJ4WQwWzLd0gdtGI88i9OuIEmzuI+JZKPFLe9vpXdY460VrZgddJNW
	w9EvARQ6nf0wg6a/OVDZAYQofNBQFxjfxVZ/t61Us7Tvw3Se98vndVeWHVnAUyPu54uskP
	1sh3TI9w0ZbBPfF5s0754og+6eQR5npewuep7YjMyP+83wlgaUzrwJz8bHSeYA==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH] wireless: Remove me as ssb maintainer
Message-ID: <20261101121325.7c334d78@barney>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+DJY44kmpjMYbJdYx5j4o3q";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/+DJY44kmpjMYbJdYx5j4o3q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

and remove all my E-Mail address references from the wireless sources.

Signed-off-by: Michael B=C3=BCsch <m@bues.ch>
---

Since many people+AI have picked up the work on b43/ssb recently the traffic
to my inbox and the maintenance work has significantly increased.

I cannot really do the maintenance these days, just because I don't really
have any working hardware. It has become impossible for me to properly revi=
ew,
test and take responsibility of the huge amount of changes made to this
legacy code base.

Therefore, I am stepping down and I ask some of the people currently
doing the large amount of changes to take over maintenance and responsibili=
ty
for b43, b43legacy and ssb.



 MAINTAINERS                                       | 3 +--
 drivers/bcma/driver_chipcommon.c                  | 2 +-
 drivers/bcma/driver_chipcommon_pmu.c              | 2 +-
 drivers/bcma/driver_pci.c                         | 2 +-
 drivers/bcma/driver_pci_host.c                    | 2 +-
 drivers/firmware/broadcom/bcm47xx_sprom.c         | 2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c       | 2 +-
 drivers/net/wireless/broadcom/b43/dma.c           | 2 +-
 drivers/net/wireless/broadcom/b43/leds.c          | 2 +-
 drivers/net/wireless/broadcom/b43/lo.c            | 2 +-
 drivers/net/wireless/broadcom/b43/main.c          | 2 +-
 drivers/net/wireless/broadcom/b43/main.h          | 2 +-
 drivers/net/wireless/broadcom/b43/phy_common.c    | 2 +-
 drivers/net/wireless/broadcom/b43/phy_g.c         | 2 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c        | 2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c         | 2 +-
 drivers/net/wireless/broadcom/b43/pio.c           | 2 +-
 drivers/net/wireless/broadcom/b43/radio_2055.c    | 2 +-
 drivers/net/wireless/broadcom/b43/rfkill.c        | 2 +-
 drivers/net/wireless/broadcom/b43/sdio.c          | 2 +-
 drivers/net/wireless/broadcom/b43/sysfs.c         | 2 +-
 drivers/net/wireless/broadcom/b43/tables.c        | 2 +-
 drivers/net/wireless/broadcom/b43/tables_lpphy.c  | 2 +-
 drivers/net/wireless/broadcom/b43/tables_nphy.c   | 2 +-
 drivers/net/wireless/broadcom/b43/wa.c            | 2 +-
 drivers/net/wireless/broadcom/b43/xmit.c          | 2 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c     | 2 +-
 drivers/net/wireless/broadcom/b43legacy/ilt.c     | 2 +-
 drivers/net/wireless/broadcom/b43legacy/leds.c    | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c    | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.h    | 2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c     | 2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.h     | 2 +-
 drivers/net/wireless/broadcom/b43legacy/pio.c     | 2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c   | 2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.h   | 2 +-
 drivers/net/wireless/broadcom/b43legacy/rfkill.c  | 2 +-
 drivers/net/wireless/broadcom/b43legacy/sysfs.c   | 2 +-
 drivers/net/wireless/broadcom/b43legacy/xmit.c    | 2 +-
 drivers/ssb/b43_pci_bridge.c                      | 2 +-
 drivers/ssb/bridge_pcmcia_80211.c                 | 2 +-
 drivers/ssb/driver_chipcommon.c                   | 2 +-
 drivers/ssb/driver_chipcommon_pmu.c               | 2 +-
 drivers/ssb/driver_extif.c                        | 2 +-
 drivers/ssb/driver_gige.c                         | 2 +-
 drivers/ssb/driver_mipscore.c                     | 2 +-
 drivers/ssb/driver_pcicore.c                      | 2 +-
 drivers/ssb/embedded.c                            | 2 +-
 drivers/ssb/host_soc.c                            | 2 +-
 drivers/ssb/main.c                                | 2 +-
 drivers/ssb/pci.c                                 | 2 +-
 drivers/ssb/pcihost_wrapper.c                     | 2 +-
 drivers/ssb/pcmcia.c                              | 2 +-
 drivers/ssb/scan.c                                | 2 +-
 drivers/ssb/sdio.c                                | 2 +-
 drivers/ssb/sprom.c                               | 2 +-
 drivers/usb/host/bcma-hcd.c                       | 2 +-
 drivers/usb/host/ssb-hcd.c                        | 2 +-
 include/linux/ssb/ssb_driver_chipcommon.h         | 2 +-
 include/uapi/linux/nl80211.h                      | 2 +-
 61 files changed, 61 insertions(+), 62 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..60d4537de508 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26055,9 +26055,8 @@ S:	Maintained
 F:	drivers/net/ethernet/natsemi/sonic.*
=20
 SONICS SILICON BACKPLANE DRIVER (SSB)
-M:	Michael Buesch <m@bues.ch>
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/ssb/
 F:	include/linux/ssb/
=20
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcom=
mon.c
index fd91a39f02c7..ca268dfcb1e4 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -3,7 +3,7 @@
  * ChipCommon core driver
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chi=
pcommon_pmu.c
index 263ef6fa1d0f..d29950e06b0a 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -2,7 +2,7 @@
  * Broadcom specific AMBA
  * ChipCommon Power Management Unit driver
  *
- * Copyright 2009, Michael Buesch <m@bues.ch>
+ * Copyright 2009, Michael Buesch
  * Copyright 2007, 2011, Broadcom Corporation
  * Copyright 2011, 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 12b2cc9a3fbe..30291954c02f 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -3,7 +3,7 @@
  * PCI Core
  *
  * Copyright 2005, 2011, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  * Copyright 2011, 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index f121be2ed813..4a1c3c6af20c 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -3,7 +3,7 @@
  * PCI Core in hostmode
  *
  * Copyright 2005 - 2011, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  * Copyright 2011, 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware/b=
roadcom/bcm47xx_sprom.c
index bca03fd85808..9e856d89d56d 100644
--- a/drivers/firmware/broadcom/bcm47xx_sprom.c
+++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
@@ -1,7 +1,7 @@
 /*
  *  Copyright (C) 2004 Florian Schirmer <jolt@tuxbox.org>
  *  Copyright (C) 2006 Felix Fietkau <nbd@openwrt.org>
- *  Copyright (C) 2006 Michael Buesch <m@bues.ch>
+ *  Copyright (C) 2006 Michael Buesch
  *  Copyright (C) 2010 Waldemar Brodkorb <wbx@openadk.org>
  *  Copyright (C) 2010-2012 Hauke Mehrtens <hauke@hauke-m.de>
  *
diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wire=
less/broadcom/b43/debugfs.c
index 173ef5db90fc..c6d4a290418a 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -5,7 +5,7 @@
=20
   debugfs driver debugging code
=20
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless=
/broadcom/b43/dma.c
index 05da6987a845..be62144c524d 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -5,7 +5,7 @@
=20
   DMA ringbuffer and descriptor allocation/management
=20
-  Copyright (c) 2005, 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005, 2006 Michael Buesch
=20
   Some code in this file is derived from the b44.c driver
   Copyright (C) 2002 David S. Miller
diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireles=
s/broadcom/b43/leds.c
index bfe1be345844..0e6447c33ee8 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -6,7 +6,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/lo.c b/drivers/net/wireless/=
broadcom/b43/lo.c
index f86e8969673f..020d5af0ebdf 100644
--- a/drivers/net/wireless/broadcom/b43/lo.c
+++ b/drivers/net/wireless/broadcom/b43/lo.c
@@ -7,7 +7,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005, 2006 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
   Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireles=
s/broadcom/b43/main.c
index 3825b6ad9f4f..e4f76e638a89 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
   Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2009 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2009 Michael Buesch
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (c) 2010-2011 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
diff --git a/drivers/net/wireless/broadcom/b43/main.h b/drivers/net/wireles=
s/broadcom/b43/main.h
index d94ab86e8495..d59ec5a7579b 100644
--- a/drivers/net/wireless/broadcom/b43/main.h
+++ b/drivers/net/wireless/broadcom/b43/main.h
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
                      Stefano Brivio <stefano.brivio@polimi.it>
-                     Michael Buesch <m@bues.ch>
+                     Michael Buesch
                      Danny van Dyk <kugelfang@gentoo.org>
                      Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/w=
ireless/broadcom/b43/phy_common.c
index 285490f6f0a1..e132b9bbcbec 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -6,7 +6,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2008 Michael Buesch
   Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/phy_g.c b/drivers/net/wirele=
ss/broadcom/b43/phy_g.c
index 9e292a349674..3af50a755cf7 100644
--- a/drivers/net/wireless/broadcom/b43/phy_g.c
+++ b/drivers/net/wireless/broadcom/b43/phy_g.c
@@ -6,7 +6,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2008 Michael Buesch
   Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wirel=
ess/broadcom/b43/phy_lp.c
index 8e0058072242..e7b5731bc642 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11a/g LP-PHY driver
=20
-  Copyright (c) 2008-2009 Michael Buesch <m@bues.ch>
+  Copyright (c) 2008-2009 Michael Buesch
   Copyright (c) 2009 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
=20
=20
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wirele=
ss/broadcom/b43/phy_n.c
index 22359bd9db47..50389fdaeeaf 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11n PHY support
=20
-  Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2008 Michael Buesch
   Copyright (c) 2010-2011 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
=20
=20
diff --git a/drivers/net/wireless/broadcom/b43/pio.c b/drivers/net/wireless=
/broadcom/b43/pio.c
index 8358b1d5c298..08dba9f3d5fd 100644
--- a/drivers/net/wireless/broadcom/b43/pio.c
+++ b/drivers/net/wireless/broadcom/b43/pio.c
@@ -5,7 +5,7 @@
=20
   PIO data transfer
=20
-  Copyright (c) 2005-2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2008 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43/radio_2055.c b/drivers/net/w=
ireless/broadcom/b43/radio_2055.c
index be841f891900..7f3ca19a123f 100644
--- a/drivers/net/wireless/broadcom/b43/radio_2055.c
+++ b/drivers/net/wireless/broadcom/b43/radio_2055.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11n PHY and radio device data tables
=20
-  Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2008 Michael Buesch
   Copyright (c) 2010 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
=20
=20
diff --git a/drivers/net/wireless/broadcom/b43/rfkill.c b/drivers/net/wirel=
ess/broadcom/b43/rfkill.c
index f0c968703613..bf6391b5d10e 100644
--- a/drivers/net/wireless/broadcom/b43/rfkill.c
+++ b/drivers/net/wireless/broadcom/b43/rfkill.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   RFKILL support
=20
-  Copyright (c) 2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2007 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43/sdio.c b/drivers/net/wireles=
s/broadcom/b43/sdio.c
index dda8d894aebe..35cf31e7d5b6 100644
--- a/drivers/net/wireless/broadcom/b43/sdio.c
+++ b/drivers/net/wireless/broadcom/b43/sdio.c
@@ -5,7 +5,7 @@
  * SDIO over Sonics Silicon Backplane bus glue for b43.
  *
  * Copyright (C) 2009 Albert Herranz
- * Copyright (C) 2009 Michael Buesch <m@bues.ch>
+ * Copyright (C) 2009 Michael Buesch
  */
=20
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/broadcom/b43/sysfs.c b/drivers/net/wirele=
ss/broadcom/b43/sysfs.c
index 261b2b746a9c..c8bd1bce7791 100644
--- a/drivers/net/wireless/broadcom/b43/sysfs.c
+++ b/drivers/net/wireless/broadcom/b43/sysfs.c
@@ -5,7 +5,7 @@
=20
   SYSFS support routines
=20
-  Copyright (c) 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2006 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43/tables.c b/drivers/net/wirel=
ess/broadcom/b43/tables.c
index 25c891e2cbfa..9b2bfa30f082 100644
--- a/drivers/net/wireless/broadcom/b43/tables.c
+++ b/drivers/net/wireless/broadcom/b43/tables.c
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2006, 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2006, 2006 Michael Buesch
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43/tables_lpphy.c b/drivers/net=
/wireless/broadcom/b43/tables_lpphy.c
index fb70a1e3544b..2bd3dfaa47f6 100644
--- a/drivers/net/wireless/broadcom/b43/tables_lpphy.c
+++ b/drivers/net/wireless/broadcom/b43/tables_lpphy.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11a/g LP-PHY and radio device data tables
=20
-  Copyright (c) 2009 Michael Buesch <m@bues.ch>
+  Copyright (c) 2009 Michael Buesch
   Copyright (c) 2009 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
=20
=20
diff --git a/drivers/net/wireless/broadcom/b43/tables_nphy.c b/drivers/net/=
wireless/broadcom/b43/tables_nphy.c
index ecd660b9c75a..6b48943d950a 100644
--- a/drivers/net/wireless/broadcom/b43/tables_nphy.c
+++ b/drivers/net/wireless/broadcom/b43/tables_nphy.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11n PHY data tables
=20
-  Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2008 Michael Buesch
   Copyright (c) 2010 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
=20
=20
diff --git a/drivers/net/wireless/broadcom/b43/wa.c b/drivers/net/wireless/=
broadcom/b43/wa.c
index f9209b863e35..222d88c45a17 100644
--- a/drivers/net/wireless/broadcom/b43/wa.c
+++ b/drivers/net/wireless/broadcom/b43/wa.c
@@ -6,7 +6,7 @@
   PHY workarounds.
=20
   Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireles=
s/broadcom/b43/xmit.c
index f0b082596637..4f9e1ebd55b7 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -7,7 +7,7 @@
=20
   Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
   Copyright (C) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (C) 2005, 2006 Michael Buesch <m@bues.ch>
+  Copyright (C) 2005, 2006 Michael Buesch
   Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/ne=
t/wireless/broadcom/b43legacy/debugfs.c
index 7ce8bcf12f0a..1e44e04a0105 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -5,7 +5,7 @@
=20
   debugfs driver debugging code
=20
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wi=
reless/broadcom/b43legacy/dma.c
index 6c3d847242bb..0659af58e7c1 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -5,7 +5,7 @@
=20
   DMA ringbuffer and descriptor allocation/management
=20
-  Copyright (c) 2005, 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005, 2006 Michael Buesch
=20
   Some code in this file is derived from the b44.c driver
   Copyright (C) 2002 David S. Miller
diff --git a/drivers/net/wireless/broadcom/b43legacy/ilt.c b/drivers/net/wi=
reless/broadcom/b43legacy/ilt.c
index f62d6886a003..78bc0e78c575 100644
--- a/drivers/net/wireless/broadcom/b43legacy/ilt.c
+++ b/drivers/net/wireless/broadcom/b43legacy/ilt.c
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
 		     Stefano Brivio <stefano.brivio@polimi.it>
-		     Michael Buesch <m@bues.ch>
+		     Michael Buesch
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43legacy/leds.c b/drivers/net/w=
ireless/broadcom/b43legacy/leds.c
index 79e6fd205bfb..43c75472d06f 100644
--- a/drivers/net/wireless/broadcom/b43legacy/leds.c
+++ b/drivers/net/wireless/broadcom/b43legacy/leds.c
@@ -6,7 +6,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005-2007 Michael Buesch
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/w=
ireless/broadcom/b43legacy/main.c
index dfff3710dea3..a960b49b2943 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -5,7 +5,7 @@
  *
  *  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
  *  Copyright (c) 2005-2008 Stefano Brivio <stefano.brivio@polimi.it>
- *  Copyright (c) 2005, 2006 Michael Buesch <m@bues.ch>
+ *  Copyright (c) 2005, 2006 Michael Buesch
  *  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
  *  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
  *  Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.h b/drivers/net/w=
ireless/broadcom/b43legacy/main.h
index 85edbc8c121a..420683ecbd10 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.h
+++ b/drivers/net/wireless/broadcom/b43legacy/main.h
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
   Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005, 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005, 2006 Michael Buesch
   Copyright (c) 2005  Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005  Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (c) 2007  Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.c b/drivers/net/wi=
reless/broadcom/b43legacy/phy.c
index c1395e622759..5be36c9ba414 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
 		     Stefano Brivio <stefano.brivio@polimi.it>
-		     Michael Buesch <m@bues.ch>
+		     Michael Buesch
 		     Danny van Dyk <kugelfang@gentoo.org>
      Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.h b/drivers/net/wi=
reless/broadcom/b43legacy/phy.h
index bb2c492dab36..b45d731429b0 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.h
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.h
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
 		     Stefano Brivio <stefano.brivio@polimi.it>
-		     Michael Buesch <m@bues.ch>
+		     Michael Buesch
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/net/wireless/broadcom/b43legacy/pio.c b/drivers/net/wi=
reless/broadcom/b43legacy/pio.c
index 0274fe47ca7e..d1e271c4ef71 100644
--- a/drivers/net/wireless/broadcom/b43legacy/pio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/pio.c
@@ -5,7 +5,7 @@
=20
   PIO Transmission
=20
-  Copyright (c) 2005 Michael Buesch <m@bues.ch>
+  Copyright (c) 2005 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43legacy/radio.c b/drivers/net/=
wireless/broadcom/b43legacy/radio.c
index 8d7eb89c1628..d46a42a05a66 100644
--- a/drivers/net/wireless/broadcom/b43legacy/radio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/radio.c
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
 		     Stefano Brivio <stefano.brivio@polimi.it>
-		     Michael Buesch <m@bues.ch>
+		     Michael Buesch
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/net/wireless/broadcom/b43legacy/radio.h b/drivers/net/=
wireless/broadcom/b43legacy/radio.h
index ee8b2c8d1602..d833690d17b8 100644
--- a/drivers/net/wireless/broadcom/b43legacy/radio.h
+++ b/drivers/net/wireless/broadcom/b43legacy/radio.h
@@ -5,7 +5,7 @@
=20
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
 		     Stefano Brivio <stefano.brivio@polimi.it>
-		     Michael Buesch <m@bues.ch>
+		     Michael Buesch
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
=20
diff --git a/drivers/net/wireless/broadcom/b43legacy/rfkill.c b/drivers/net=
/wireless/broadcom/b43legacy/rfkill.c
index 1f532105052e..b8e3f2734cd7 100644
--- a/drivers/net/wireless/broadcom/b43legacy/rfkill.c
+++ b/drivers/net/wireless/broadcom/b43legacy/rfkill.c
@@ -4,7 +4,7 @@
   Broadcom B43 wireless driver
   RFKILL support
=20
-  Copyright (c) 2007 Michael Buesch <m@bues.ch>
+  Copyright (c) 2007 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43legacy/sysfs.c b/drivers/net/=
wireless/broadcom/b43legacy/sysfs.c
index d988fe541bf7..a29df7481191 100644
--- a/drivers/net/wireless/broadcom/b43legacy/sysfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/sysfs.c
@@ -5,7 +5,7 @@
=20
   SYSFS support routines
=20
-  Copyright (c) 2006 Michael Buesch <m@bues.ch>
+  Copyright (c) 2006 Michael Buesch
=20
=20
 */
diff --git a/drivers/net/wireless/broadcom/b43legacy/xmit.c b/drivers/net/w=
ireless/broadcom/b43legacy/xmit.c
index ee199d4eaf03..c97b8be744c6 100644
--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -7,7 +7,7 @@
=20
   Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
   Copyright (C) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (C) 2005, 2006 Michael Buesch <m@bues.ch>
+  Copyright (C) 2005, 2006 Michael Buesch
   Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
   Copyright (C) 2007 Larry Finger <Larry.Finger@lwfinger.net>
diff --git a/drivers/ssb/b43_pci_bridge.c b/drivers/ssb/b43_pci_bridge.c
index 9c7316b5685f..5bd56b78c561 100644
--- a/drivers/ssb/b43_pci_bridge.c
+++ b/drivers/ssb/b43_pci_bridge.c
@@ -5,7 +5,7 @@
  * because of its small size we include it in the SSB core
  * instead of creating a standalone module.
  *
- * Copyright 2007  Michael Buesch <m@bues.ch>
+ * Copyright 2007  Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/bridge_pcmcia_80211.c b/drivers/ssb/bridge_pcmcia_=
80211.c
index 689ff069ff37..60898ba1e0c2 100644
--- a/drivers/ssb/bridge_pcmcia_80211.c
+++ b/drivers/ssb/bridge_pcmcia_80211.c
@@ -1,7 +1,7 @@
 /*
  * Broadcom 43xx PCMCIA-SSB bridge module
  *
- * Copyright (c) 2007 Michael Buesch <m@bues.ch>
+ * Copyright (c) 2007 Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommo=
n.c
index a8d2525e7af9..f51ee760e1fa 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -3,7 +3,7 @@
  * Broadcom ChipCommon core driver
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipc=
ommon_pmu.c
index 888069e10659..c93141bf93e3 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -2,7 +2,7 @@
  * Sonics Silicon Backplane
  * Broadcom ChipCommon Power Management Unit driver
  *
- * Copyright 2009, Michael Buesch <m@bues.ch>
+ * Copyright 2009, Michael Buesch
  * Copyright 2007, Broadcom Corporation
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/ssb/driver_extif.c b/drivers/ssb/driver_extif.c
index bc275968fcc6..7fe777938e88 100644
--- a/drivers/ssb/driver_extif.c
+++ b/drivers/ssb/driver_extif.c
@@ -3,7 +3,7 @@
  * Broadcom EXTIF core driver
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  * Copyright 2006, 2007, Felix Fietkau <nbd@openwrt.org>
  * Copyright 2007, Aurelien Jarno <aurelien@aurel32.net>
  *
diff --git a/drivers/ssb/driver_gige.c b/drivers/ssb/driver_gige.c
index 0aca0711807b..822ea364397d 100644
--- a/drivers/ssb/driver_gige.c
+++ b/drivers/ssb/driver_gige.c
@@ -3,7 +3,7 @@
  * Broadcom Gigabit Ethernet core driver
  *
  * Copyright 2008, Broadcom Corporation
- * Copyright 2008, Michael Buesch <m@bues.ch>
+ * Copyright 2008, Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 354486b7ed3a..7afd9a421f72 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -3,7 +3,7 @@
  * Broadcom MIPS core driver
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index d11b4242b6d2..8a9f930b77c3 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -3,7 +3,7 @@
  * Broadcom PCI-core driver
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/embedded.c b/drivers/ssb/embedded.c
index 8254ed25e063..2a72102d6d7a 100644
--- a/drivers/ssb/embedded.c
+++ b/drivers/ssb/embedded.c
@@ -3,7 +3,7 @@
  * Embedded systems support code
  *
  * Copyright 2005-2008, Broadcom Corporation
- * Copyright 2006-2008, Michael Buesch <m@bues.ch>
+ * Copyright 2006-2008, Michael Buesch
  * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
diff --git a/drivers/ssb/host_soc.c b/drivers/ssb/host_soc.c
index 3b438480515c..fc4a9b020267 100644
--- a/drivers/ssb/host_soc.c
+++ b/drivers/ssb/host_soc.c
@@ -3,7 +3,7 @@
  * Subsystem core
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index b2d339eb57d5..6aa3d73e185d 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -3,7 +3,7 @@
  * Subsystem core
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2006, 2007, Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 493bebbba521..d73e25b3235c 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -1,7 +1,7 @@
 /*
  * Sonics Silicon Backplane PCI-Hostbus related functions.
  *
- * Copyright (C) 2005-2006 Michael Buesch <m@bues.ch>
+ * Copyright (C) 2005-2006 Michael Buesch
  * Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
  * Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
  * Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index 5b6b5e0e4433..ae8cc9dce650 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -6,7 +6,7 @@
  * Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
  * Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
  * Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
- * Copyright (c) 2005-2007 Michael Buesch <m@bues.ch>
+ * Copyright (c) 2005-2007 Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index 45502098e0c7..e244819327d4 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -3,7 +3,7 @@
  * PCMCIA-Hostbus related functions
  *
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2007-2008 Michael Buesch <m@bues.ch>
+ * Copyright 2007-2008 Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 4161e5d1f276..8c0ec41e5f61 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -2,7 +2,7 @@
  * Sonics Silicon Backplane
  * Bus scanning
  *
- * Copyright (C) 2005-2007 Michael Buesch <m@bues.ch>
+ * Copyright (C) 2005-2007 Michael Buesch
  * Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
  * Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
  * Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
index 66c5c2169704..8b6745edc704 100644
--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -6,7 +6,7 @@
  *
  * Based on drivers/ssb/pcmcia.c
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2007-2008 Michael Buesch <m@bues.ch>
+ * Copyright 2007-2008 Michael Buesch
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  *
diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 7cd553127861..fe961766e5a9 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -2,7 +2,7 @@
  * Sonics Silicon Backplane
  * Common SPROM support routines
  *
- * Copyright (C) 2005-2008 Michael Buesch <m@bues.ch>
+ * Copyright (C) 2005-2008 Michael Buesch
  * Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
  * Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
  * Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 519386255886..2b25fbc9e480 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -7,7 +7,7 @@
  * Copyright 2015 Felix Fietkau <nbd@openwrt.org>
  *
  * Based on ssb-ohci driver
- * Copyright 2007 Michael Buesch <m@bues.ch>
+ * Copyright 2007 Michael Buesch
  *
  * Derived from the OHCI-PCI driver
  * Copyright 1999 Roman Weissgaerber
diff --git a/drivers/usb/host/ssb-hcd.c b/drivers/usb/host/ssb-hcd.c
index 016987764afb..dc174c01f480 100644
--- a/drivers/usb/host/ssb-hcd.c
+++ b/drivers/usb/host/ssb-hcd.c
@@ -6,7 +6,7 @@
  * Copyright 2011-2012 Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Based on ssb-ohci driver
- * Copyright 2007 Michael Buesch <m@bues.ch>
+ * Copyright 2007 Michael Buesch
  *
  * Derived from the OHCI-PCI driver
  * Copyright 1999 Roman Weissgaerber
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/=
ssb_driver_chipcommon.h
index c44335b011be..17345729eb73 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -9,7 +9,7 @@
  * gpio interface, extbus, and support for serial and parallel flashes.
  *
  * Copyright 2005, Broadcom Corporation
- * Copyright 2006, Michael Buesch <m@bues.ch>
+ * Copyright 2006, Michael Buesch
  */
=20
 /** ChipCommon core registers. **/
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..dae8fb894a79 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -6,7 +6,7 @@
  * Copyright 2006-2010 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
- * Copyright 2008 Michael Buesch <m@bues.ch>
+ * Copyright 2008 Michael Buesch
  * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
  * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
  * Copyright 2008 Colin McCabe <colin@cozybit.com>
--=20
2.55.0



--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/+DJY44kmpjMYbJdYx5j4o3q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmrnHtUACgkQ9TK+HZCN
iw4TyA//TMUO4RAxGmI1eQs4b7F+Y3H/KnwQu4wCSOoFCuDzDKUjh+X5+BUsBtVJ
CtQ2rPwky6sEjDsKyXnJEu7tzaq9wiGtgY6BNY6vwRjJFO/IFO0b7xOqK1ugYj/D
3yR159Jn1q2qTvZgXTNEtD8UXM6yzn8YxozIEJ8BfikGJt1x9X8ckRzIymMw/H/O
OeL6n/Gtn3hqsFuyiW1azo8EMFIDrozIq3zwCyrGKh6/9g/dAXH/xFSKJI/X+6SU
+t5rYfnokDD8uW5xGw+UIo0sgC3NveqKE+h7Cjo26ThP03SWn7auq274t+J11BZu
ew4oEjIDD4Asv3/AZw9CbenrisvMdMQuDIGhdMPC3hZWJlLOTcDzBji8knojxidA
gPVaOn6jUXpRHqEhOXtyzWDq7GzJT6cc7aH4i5bZ/klPrPqAsNJHp4AS70RT75EZ
0+7QTroipFENHM8g2Nh6OJ4MYSfGS9o8regVCSrKDcg1jjqOmzsoOocNY9JYfcrO
HrbqxwIc5l9M9q6lNjmv6hAGAkXwASsCBhvIzkdg0S1kuS/oAZ0R90/OvFcUMhak
RVkKNH6egiLduI6POv4eEVsOe9UgW2dG1s0l66375PK/qq3bygowmljZtNX6nDoC
2VyleCwbJIN7RJ3lOV8v2LXTBWAtewaxKrBeFWmSM89MGJwyx+w=
=xK3x
-----END PGP SIGNATURE-----

--Sig_/+DJY44kmpjMYbJdYx5j4o3q--
