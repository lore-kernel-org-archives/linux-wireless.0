Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62124 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYKLAyX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 19:54:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 16:54:23 -0800
Date: Tue, 11 Nov 2008 16:54:20 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"compat-masters@lists.madwifi.org" <compat-masters@lists.madwifi.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<dwmw2@infradead.org>, <dcbw@redhat.com>, <linville@tuxdriver.com>,
	<tim.gardner@canonical.com>
Subject: Re: a couple of small bugs in compat-wireless -- libertas
Message-ID: <20081112005420.GQ14202@tesla> (sfid-20081112_015427_793573_3D992686)
References: <252423.50522.qm@web23105.mail.ird.yahoo.com> <20081111231233.GK14202@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081111231233.GK14202@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2008 at 03:12:33PM -0800, Luis Rodriguez wrote:
> On Mon, Nov 10, 2008 at 09:28:59PM -0800, Hin-Tak Leung wrote:
> > "make unload" doesn't unload iwlagn, and iwlagn keeps mac80211 in the kernel, which results in make unload failing. Needs to include iwlagn
> > in the unload list in script/unload.sh. Should be trivial to fix, and
> > probably quicker "just do it" then having a patch from me :-).
> >
> > There is another annoyance - probably not strictly speaking a bug, but nonetheless, for some unexplainable reasons, I expect "make clean" to do the usual thing, and it doesn't - this is probably easy to fix by having an almost empty libertas_tf/Makefile ? (this shows an older compat-wireless , but current compat-wireless also seem to have this problem
> > if I remember correctly):
> > ---------------
> > scripts/Makefile.clean:17: /tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile: No such file or directory
> > make[4]: *** No rule to make target `/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile'.  Stop.
> > make[3]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf] Error 2
> > make[2]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless] Error 2
> > make[1]: *** [_clean_/tmp/compat-wireless-2008-10-23] Error 2
> > make[1]: Leaving directory `/usr/src/kernels/2.6.27.5-92.fc10.x86_64'
> > make: *** [clean] Error 2
> > ---------------
> 
> Try this patch, but the issue you see is related to libertas... anyway,
> I've added this patch I'll try to see what's wrong with libertas.

OK for your issue you can try this patch. Essentially it adds
libertas_tf to compat-wireless but it will only compile if you
had it enabled in your kernel (which hopefully means you didn't
enable the old driver (CONFIG_LIBERTAS_USB).

Right now I don't see libertas_tf_usb driver being shipped or enabled
on FC10 or Ubuntu 8.10 so this follows the assumption that they did
the right thing, which I think they did as the thin firmware driver
is rather new.

diff --git a/Makefile b/Makefile
index 7383214..9cef559 100644
--- a/Makefile
+++ b/Makefile
@@ -113,6 +113,7 @@ install: uninstall modules
 	@$(MODPROBE) -l ieee80211
 	@$(MODPROBE) -l ieee80211_crypt
 	@$(MODPROBE) -l libertas_cs
+	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l ub8xxx
 	@$(MODPROBE) -l p54_pci
 	@$(MODPROBE) -l p54_usb
@@ -172,6 +173,7 @@ uninstall:
 	@$(MODPROBE) -l ieee80211
 	@$(MODPROBE) -l ieee80211_crypt
 	@$(MODPROBE) -l libertas_cs
+	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l mac80211
 	@$(MODPROBE) -l ub8xxx
 	@$(MODPROBE) -l p54pci
diff --git a/config.mk b/config.mk
index f2be511..68e8eec 100644
--- a/config.mk
+++ b/config.mk
@@ -230,9 +230,11 @@ CONFIG_SSB_PCICORE_HOSTMODE=n
 # CONFIG_SSB_DRIVER_EXTIF=y
 
 ifneq ($(CONFIG_USB),)
+ifneq ($(LIBERTAS_THINFIRM_USB),m)
 CONFIG_LIBERTAS_USB=m
 NEED_LIBERTAS=y
 endif
+endif
 ifneq ($(CONFIG_PCMCIA),)
 CONFIG_LIBERTAS_CS=m
 NEED_LIBERTAS=y
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 6a66fbf..dc0a6e2 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -58,6 +58,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/zd1211rw"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas"
 DRIVERS="$DRIVERS drivers/net/wireless/p54"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
+DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
