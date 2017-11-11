Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:54015 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdKKRFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 12:05:42 -0500
From: Johan Hovold <johan@kernel.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: fix iris child-node lookup
Date: Sat, 11 Nov 2017 18:05:32 +0100
Message-Id: <20171111170532.6110-1-johan@kernel.org> (sfid-20171111_180603_660735_515734FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix child-node lookup during probe, which ended up searching the whole
device tree depth-first starting at the parent rather than just matching
on its children.

To make things worse, the parent mmio node was also prematurely freed.

Fixes: fd52bdae9ab0 ("wcn36xx: Disable 5GHz for wcn3620")
Cc: stable <stable@vger.kernel.org>     # 4.14
Cc: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 71812a2dd513..f7d228b5ba93 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1233,7 +1233,7 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 	}
 
 	/* External RF module */
-	iris_node = of_find_node_by_name(mmio_node, "iris");
+	iris_node = of_get_child_by_name(mmio_node, "iris");
 	if (iris_node) {
 		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
 			wcn->rf_id = RF_IRIS_WCN3620;
-- 
2.15.0
