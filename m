Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47581 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1AET1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:27:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] ath9k_htc: use nohwcrypt in ath_common structure
Date: Wed,  5 Jan 2011 14:22:08 -0500
Message-Id: <1294255328-14322-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index a099b3e..64d1684 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -42,7 +42,6 @@
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
 extern struct ieee80211_ops ath9k_htc_ops;
-extern int htc_modparam_nohwcrypt;
 
 enum htc_phymode {
 	HTC_MODE_AUTO		= 0,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 38433f9..2f1d494 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -24,8 +24,8 @@ static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 MODULE_PARM_DESC(debug, "Debugging mask");
 
-int htc_modparam_nohwcrypt;
-module_param_named(nohwcrypt, htc_modparam_nohwcrypt, int, 0444);
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
 #define CHAN2G(_freq, _idx)  { \
@@ -641,6 +641,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->hw = priv->hw;
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
+	common->nohwcrypt = modparam_nohwcrypt;
 
 	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 845b4c9..4c7ca46 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1372,7 +1372,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	int ret = 0;
 
-	if (htc_modparam_nohwcrypt)
+	if (common->nohwcrypt)
 		return -ENOSPC;
 
 	mutex_lock(&priv->mutex);
-- 
1.7.3.4

