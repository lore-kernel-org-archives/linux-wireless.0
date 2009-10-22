Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49169 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:20:16 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 09/28] mwl8k: use cond_resched() when loading firmware blocks
Message-ID: <20091022182016.GK1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since each firmware block takes on the order of several hundred usec
to upload to the hardware, using msleep in the inner loop would make
the firmware loading process take a lot more time than just doing
busy-waiting like we do now.  But if we keep the busy-waiting, we can
at least add a cond_resched() to the inner loop so that we give other
tasks a chance to run while the firmware is being loaded.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index fcf7139..496d3c5 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/pci.h>
@@ -428,6 +429,7 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 			break;
 		}
 
+		cond_resched();
 		udelay(1);
 	} while (--loops);
 
-- 
1.5.6.4
