Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47666 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXIXSjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 14:39:02 -0400
Message-id: <2595810412809010611@pripojeni.net>
Subject: [PATCH 1/3] Net: ath5k, make its own directory
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <mcgrof@gmail.com>
Date: Mon, 24 Sep 2007 14:39:02 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, make its own directory

Changes-licensed-under: ISC
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>

---
commit 83e027e3714be11155c100a8e4ea7c0eb2a14f0a
tree 989dc0a74ddf3b54fc28a9196bd2048cb39f8529
parent 657bdad86e3a284f0195df4b78b833d21beb727f
author Jiri Slaby <ku@bellona.localdomain> Mon, 24 Sep 2007 20:23:34 +0200
committer Jiri Slaby <ku@bellona.localdomain> Mon, 24 Sep 2007 20:23:34 +0200

 drivers/net/wireless/Makefile             |    3 +--
 drivers/net/wireless/ath5k/Makefile       |    2 ++
 drivers/net/wireless/ath5k/ath5k.h        |    0 
 drivers/net/wireless/ath5k/ath5k_base.c   |    0 
 drivers/net/wireless/ath5k/ath5k_base.h   |    0 
 drivers/net/wireless/ath5k/ath5k_hw.c     |    0 
 drivers/net/wireless/ath5k/ath5k_hw.h     |    0 
 drivers/net/wireless/ath5k/ath5k_reg.h    |    0 
 drivers/net/wireless/ath5k/ath5k_regdom.c |    0 
 drivers/net/wireless/ath5k/ath5k_regdom.h |    0 
 10 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 02f8b71..638865d 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -48,5 +48,4 @@ obj-$(CONFIG_LIBERTAS)      += libertas/
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
-obj-$(CONFIG_ATH5K)	+= ath5k.o
-ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
+obj-$(CONFIG_ATH5K)	+= ath5k/
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
new file mode 100644
index 0000000..cf04c90
--- /dev/null
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -0,0 +1,2 @@
+ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
+obj-$(CONFIG_ATH5K)	+= ath5k.o
diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
similarity index 100%
rename from drivers/net/wireless/ath5k.h
rename to drivers/net/wireless/ath5k/ath5k.h
diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k/ath5k_base.c
similarity index 100%
rename from drivers/net/wireless/ath5k_base.c
rename to drivers/net/wireless/ath5k/ath5k_base.c
diff --git a/drivers/net/wireless/ath5k_base.h b/drivers/net/wireless/ath5k/ath5k_base.h
similarity index 100%
rename from drivers/net/wireless/ath5k_base.h
rename to drivers/net/wireless/ath5k/ath5k_base.h
diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k/ath5k_hw.c
similarity index 100%
rename from drivers/net/wireless/ath5k_hw.c
rename to drivers/net/wireless/ath5k/ath5k_hw.c
diff --git a/drivers/net/wireless/ath5k_hw.h b/drivers/net/wireless/ath5k/ath5k_hw.h
similarity index 100%
rename from drivers/net/wireless/ath5k_hw.h
rename to drivers/net/wireless/ath5k/ath5k_hw.h
diff --git a/drivers/net/wireless/ath5k_reg.h b/drivers/net/wireless/ath5k/ath5k_reg.h
similarity index 100%
rename from drivers/net/wireless/ath5k_reg.h
rename to drivers/net/wireless/ath5k/ath5k_reg.h
diff --git a/drivers/net/wireless/ath5k_regdom.c b/drivers/net/wireless/ath5k/ath5k_regdom.c
similarity index 100%
rename from drivers/net/wireless/ath5k_regdom.c
rename to drivers/net/wireless/ath5k/ath5k_regdom.c
diff --git a/drivers/net/wireless/ath5k_regdom.h b/drivers/net/wireless/ath5k/ath5k_regdom.h
similarity index 100%
rename from drivers/net/wireless/ath5k_regdom.h
rename to drivers/net/wireless/ath5k/ath5k_regdom.h
