Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754347AbdHYCax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:53 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 07/27] qtnfmac: get rid of QTNF_STATE_AP_CONFIG
Date: Thu, 24 Aug 2017 19:30:04 -0700
Message-Id: <20170825023024.10565-8-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043148_611307_301F8C48)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

QTNF_STATE_AP_CONFIG is redundant and has no real meaning.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 8 --------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 ---
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 858c24f..26caaf6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -275,13 +275,6 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
-	if (!(vif->bss_status & QTNF_STATE_AP_CONFIG)) {
-		pr_err("VIF%u.%u: AP config failed in FW\n", vif->mac->macid,
-		       vif->vifid);
-		ret = -EFAULT;
-		goto out;
-	}
-
 	ret = qtnf_mgmt_set_appie(vif, &settings->beacon);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to add IEs to beacon\n",
@@ -316,7 +309,6 @@ static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
 		       vif->mac->macid, vif->vifid);
 		vif->bss_status &= ~QTNF_STATE_AP_START;
-		vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
 
 		netif_carrier_off(vif->netdev);
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7b24d37..6b4ccf7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -255,8 +255,6 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 		goto out;
 	}
 
-	vif->bss_status |= QTNF_STATE_AP_CONFIG;
-
 out:
 	qtnf_bus_unlock(vif->mac->bus);
 	return ret;
@@ -289,7 +287,6 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 	}
 
 	vif->bss_status &= ~QTNF_STATE_AP_START;
-	vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
 
 	netif_carrier_off(vif->netdev);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 066fcd1..4d3e036 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -52,7 +52,6 @@
 #define QTNF_DEF_WDOG_TIMEOUT		5
 #define QTNF_TX_TIMEOUT_TRSHLD		100
 
-#define QTNF_STATE_AP_CONFIG		BIT(2)
 #define QTNF_STATE_AP_START		BIT(1)
 
 extern const struct net_device_ops qtnf_netdev_ops;
-- 
2.9.5
