Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbZJFDx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 23:53:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: vasanth@atheros.com, linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 1/4] ath9k: move common->debug_mask setting to ath_init_softc()
Date: Mon,  5 Oct 2009 23:53:18 -0400
Message-Id: <1254801201-15893-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
References: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What this means is we can enable now debug prints without
requiring CONFIG_ATH9K_DEBUG.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    5 -----
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 25ae88e..84f4426 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -23,9 +23,6 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
-static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
-module_param_named(debug, ath9k_debug, uint, 0);
-
 static struct dentry *ath9k_debugfs_root;
 
 static int ath9k_debugfs_open(struct inode *inode, struct file *file)
@@ -565,8 +562,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
-	common->debug_mask = ath9k_debug;
-
 	if (!ath9k_debugfs_root)
 		return -ENOENT;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 86374ad..7f90cb8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -29,6 +29,10 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
+static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
+module_param_named(debug, ath9k_debug, uint, 0);
+MODULE_PARM_DESC(ath9k_debug, "Debugging mask");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -1637,6 +1641,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->ah = ah;
 	common->hw = sc->hw;
 	common->priv = sc;
+	common->debug_mask = ath9k_debug;
 
 	/*
 	 * Cache line size is used to size and align various
-- 
1.6.0.4

