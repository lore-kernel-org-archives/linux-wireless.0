Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0GFAkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:40:03 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 04/15] mmc: support embedded data field in mmc_host
Date: Tue,  6 Jul 2010 03:37:35 +0300
Message-Id: <1278376666-3509-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

Add support to set/get mmc_host private embedded
data.

This is needed to allow software to dynamically
create (and remove) SDIO functions which represents
embedded SDIO devices.

Typically, it will be used to set the context of
a driver that is creating a new SDIO function
(and would then expect to be able to get that context
back upon creation of the new sdio func).

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 drivers/mmc/core/Kconfig |    8 ++++++++
 include/linux/mmc/host.h |   16 ++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index bb22ffd..ab27eb3 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -16,3 +16,11 @@ config MMC_UNSAFE_RESUME
 
 	  This option sets a default which can be overridden by the
 	  module parameter "removable=0" or "removable=1".
+
+config MMC_EMBEDDED_SDIO
+	boolean "MMC embedded SDIO device support"
+	help
+	  If you say Y here, support will be added for embedded SDIO
+	  devices (e.g. hardwired embedded WLAN SDIO devices).
+	  Such devices require software support for emulating
+	  card detect events.
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f65913c..9a48486 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -209,6 +209,10 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+#ifdef CONFIG_MMC_EMBEDDED_SDIO
+	void			*embedded_data;
+#endif
+
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
@@ -264,5 +268,17 @@ static inline void mmc_set_disable_delay(struct mmc_host *host,
 	host->disable_delay = disable_delay;
 }
 
+#ifdef CONFIG_MMC_EMBEDDED_SDIO
+static inline void *mmc_get_embedded_data(struct mmc_host *host)
+{
+	return host->embedded_data;
+}
+
+static inline void mmc_set_embedded_data(struct mmc_host *host, void *data)
+{
+	host->embedded_data = data;
+}
+#endif
+
 #endif
 
-- 
1.7.0.4

