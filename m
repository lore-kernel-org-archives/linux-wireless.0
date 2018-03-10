Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:43801 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeCJVct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 16:32:49 -0500
Subject: [PATCH 2/3] wlcore: Return directly after a failed kzalloc() in
 wl1271_acx_sta_rate_policies()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Message-ID: <8ef461f4-5103-9181-b68d-e31720206ee3@users.sourceforge.net> (sfid-20180310_223311_005577_156402B8)
Date: Sat, 10 Mar 2018 22:32:43 +0100
MIME-Version: 1.0
In-Reply-To: <b5db0825-394a-1d6d-351a-43be14e4c6b4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Mar 2018 22:00:31 +0100

Return directly after a call of the function "kzalloc" failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ti/wlcore/acx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 6991fee8fe61..1cc5bba670e1 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -743,11 +743,8 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_ACX, "acx rate policies");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!acx)
+		return -ENOMEM;
 
 	wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
 		wlvif->basic_rate, wlvif->rate_set);
-- 
2.16.2
