Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47583 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1AET1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:27:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] ath5k: move nohwcrypt to ath_common structure
Date: Wed,  5 Jan 2011 14:22:06 -0500
Message-Id: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath.h                |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |    3 ++-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    3 +--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e43210c..3c2999f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -165,6 +165,7 @@ struct ath_common {
 	const struct ath_bus_ops *bus_ops;
 
 	bool btcoex_enabled;
+	bool nohwcrypt;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fce9a98..e7be051 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -61,7 +61,7 @@
 #include "debug.h"
 #include "ani.h"
 
-int modparam_nohwcrypt;
+static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
@@ -2395,6 +2395,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	common->ah = sc->ah;
 	common->hw = hw;
 	common->priv = sc;
+	common->nohwcrypt = modparam_nohwcrypt;
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index de257a3..309c551 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -46,7 +46,6 @@
 #include "base.h"
 #include "reg.h"
 
-extern int modparam_nohwcrypt;
 
 /* functions used from base.c */
 void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
@@ -485,7 +484,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret = 0;
 
-	if (modparam_nohwcrypt)
+	if (common->nohwcrypt)
 		return -EOPNOTSUPP;
 
 	switch (key->cipher) {
-- 
1.7.3.4

