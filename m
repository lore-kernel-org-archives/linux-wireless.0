Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbYENXbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:31:00 -0400
Message-Id: <200805142330.m4ENUb2F027287@imap1.linux-foundation.org> (sfid-20080515_013104_494980_58D858C5)
Subject: [patch for 2.6.26? 1/1] hostap: procfs fix for hostap_fw.c
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	mchouque@free.fr, jkmaline@cc.hut.fi
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:30:37 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mathieu Chouquet-Stringer <mchouque@free.fr>

I've been toying with hostap_pci and found a bug that is triggered when you
unload/reload the module.

If you don't have PRISM2_NO_PROCFS_DEBUG defined (which is the default, as per
hostap_config.h), the driver creates a "registers" file in /proc used to dump
PRISM registers (function prism2_init_local_data):

#ifndef PRISM2_NO_PROCFS_DEBUG
        create_proc_read_entry("registers", 0, local->proc,
                               prism2_registers_proc_read, local);
#endif /* PRISM2_NO_PROCFS_DEBUG */

Note that create_proc_read_entry is being called with local->proc which isn't
defined at the time: "registers" ends up being created as /proc/registers.

When hostap_pci is done initializing the hardware, it calls hostap_hw_ready
which in turns creates all the files in /proc through hostap_init_proc
(hostap_proc.c):

        local->proc = NULL;

        if (hostap_proc == NULL) {
                printk(KERN_WARNING "%s: hostap proc directory not created\n",
                       local->dev->name);
                return;
        }

        local->proc = proc_mkdir(local->ddev->name, hostap_proc);

So far so good, well sort of...  When you unload the module,
prism2_free_local_data does this:

#ifndef PRISM2_NO_PROCFS_DEBUG
        if (local->proc != NULL)
                remove_proc_entry("registers", local->proc);
#endif /* PRISM2_NO_PROCFS_DEBUG */
        hostap_remove_proc(local);

Problem is local->proc has now been overwritten by hostap_init_proc meaning
"registers" isn't removed.  When you reload the module you get an error
telling you "registers" already exists (and you then get duplicate "registers"
files in /proc).

So in a nutshell "registers" should be created after calling hostap_init_proc
(this way it'll be created where it belongs - /proc/net/hostap/%s) making it
removable at module unload.

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: Jouni Malinen <jkmaline@cc.hut.fi>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_hw.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_hw.c~hostap-procfs-fix-for-hostap_fwc drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~hostap-procfs-fix-for-hostap_fwc
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -3276,11 +3276,6 @@ while (0)
 	}
 	printk(KERN_INFO "%s: Registered netdevice %s\n", dev_info, dev->name);
 
-#ifndef PRISM2_NO_PROCFS_DEBUG
-	create_proc_read_entry("registers", 0, local->proc,
-			       prism2_registers_proc_read, local);
-#endif /* PRISM2_NO_PROCFS_DEBUG */
-
 	hostap_init_data(local);
 	return dev;
 
@@ -3307,6 +3302,10 @@ static int hostap_hw_ready(struct net_de
 			netif_carrier_off(local->ddev);
 		}
 		hostap_init_proc(local);
+#ifndef PRISM2_NO_PROCFS_DEBUG
+		create_proc_read_entry("registers", 0, local->proc,
+				prism2_registers_proc_read, local);
+#endif /* PRISM2_NO_PROCFS_DEBUG */
 		hostap_init_ap_proc(local);
 		return 0;
 	}
_
