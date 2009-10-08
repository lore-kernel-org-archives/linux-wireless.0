Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZJHEfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 00:35:05 -0400
Date: Thu, 8 Oct 2009 00:34:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	vasanth@atheros.com, Sujith.Manoharan@atheros.com
Subject: Re: [PATCH 1/6] ath9k: move common->debug_mask setting to
	ath_init_softc()
Message-ID: <20091008043426.GA5760@bombadil.infradead.org>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com> <1254878351-32433-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254878351-32433-2-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 09:19:06PM -0400, Luis R. Rodriguez wrote:
> What this means is we can enable now debug prints without
> requiring CONFIG_ATH9K_DEBUG.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

> +MODULE_PARM_DESC(ath9k_debug, "Debugging mask");

John, as sujith notes, this should be MODULE_PARM_DESC(debug ...

Thanks sujith.

so here's v2:

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH v2 1/6] ath9k: move common->debug_mask setting to ath_init_softc()

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
index 86374ad..aeda541 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -29,6 +29,10 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
+static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
+module_param_named(debug, ath9k_debug, uint, 0);
+MODULE_PARM_DESC(debug, "Debugging mask");
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

