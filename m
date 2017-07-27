Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0080.outbound.protection.outlook.com ([104.47.33.80]:46841
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751637AbdG0XHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:38 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 06/12] qtnfmac: fix station leave reason endianness
Date: Fri, 28 Jul 2017 02:06:48 +0300
Message-Id: <20170727230654.30850-7-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010743_391143_C26C43DC)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use proper endianness conversion for client station leave reason.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 4 ++--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 9b61e9a83670..00570de918e6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -211,8 +211,8 @@ qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
 
 	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
 
-	cfg80211_disconnected(vif->netdev, leave_info->reason, NULL, 0, 0,
-			      GFP_KERNEL);
+	cfg80211_disconnected(vif->netdev, le16_to_cpu(leave_info->reason),
+			      NULL, 0, 0, GFP_KERNEL);
 
 	vif->sta_state = QTNF_STA_DISCONNECTED;
 	netif_carrier_off(vif->netdev);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 6c6940b503a4..5c2d8f0abd7f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -733,7 +733,7 @@ struct qlink_event_bss_join {
  */
 struct qlink_event_bss_leave {
 	struct qlink_event ehdr;
-	u16 reason;
+	__le16 reason;
 } __packed;
 
 enum qlink_rxmgmt_flags {
-- 
2.11.0
