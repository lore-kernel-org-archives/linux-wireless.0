Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51614 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab1JCKML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:12:11 -0400
Received: by bkbzt4 with SMTP id zt4so5103443bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 03:12:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: configure rate policy for p2p operations
Date: Mon,  3 Oct 2011 12:06:36 +0200
Message-Id: <1317636396-23387-1-git-send-email-eliad@wizery.com> (sfid-20111003_121215_640217_19CD113B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p2p packets should go out only with OFDM rates.

Configure a new rate policy that will (later) be used
during p2p_find (when the p2p_cli / p2p_go interfaces
are in use, we won't have to use this policy, as
the configured rates should already be OFDM-only).

Additionally, update CONF_TX_MAX_RATE_CLASSES to reflect
the current value from the fw api.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   16 ++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |    1 +
 drivers/net/wireless/wl12xx/conf.h |    6 +++++-
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 399849e..ca044a7 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -777,7 +777,23 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
 	acx->rate_policy.aflags = c->aflags;
 
+	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of rate policies failed: %d", ret);
+		goto out;
+	}
 
+	/*
+	 * configure one rate class for basic p2p operations.
+	 * (p2p packets should always go out with OFDM rates, even
+	 * if we are currently connected to 11b AP)
+	 */
+	acx->rate_policy_idx = cpu_to_le32(ACX_TX_BASIC_RATE_P2P);
+	acx->rate_policy.enabled_rates =
+				cpu_to_le32(CONF_TX_RATE_MASK_BASIC_P2P);
+	acx->rate_policy.short_retry_limit = c->short_retry_limit;
+	acx->rate_policy.long_retry_limit = c->long_retry_limit;
+	acx->rate_policy.aflags = c->aflags;
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 556ee4e..e3f93b4 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -656,6 +656,7 @@ struct acx_rate_class {
 
 #define ACX_TX_BASIC_RATE      0
 #define ACX_TX_AP_FULL_RATE    1
+#define ACX_TX_BASIC_RATE_P2P  2
 #define ACX_TX_AP_MODE_MGMT_RATE 4
 #define ACX_TX_AP_MODE_BCST_RATE 5
 struct acx_rate_policy {
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 6a6805c..04bb8fb 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -416,13 +416,17 @@ struct conf_rx_settings {
 	u8 queue_type;
 };
 
-#define CONF_TX_MAX_RATE_CLASSES       8
+#define CONF_TX_MAX_RATE_CLASSES       10
 
 #define CONF_TX_RATE_MASK_UNSPECIFIED  0
 #define CONF_TX_RATE_MASK_BASIC        (CONF_HW_BIT_RATE_1MBPS | \
 					CONF_HW_BIT_RATE_2MBPS)
 #define CONF_TX_RATE_RETRY_LIMIT       10
 
+/* basic rates for p2p operations (probe req/resp, etc.) */
+#define CONF_TX_RATE_MASK_BASIC_P2P    (CONF_HW_BIT_RATE_6MBPS | \
+	CONF_HW_BIT_RATE_12MBPS | CONF_HW_BIT_RATE_24MBPS)
+
 /*
  * Rates supported for data packets when operating as AP. Note the absence
  * of the 22Mbps rate. There is a FW limitation on 12 rates so we must drop
-- 
1.7.6.401.g6a319

