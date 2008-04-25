Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:55529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbYDYLmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 07:42:43 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3571775fgb.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 04:42:42 -0700 (PDT)
Message-ID: <544ab8580804250442n466d33e8qf72b652bf11d737e@mail.gmail.com> (sfid-20080425_134317_577958_46C3C635)
Date: Fri, 25 Apr 2008 13:42:39 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: remove some more unneccessary code
Cc: lcostantino@gmail.com, linux-wireless@vger.kernel.org,
	someone@dunanet.hu
In-Reply-To: <20080425111556.GJ14903@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080419202952.GA26630@elf.ucw.cz>
	 <544ab8580804200956v43dfabf8p511f46eb2940093e@mail.gmail.com>
	 <20080425111556.GJ14903@elf.ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux/wb35reg.c, at line 566. I attached a little patch, generated
with svn di. It makes the stuff compilable again out-of-tree too. I
would also recommend merging the linux/ subdir into the base and
destroying the 0 byte files and os_common.h.
My card outputs "16", which is Airoha AL2230
(http://www.airoha.com.tw/AL2230.htm).

KK

---
Index: linux/sysdef.h
===================================================================
--- linux/sysdef.h      (revision 27)
+++ linux/sysdef.h      (working copy)
@@ -49,7 +49,6 @@
 #include "../scan_s.h"
 #include "../mds_s.h"
 #include "../mlme_s.h"
-#include "../roam_s.h"
 #include "../bssdscpt.h"
 #include "../sme_api.h"
 #include "../gl_80211.h"
@@ -58,9 +57,6 @@
 #include "../wbhal_s.h"
 #include "teststa.h"

-
-#include "../wpa/wb_wpa.h" // 20060802
-
 #include "../adapter.h"

 #include "../mlme_mib.h"
@@ -71,7 +67,6 @@
 #include "../mds_f.h"
 #include "../bss_f.h"
 #include "../mlmetxrx_f.h"
-#include "../roam_f.h"
 #include "../mto_f.h"
 #include "../wbhal_f.h"
 #include "../wblinux_f.h"
Index: linux/wb35reg.c
===================================================================
--- linux/wb35reg.c     (revision 27)
+++ linux/wb35reg.c     (working copy)
@@ -562,6 +562,10 @@
        // 16V AL2230, 17 - AL7230, 18 - AL2230S
        // 32 Reserved
        // 33 - W89RF242(TxVGA 0~19), 34 - W89RF242(TxVGA 0~34)
+
+       //See above for type
+       printk("RF chip is %i\n", pWb35Reg->EEPROMPhyType);
+
        if (pWb35Reg->EEPROMPhyType != RF_DECIDE_BY_INF) {
                if( (pWb35Reg->EEPROMPhyType == RF_MAXIM_2825)  ||
                        (pWb35Reg->EEPROMPhyType == RF_MAXIM_2827)      ||
Index: linux/Makefile
===================================================================
--- linux/Makefile      (revision 27)
+++ linux/Makefile      (working copy)
@@ -11,17 +11,13 @@

        KERNELDIR := /lib/modules/$(shell uname -r)/build
        PWD := $(shell pwd)
-       WPA_DIR=../wpa

 obj-m := w35und.o

-w35und-objs := new_wireless.o wbusb.o wb35reg.o wb35rx.o wb35tx.o\
+w35und-objs := wbusb.o wb35reg.o wb35rx.o wb35tx.o\
        ../bssdbase.o ../ds_tkip.o ../knl.o ../mds.o ../mlme_assoc.o
../mlme_auth.o ../mlmetask.o ../mlmetxrx.o \
-       ../mto.o ../phy_calibration.o ../reg.o ../roamtask.o
../rxisr.o ../scan_probe.o ../scantask.o \
-       ../sme_api.o ../smetask.o ../wbhal.o ../wblinux.o \
-       $(WPA_DIR)/eap.o $(WPA_DIR)/4Way.o $(WPA_DIR)/Adapter_Bridge.o
$(WPA_DIR)/STLFunction.o \
-       $(WPA_DIR)/passphrase.o $(WPA_DIR)/prf.o $(WPA_DIR)/rc4.o
$(WPA_DIR)/sha1.o $(WPA_DIR)/hmac_sha1.o \
-       $(WPA_DIR)/hmac_md5.o $(WPA_DIR)/md5.o $(WPA_DIR)/aes.o
$(WPA_DIR)/aes_wrap.o
+       ../mto.o ../phy_calibration.o ../reg.o ../rxisr.o ../scan_probe.o \
+       ../sme_api.o ../wbhal.o ../wblinux.o

 all:
        $(MAKE) -C $(KERNELDIR) M=$(PWD) modules
@@ -30,5 +26,4 @@
        cp w35und.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless/
 clean:
        rm -f *.o *~ .*.cmd *.ko *.mod.c ../*.o ../*~ ../.*.cmd
../*.ko ../*.mod.c
-       rm -f $(WPA_DIR)/*.o $(WPA_DIR)/*~ $(WPA_DIR)/.*.cmd $(WPA_DIR)/*.mod.c
        rm -rf Module*.symvers .tmp_versions
