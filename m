Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0057.outbound.protection.outlook.com ([104.47.38.57]:39552
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751092AbeAVMrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:00 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 02/11] qtnfmac: fix warnings when mBSS setup is stopped
Date: Mon, 22 Jan 2018 15:46:25 +0300
Message-Id: <20180122124634.8430-3-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134706_487839_8157230F)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

Virtual interface should be deleted after calling unregister_netdevice
since this function ends up with sending updown_intf command to card.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index abf10996c26a..c417a67b0291 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -120,10 +120,6 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	qtnf_scan_done(vif->mac, true);
 
-	if (qtnf_cmd_send_del_intf(vif))
-		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
-		       vif->vifid);
-
 	/* Stop data */
 	netif_tx_stop_all_queues(netdev);
 	if (netif_carrier_ok(netdev))
@@ -132,6 +128,10 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(netdev);
 
+	if (qtnf_cmd_send_del_intf(vif))
+		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
+		       vif->vifid);
+
 	vif->netdev->ieee80211_ptr = NULL;
 	vif->netdev = NULL;
 	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
-- 
2.11.0
