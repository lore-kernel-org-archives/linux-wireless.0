Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pbsg500.nifty.com ([202.248.238.70]:54888 "EHLO
	pbsg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1BOFm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 00:42:57 -0500
Received: from [127.0.0.1] (himob3-p146.iem.hi-ho.ne.jp [203.180.26.146]) (authenticated)
	by pbsg500.nifty.com with ESMTP id p1F5giLN032628
	for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 14:42:46 +0900
Date: Tue, 15 Feb 2011 14:42:14 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report(atlx)
Message-Id: <20110215144213.9ED6.2E210E2F@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-02-14.
My kernel is 2.6.27. 

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx/atl1.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx/atl1.c:2842: warning: useless storage class specifier in empty declaration
/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx/atl1.c:2842: warning: empty declaration
/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx/atl1.c:3104: error: 'atl1_pm_ops' undeclared here (not in a function)
make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx/atl1.o] Error 1
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net/atlx] Error 2
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14/drivers/net] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-02-14] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-67vl5-x86_64'
make: *** [modules] Error 2


The patch was made.

--- atl1.c.orig 2011-02-15 14:31:11.000000000 +0900
+++ atl1.c      2011-02-15 14:28:45.000000000 +0900
@@ -2839,6 +2839,9 @@
        return 0;
 }

+compat_pci_suspend(atl1_suspend)
+compat_pci_resume(atl1_resume)
+
 static SIMPLE_DEV_PM_OPS(atl1_pm_ops, atl1_suspend, atl1_resume);
 #define ATL1_PM_OPS    (&atl1_pm_ops)

@@ -3101,7 +3104,12 @@
        .probe = atl1_probe,
        .remove = __devexit_p(atl1_remove),
        .shutdown = atl1_shutdown,
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
        .driver.pm = ATL1_PM_OPS,
+#elif defined(CONFIG_PM_SLEEP)
+       .suspend        = atl1_suspend_compat,
+       .resume         = atl1_resume_compat,
+#endif
 };

 /*


