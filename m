Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41191 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYENXDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:03:20 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] hostap: fix "registers" registration in procfs
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 14 May 2008 19:03:18 -0400
Message-ID: <20080514230318.2740.17511.stgit@dv.roinet.com> (sfid-20080515_010324_879061_A5FE1421)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mathieu Chouquet-Stringer <mchouque@free.fr>

The "registers" entry was incorrectly created in the procfs root instead
of the device specific directory.  Move "registers" registration
immediately after the containing procfs directory is created.

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_hw.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 7be68db..cdf90c4 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
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
 
@@ -3307,6 +3302,10 @@ static int hostap_hw_ready(struct net_device *dev)
 			netif_carrier_off(local->ddev);
 		}
 		hostap_init_proc(local);
+#ifndef PRISM2_NO_PROCFS_DEBUG
+		create_proc_read_entry("registers", 0, local->proc,
+				       prism2_registers_proc_read, local);
+#endif /* PRISM2_NO_PROCFS_DEBUG */
 		hostap_init_ap_proc(local);
 		return 0;
 	}
