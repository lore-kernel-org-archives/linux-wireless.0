Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab0GURec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:34:32 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
Date: Wed, 21 Jul 2010 20:33:37 +0300
Message-Id: <1279733634-21974-4-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to set/get mmc_host private embedded
data.

This is needed to allow software to dynamically
create (and remove) SDIO functions which represents
embedded SDIO devices.

Typically, it will be used to set the context of
a driver that is creating a new SDIO function
(and would then expect to be able to get that context
back upon creation of the new sdio func).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 include/linux/mmc/host.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f65913c..80db597 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -209,6 +209,8 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+	void			*embedded_data;
+
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
@@ -264,5 +266,15 @@ static inline void mmc_set_disable_delay(struct mmc_host *host,
 	host->disable_delay = disable_delay;
 }
 
+static inline void *mmc_get_embedded_data(struct mmc_host *host)
+{
+	return host->embedded_data;
+}
+
+static inline void mmc_set_embedded_data(struct mmc_host *host, void *data)
+{
+	host->embedded_data = data;
+}
+
 #endif
 
-- 
1.7.0.4

