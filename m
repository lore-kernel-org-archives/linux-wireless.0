Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:42307 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1GMBhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 21:37:07 -0400
Subject: [PATCH 24/24] ath6kl: add Kconfig and Makefile
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
Date: Wed, 13 Jul 2011 04:37:02 +0300
Message-ID: <20110713013702.8517.8606.stgit@localhost6.localdomain6> (sfid-20110713_033721_471972_9CC5EE1B)
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig         |    1 +
 drivers/net/wireless/ath/Makefile        |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig  |   17 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/Makefile |   35 ++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath6kl/Makefile

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index d1b2306..0735488 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -25,5 +25,6 @@ config ATH_DEBUG
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
+source "drivers/net/wireless/ath/ath6kl/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 0e8f528..d121469 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
+obj-$(CONFIG_ATH6KL)		+= ath6kl/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
new file mode 100644
index 0000000..fc9f69c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -0,0 +1,17 @@
+config ATH6KL
+	tristate "Atheros ath6kl support"
+	depends on MMC
+	depends on CFG80211
+	select WIRELESS_EXT
+	select WEXT_PRIV
+	---help---
+	  This module adds support for wireless adapters based on
+	  Atheros AR6003 chipset running over SDIO. If you choose to
+	  build it as a module, it will be called ath6kl. Pls note
+	  that AR6002 and AR6001 are not supported by this driver.
+
+config ATH6KL_DEBUG
+	bool "Atheros ath6kl debugging"
+	depends on ATH6KL
+	---help---
+	  Enables debug support
diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
new file mode 100644
index 0000000..e1bb07e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -0,0 +1,35 @@
+#------------------------------------------------------------------------------
+# Copyright (c) 2004-2010 Atheros Communications Inc.
+# All rights reserved.
+#
+#
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+#
+#
+#
+# Author(s): ="Atheros"
+#------------------------------------------------------------------------------
+
+obj-$(CONFIG_ATH6KL) := ath6kl.o
+ath6kl-y += debug.o
+ath6kl-y += htc_hif.o
+ath6kl-y += htc.o
+ath6kl-y += bmi.o
+ath6kl-y += cfg80211.o
+ath6kl-y += init.o
+ath6kl-y += main.o
+ath6kl-y += txrx.o
+ath6kl-y += wmi.o
+ath6kl-y += node.o
+ath6kl-y += sdio.o

