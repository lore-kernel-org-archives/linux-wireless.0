Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:33345 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaDSM5D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 08:57:03 -0400
Message-ID: <53526F53.3090009@maya.org> (sfid-20140419_145742_902049_C5A88D67)
Date: Sat, 19 Apr 2014 14:42:59 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Michael Hirsch <hirsch@teufel.de>, linux-wireless@vger.kernel.org
Subject: Re: Connection drop while running iperf on ARM based platform
References: <534CFC45.90101@teufel.de>
In-Reply-To: <534CFC45.90101@teufel.de>
Content-Type: multipart/mixed;
 boundary="------------090607090002030409020507"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090607090002030409020507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Michael Hirsch wrote:
> Hi all,
> 
> I have an issue using a with RT5572 chipset (TP-Link N600) on a Armada
> based embedded system.

The actual rt2800usb module unfortunately is broken (and nobody seems to
be working on them any more.) They are considered to be ready :-) [1].

Xose Vazquez Perez wrote in [1]: "because the goal already was reached".
Well, if the goal was to kick out the far better working vendor drivers
- it is really reached. But it was obviously never the goal to achieve
the same (or even better) quality.

Besides that, rt2800usb isn't considered for chips other than rt2x00 [2].


Therefore:
Don't use it. Try rt5572sta (DPO_RT5572_LinuxSTA_2.6.1.3_20121022) from
mediatek.com. You may add these patches:


For 64bit (most probably not needed for arm):
http://thread.gmane.org/gmane.linux.network/313147


for EAP-TLS:
http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/1249/focus=1474
Apply it with
patch -R -p1 --dry-run <1474-001.bin


If your kernel uses CONFIG_UIDGID_STRICT_TYPE_CHECKS:
http://article.gmane.org/gmane.linux.drivers.rt2x00.user/2450
(With kernel 3.14, you have to modify the patch, because 3.14 removed
CONFIG_UIDGID_STRICT_TYPE_CHECKS).


Maybe you have to add the usb device id to
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/common/rtusb_dev_id.c


> Running the same wifi module on a x86 Laptop with 3.14 kernel works better.

Anyway, most probably not good at all. That's at least my finding for
rt3572 and rt3573, which both work _much_ better and completely stable
with high throughput even w/ bad radio conditions as sta with the vendor
driver.

> There is also drops to 0 at running iperf, but it seems to be able to
> recover. Also on a x86 laptops is see the TX Status timeout messages (if
> it's enabled in the kernel config). I followed the discussion a bit
> about those messages and can't say whether these messages have anything
> todo with shown issue (no packets received)
> 
> Any suggestion where I could start searching? For me it looks like a
> rate-control issue, but that's speculation.

Additionally, USB handling compared to vendor driver is suboptimal.
rt2800usb needs far to much system resources to "work".


Regards,
Andreas


[1]
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=2441
[2] http://permalink.gmane.org/gmane.linux.drivers.rt2x00.user/2468


--------------090607090002030409020507
Content-Type: text/x-patch;
 name="rt5572sta_kuid_t.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rt5572sta_kuid_t.diff"

--- os/linux/rt_linux.c.orig	2012-10-22 05:52:59.000000000 +0200
+++ os/linux/rt_linux.c	2013-12-28 19:13:28.677118438 +0100
@@ -34,6 +34,10 @@
 #include "rt_os_util.h"
 #include <linux/rtnetlink.h>
 
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+#include <linux/uidgid.h>
+#endif
+
 #if defined(CONFIG_RA_HW_NAT) || defined(CONFIG_RA_HW_NAT_MODULE)
 #include "../../../../../../net/nat/hw_nat/ra_nat.h"
 #include "../../../../../../net/nat/hw_nat/frame_engine.h"
@@ -1138,9 +1142,15 @@
 		pOSFSInfo->fsgid = current->fsgid;
 		current->fsuid = current->fsgid = 0;
 #else
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+		struct user_namespace *to = current_user_ns();
+		pOSFSInfo->fsuid = from_kuid_munged(to, current_fsuid());
+		pOSFSInfo->fsgid = from_kgid_munged(to, current_fsgid());
+#else
 		pOSFSInfo->fsuid = current_fsuid();
 		pOSFSInfo->fsgid = current_fsgid();
 #endif
+#endif
 		pOSFSInfo->fs = get_fs();
 		set_fs(KERNEL_DS);
 	} else {




--------------090607090002030409020507--
