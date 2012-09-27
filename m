Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:46693 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2I0Kii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:38 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 02/31] wlcore: consider single fw case
Date: Thu, 27 Sep 2012 13:37:40 +0300
Message-Id: <1348742289-6587-3-git-send-email-luca@coelho.fi> (sfid-20120927_124033_565126_6E5A9E98)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When a single fw is being used for both single-role
and multi-role cases (e.g. 18xx), wl->mr_fw_name is
NULL, which results in NULL dereference while trying
to load the multi-role fw.

In this case, always use the single-role fw, and avoid
redundant fw switch by checking for this case in
wl12xx_need_fw_change() as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 600af8e..f421c42 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -696,7 +696,7 @@ static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 		 * we can't call wl12xx_get_vif_count() here because
 		 * wl->mutex is taken, so use the cached last_vif_count value
 		 */
-		if (wl->last_vif_count > 1) {
+		if (wl->last_vif_count > 1 && wl->mr_fw_name) {
 			fw_type = WL12XX_FW_TYPE_MULTI;
 			fw_name = wl->mr_fw_name;
 		} else {
@@ -2170,6 +2170,10 @@ static bool wl12xx_need_fw_change(struct wl1271 *wl,
 	if (wl->state == WL1271_STATE_OFF)
 		return false;
 
+	/* no need for fw change if a single fw is used */
+	if (!wl->mr_fw_name)
+		return false;
+
 	if (vif_count > 1 && current_fw == WL12XX_FW_TYPE_NORMAL)
 		return true;
 	if (vif_count <= 1 && current_fw == WL12XX_FW_TYPE_MULTI)
-- 
1.7.10.4

