Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826Ab1EWWa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 18:30:58 -0400
Message-Id: <201105232230.p4NMUiQk016228@imap1.linux-foundation.org> (sfid-20110524_003101_626863_B4255D83)
Subject: [patch 1/1] drivers/bcma/host_pci.c needs slab.h
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	zajec5@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 23 May 2011 15:30:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/bcma/host_pci.c: In function 'bcma_host_pci_probe':
drivers/bcma/host_pci.c:102: error: implicit declaration of function 'kzalloc'  drivers/bcma/host_pci.c:102: warning: assignment makes pointer from integer without a cast

Cc: <zajec5@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bcma/host_pci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bcma/host_pci.c~drivers-bcma-host_pcic-needs-slabh drivers/bcma/host_pci.c
--- a/drivers/bcma/host_pci.c~drivers-bcma-host_pcic-needs-slabh
+++ a/drivers/bcma/host_pci.c
@@ -6,6 +6,7 @@
  */
 
 #include "bcma_private.h"
+#include <linux/slab.h>
 #include <linux/bcma/bcma.h>
 #include <linux/pci.h>
 
_
