Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:28944 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0BCXdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 18:33:50 -0500
Date: Wed, 3 Feb 2010 15:31:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	akpm <akpm@linux-foundation.org>, Dan Williams <dcbw@redhat.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] libertas/if_spi: needs linux/semaphore.h
Message-Id: <20100203153107.28184ef0.randy.dunlap@oracle.com>
In-Reply-To: <20100203172625.c9340392.sfr@canb.auug.org.au>
References: <20100203172625.c9340392.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

libertas/if_spi.c needs to #include linux/semaphore.h to fix build errors:

drivers/net/wireless/libertas/if_spi.c:59: error: field 'spi_ready' has incomplete type
drivers/net/wireless/libertas/if_spi.c:60: error: field 'spi_thread_terminated' has incomplete type
drivers/net/wireless/libertas/if_spi.c:785: error: implicit declaration of function 'down_interruptible'
drivers/net/wireless/libertas/if_spi.c:787: error: implicit declaration of function 'up'
drivers/net/wireless/libertas/if_spi.c:834: error: implicit declaration of function 'down'
drivers/net/wireless/libertas/if_spi.c:943: error: implicit declaration of function 'sema_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/libertas/if_spi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100203.orig/drivers/net/wireless/libertas/if_spi.c
+++ linux-next-20100203/drivers/net/wireless/libertas/if_spi.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/semaphore.h>
 #include <linux/spi/libertas_spi.h>
 #include <linux/spi/spi.h>
 
