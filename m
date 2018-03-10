Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:33629 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbeCJVbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 16:31:44 -0500
Subject: [PATCH 1/3] wlcore: Delete an unnecessary variable initialisation in
 wl1271_acx_sta_rate_policies()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Message-ID: <76c402d0-e8eb-9b05-20c1-33db7e5325c2@users.sourceforge.net> (sfid-20180310_223203_076933_AC38DD87)
Date: Sat, 10 Mar 2018 22:31:38 +0100
MIME-Version: 1.0
In-Reply-To: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Mar 2018 21:51:17 +0100

The local variable "ret" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ti/wlcore/acx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 3ca9167d6146..6991fee8fe61 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -738,7 +738,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct acx_rate_policy *acx;
 	struct conf_tx_rate_class *c = &wl->conf.tx.sta_rc_conf;
-	int ret = 0;
+	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx rate policies");
 
-- 
2.16.2
