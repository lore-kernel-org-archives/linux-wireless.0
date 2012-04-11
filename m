Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:36805 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933016Ab2DKTyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:04 -0400
Received: by lbbgi11 with SMTP id gi11so952014lbb.38
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:02 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 14/24] wlcore/wl12xx: add hw op for vif init
Date: Wed, 11 Apr 2012 22:53:30 +0300
Message-Id: <1334174020-18957-15-git-send-email-coelho@ti.com> (sfid-20120411_215426_779619_34BAE5A2)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Add an op for family-specific vif initialization.  Currently unused,
but will be needed when wl18xx support is implemented.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 +++++++++
 drivers/net/wireless/ti/wlcore/init.c   |    5 +++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 9b2f40c..564ca91 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -915,6 +915,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.tx_immediate_compl	= NULL,
 	.tx_delayed_compl	= wl12xx_tx_delayed_compl,
 	.hw_init		= wl12xx_hw_init,
+	.init_vif		= NULL,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 14748d3..262728a 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -93,5 +93,14 @@ static inline void wlcore_hw_tx_immediate_compl(struct wl1271 *wl)
 		wl->ops->tx_immediate_compl(wl);
 }
 
+static inline int
+wlcore_hw_init_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	if (wl->ops->init_vif)
+		return wl->ops->init_vif(wl, wlvif);
+
+	return 0;
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index afe4f75..9f89255 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -32,6 +32,7 @@
 #include "cmd.h"
 #include "tx.h"
 #include "io.h"
+#include "hw_ops.h"
 
 int wl1271_init_templates_config(struct wl1271 *wl)
 {
@@ -638,6 +639,10 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	if (ret < 0)
 		return ret;
 
+	ret = wlcore_hw_init_vif(wl, wlvif);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 91ccd1e..7e2881d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -54,6 +54,7 @@ struct wlcore_ops {
 	void (*tx_delayed_compl)(struct wl1271 *wl);
 	void (*tx_immediate_compl)(struct wl1271 *wl);
 	int (*hw_init)(struct wl1271 *wl);
+	int (*init_vif)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

