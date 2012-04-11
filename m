Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56654 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933063Ab2DKTyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:09 -0400
Received: by lbom4 with SMTP id m4so1273189lbo.11
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:06 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 19/24] wlcore/wl12xx: add hw op to get rate-mask for AP-link in STA mode
Date: Wed, 11 Apr 2012 22:53:35 +0300
Message-Id: <1334174020-18957-20-git-send-email-coelho@ti.com> (sfid-20120411_215441_826675_7C9A7F57)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In some chip-families, there are operating modes where we must mask-out
certain Tx rates, and/or tweak the rate-mask with special HW-specific
bits.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    7 +++++++
 drivers/net/wireless/ti/wlcore/acx.c    |    6 +++++-
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 +++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 ++
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index c90333a..f22cd55 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1192,6 +1192,12 @@ out:
 	return ret;
 }
 
+static u32 wl12xx_sta_get_ap_rate_mask(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif)
+{
+	return wlvif->rate_set;
+}
+
 static void wl12xx_conf_init(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1280,6 +1286,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.tx_delayed_compl	= wl12xx_tx_delayed_compl,
 	.hw_init		= wl12xx_hw_init,
 	.init_vif		= NULL,
+	.sta_get_ap_rate_mask	= wl12xx_sta_get_ap_rate_mask,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 9ad8fd5..5912541 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -32,6 +32,7 @@
 #include "debug.h"
 #include "wl12xx_80211.h"
 #include "ps.h"
+#include "hw_ops.h"
 
 int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				  u8 wake_up_event, u8 listen_interval)
@@ -756,7 +757,10 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* configure one AP supported rate class */
 	acx->rate_policy_idx = cpu_to_le32(wlvif->sta.ap_rate_idx);
-	acx->rate_policy.enabled_rates = cpu_to_le32(wlvif->rate_set);
+
+	/* the AP policy is HW specific */
+	acx->rate_policy.enabled_rates =
+		cpu_to_le32(wlcore_hw_sta_get_ap_rate_mask(wl, wlvif));
 	acx->rate_policy.short_retry_limit = c->short_retry_limit;
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
 	acx->rate_policy.aflags = c->aflags;
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 262728a..25b20ff 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -102,5 +102,14 @@ wlcore_hw_init_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return 0;
 }
 
+static inline u32
+wlcore_hw_sta_get_ap_rate_mask(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	if (!wl->ops->sta_get_ap_rate_mask)
+		BUG_ON(1);
+
+	return wl->ops->sta_get_ap_rate_mask(wl, wlvif);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 9f33f96..0660f75 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -56,6 +56,8 @@ struct wlcore_ops {
 	void (*tx_immediate_compl)(struct wl1271 *wl);
 	int (*hw_init)(struct wl1271 *wl);
 	int (*init_vif)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+	u32 (*sta_get_ap_rate_mask)(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

