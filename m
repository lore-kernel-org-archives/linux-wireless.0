Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:42983 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbeCJVdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 16:33:45 -0500
Subject: [PATCH 3/3] wlcore: Use common error handling code in
 wl1271_acx_sta_rate_policies()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Message-ID: <7d5cc7b4-f0ce-192a-3e5e-c2944c1e3e3d@users.sourceforge.net> (sfid-20180310_223404_458657_CB34810B)
Date: Sat, 10 Mar 2018 22:33:39 +0100
MIME-Version: 1.0
In-Reply-To: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Mar 2018 22:18:45 +0100

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ti/wlcore/acx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 1cc5bba670e1..7d37a417c756 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -757,10 +757,8 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	acx->rate_policy.aflags = c->aflags;
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl1271_warning("Setting of rate policies failed: %d", ret);
-		goto out;
-	}
+	if (ret < 0)
+		goto report_failure;
 
 	/* configure one AP supported rate class */
 	acx->rate_policy_idx = cpu_to_le32(wlvif->sta.ap_rate_idx);
@@ -773,10 +771,8 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	acx->rate_policy.aflags = c->aflags;
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl1271_warning("Setting of rate policies failed: %d", ret);
-		goto out;
-	}
+	if (ret < 0)
+		goto report_failure;
 
 	/*
 	 * configure one rate class for basic p2p operations.
@@ -791,14 +787,16 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	acx->rate_policy.aflags = c->aflags;
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl1271_warning("Setting of rate policies failed: %d", ret);
-		goto out;
-	}
+	if (ret < 0)
+		goto report_failure;
 
-out:
+free_acx:
 	kfree(acx);
 	return ret;
+
+report_failure:
+	wl1271_warning("Setting of rate policies failed: %d", ret);
+	goto free_acx;
 }
 
 int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
-- 
2.16.2
