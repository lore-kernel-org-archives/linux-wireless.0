Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46742 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZDYOcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:32:35 -0400
Date: Sat, 25 Apr 2009 10:31:45 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 3/8] Integrate drivers/staging/vt6655 into build system.
Message-ID: <20090425143145.GC11201@storm.local.network> (sfid-20090425_163241_490251_AEDD0AB4)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Integrate drivers/staging/vt6655 into build system.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/Kconfig         |    2 +
 drivers/staging/Makefile        |    1 +
 drivers/staging/vt6655/Kconfig  |    5 +
 drivers/staging/vt6655/Makefile |  252 +++++------------------------------=
---
 4 files changed, 42 insertions(+), 218 deletions(-)
 create mode 100644 drivers/staging/vt6655/Kconfig

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 0dcf9ca..3a95633 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -115,5 +115,7 @@ source "drivers/staging/line6/Kconfig"
=20
 source "drivers/staging/serqt_usb/Kconfig"
=20
+source "drivers/staging/vt6655/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 47dfd5b..2a56a60 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -40,3 +40,4 @@ obj-$(CONFIG_PLAN9AUTH)		+=3D p9auth/
 obj-$(CONFIG_HECI)		+=3D heci/
 obj-$(CONFIG_LINE6_USB)		+=3D line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH_ESU100)	+=3D serqt_usb/
+obj-$(CONFIG_VT6655)	+=3D vt6655/
diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
new file mode 100644
index 0000000..d9bfc81
--- /dev/null
+++ b/drivers/staging/vt6655/Kconfig
@@ -0,0 +1,5 @@
+config VT6655
+   tristate "VIA Technologies VT6655 support"
+   ---help---
+   This is a vendor-written driver for VIA VT6655.
+
diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makef=
ile
index 4ba41a1..c9e0936 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,218 +1,34 @@
-#
-# Build options:
-#   PRIV_OBJ :=3D 1 for object version
-#
-=20
-IO_MAP :=3D 0
-HOSTAP :=3D 1
-PRIV_OBJ :=3D 0
-
-
-
-#KSP : =3D 0
-KSP :=3D  /lib/modules/$(shell uname -r)/build \
-#	/usr/src/linux-$(shell uname -r) \
-#	/usr/src/linux-$(shell uname -r | sed 's/-.*//') \
-#	/usr/src/kernel-headers-$(shell uname -r) \
-#	/usr/src/kernel-source-$(shell uname -r) \
-#	/usr/src/linux-$(shell uname -r | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/') \
-#	/usr/src/linux   /home/plice
-
-#test_dir =3D $(shell [ -e $(dir)/include/linux ] && echo $(dir))
-
-#KSP :=3D $(foreach dir, $(KSP), $(test_dir))
-
-=09
-KSRC :=3D $(firstword $(KSP))
-=20
-#ifeq (,$(KSRC))
-#	$(    error Linux kernel source not found)
-#endif
-
-# check kernel version
-KVER :=3D $(shell uname -r | cut -c1-3 | sed 's/2\.[56]/2\.6/')
-KERVER2=3D$(shell uname -r | cut -d. -f2)
-
-ifeq ($(KVER), 2.6)
-# 2.6 kernel
-TARGET =3D viawget.ko
-
-else
-TARGET =3D viawget.o
-
-endif
-
-INSTDIR	:=3D $(shell find /lib/modules/$(shell uname -r) -name $(TARGET) -=
printf "%h\n" | sort | head -1)
-ifeq (,$(INSTDIR))
-	ifeq (,$(KERVER2))
-		ifneq (,$(wildcard /lib/modules/$(shell uname -r)/kernel))
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/kernel/drivers/net
-		else
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/net
-		endif
-	else
-		ifneq ($(KERVER2),2)
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/kernel/drivers/net
-		else
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/net
-		endif
-	endif
-endif
-
-
-SRC =3D device_main.c card.c mac.c baseband.c wctl.c 80211mgr.c \
-      wcmd.c wmgr.c bssdb.c  wpa2.c rxtx.c dpc.c power.c datarate.c \
-      srom.c mib.c rc4.c tether.c tcrc.c ioctl.c hostap.c wpa.c key.c \
-      tkip.c michael.c wroute.c rf.c iwctl.c wpactl.c aes_ccmp.c \
-      vntwifi.c IEEE11h.c
-
-ifeq ($(IO_MAP), 1)
-  EXTRA_CFLAGS +=3D -DIO_MAP
-endif           =20
-
-ifeq ($(HOSTAP), 1)
-  EXTRA_CFLAGS +=3D -DHOSTAP
-endif
-
-ifeq ($(PRIV_OBJ), 1)
-  EXTRA_CFLAGS +=3D -DPRIVATE_OBJ
-endif=09
-
-EXTRA_CFLAGS +=3D -I$(PWD) -I$(PWD)/../include -I$(PWD)/../solomon      =
=09
-
-EXTRA_CFLAGS +=3D  -I$(PWD)/include -I$(PWD)/solomon      =09
-
-# build rule
-ifeq ($(KVER), 2.6)
-# 2.6 kernel
-
-ifndef KERNEL_CONF
-KERNEL_CONF=3D	$(KSRC)/.config
-endif
-
-include ${KERNEL_CONF}
-
-obj-m +=3D viawget.o
-
-viawget-objs :=3D	device_main.o card.o mac.o baseband.o wctl.o 80211mgr.o \
-	wcmd.o wmgr.o bssdb.o rxtx.o dpc.o power.o datarate.o srom.o \
-	mib.o rc4.o tether.o tcrc.o ioctl.o hostap.o wpa.o key.o tkip.o \
-	michael.o wroute.o rf.o iwctl.o wpactl.o wpa2.o aes_ccmp.o \
-	vntwifi.o IEEE11h.o
-
-.c.o:
-	$(CC) $(CFLAGS) -o $@ $<
-
-default:
-	make -C $(KSRC) SUBDIRS=3D$(shell pwd) modules
-
-else
-
-# 2.2/2.4 kernel
-OBJS :=3D	device_main.o card.o mac.o baseband.o wctl.o 80211mgr.o \
-	wcmd.o wmgr.o bssdb.o rxtx.o dpc.o power.o datarate.o srom.o \
-	mib.o rc4.o tether.o tcrc.o ioctl.o hostap.o wpa.o key.o tkip.o \
-	michael.o wroute.o rf.o iwctl.o wpactl.o wpa2.o aes_ccmp.o \
-	vntwifi.o IEEE11h.o
-
-VERSION_FILE :=3D $(KSRC)/include/linux/version.h
-CONFIG_FILE  :=3D $(KSRC)/include/linux/config.h
-
-
-ifeq (,$(wildcard $(VERSION_FILE)))
-  $(error Linux kernel source not configured - missing version.h)
-endif
-
-ifeq (,$(wildcard $(CONFIG_FILE)))
-  $(error Linux kernel source not configured - missing config.h)
-endif
-
-ifneq (,$(findstring egcs-2.91.66, $(shell cat /proc/version)))
-  CC :=3D kgcc gcc cc
-else
-  CC :=3D gcc cc
-endif
-
-test_cc =3D $(shell which $(cc) > /dev/null 2>&1 && echo $(cc))
-CC :=3D $(foreach cc, $(CC), $(test_cc))
-CC :=3D $(firstword $(CC))
-
-EXTRA_CFLAGS +=3D -Wall -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D_=
_NO_VERSION__ -O2 -pipe
-EXTRA_CFLAGS +=3D -I$(KSRC)/include -Wstrict-prototypes -fomit-frame-point=
er -fno-strict-aliasing
-EXTRA_CFLAGS +=3D $(shell [ -f $(KSRC)/include/linux/modversions.h ] && \
-            echo "-DMODVERSIONS -include $(KSRC)/include/linux/modversions=
=2Eh")
-           =20
-.SILENT: $(TARGET) clean           =20
-           =20
-
-# look for SMP in config.h
-SMP :=3D $(shell $(CC) $(CFLAGS) -E -dM $(CONFIG_FILE) | \
-         grep CONFIG_SMP | awk '{ print $$3 }')
-        =20
-ifneq ($(SMP),1)
-  SMP :=3D 0
-endif
-
-
-ifeq ($(SMP), 1)
-  EXTRA_CFLAGS +=3D -D__SMP__
-endif
-
-
-ifeq ($(PRIV_OBJ), 1)
-  EXTRA_CFLAGS +=3D -DPRIVATE_OBJ
-  TARGET =3D x86g_up.o
- =20
-ifeq ($(SMP), 1)
-  TARGET =3D x86g_smp.o
-endif
- =20
-endif
-
-
-# check x86_64
-SUBARCH :=3D $(shell uname -m)
-ifeq ($(SUBARCH),x86_64)
-    EXTRA_CFLAGS +=3D -mcmodel=3Dkernel -mno-red-zone
-endif
-
-
-$(TARGET): $(filter-out $(TARGET), $(SRC:.c=3D.o))
-	$(LD) -r $^ -o $@
-	echo; echo
-	echo "**************************************************"
-	echo "Build options:"
-	echo "   VERSION    $(KVER)"
-	echo -n "   SMP             "
-	if [ "$(SMP)" =3D "1" ]; \
-		then echo "Enabled"; else echo "Disabled"; fi
-
-
-
-endif # ifeq ($(KVER),2.6)
-
-
-ifeq ($(KVER), 2.6)
-install: default
-else
-install: clean $(TARGET)
-endif
-	mkdir -p $(MOD_ROOT)$(INSTDIR)
-	install -m 644 -o root $(TARGET) $(MOD_ROOT)$(INSTDIR)
-
-ifeq (,$(MOD_ROOT))
-	/sbin/depmod -a || true
-else
-	/sbin/depmod -b $(MOD_ROOT) -a || true
-endif
-
-
-uninstall:
-	rm -f $(INSTDIR)/$(TARGET)
-	/sbin/depmod -a
-
-clean:
-	rm -f $(TARGET) $(SRC:.c=3D.o) *.o *~
-	rm -f .*.o.d .*.o.cmd .*.ko.cmd *.mod.c *.mod.o
-
--include .depend.mak
+vt6655-y +=3D	device_main.o \
+	card.o \
+	mac.o \
+	baseband.o \
+	wctl.o \
+	80211mgr.o \
+	wcmd.o \
+	wmgr.o \
+	bssdb.o \
+	rxtx.o \
+	dpc.o \
+	power.o \
+	datarate.o \
+	srom.o \
+	mib.o \
+	rc4.o \
+	tether.o \
+	tcrc.o \
+	ioctl.o \
+	hostap.o \
+	wpa.o \
+	key.o \
+	tkip.o \
+	michael.o \
+	wroute.o \
+	rf.o \
+	iwctl.o \
+	wpactl.o \
+	wpa2.o \
+	aes_ccmp.o \
+	vntwifi.o \
+	IEEE11h.o
+
+obj-$(CONFIG_VT6655) +=3D	vt6655.o
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x7RRO4fQQdv5AwRAo5rAJ9zwb+79ooLVfIWJkHQT+ic2PrlZQCgpJtm
v+nkUxrnKFI8RKSrUfErvyc=
=Z8nT
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
