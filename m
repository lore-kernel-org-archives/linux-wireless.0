Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751275AbdJEBiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:22 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 4/8] qtnfmac: get rid of QTNF_STATE_AP_CONFIG
Date: Wed,  4 Oct 2017 18:38:09 -0700
Message-Id: <20171005013813.13332-5-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033842_730907_08999794)
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

QTNF_STATE_AP_CONFIG is redundant and its usage can be safely removed.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 8 --------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 ---
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 056018e..c660846 100644
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
index f5bc43b..59ca6ca 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -256,8 +256,6 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 		goto out;
 	}
 
-	vif->bss_status |= QTNF_STATE_AP_CONFIG;
-
 out:
 	qtnf_bus_unlock(vif->mac->bus);
 	return ret;
@@ -290,7 +288,6 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 	}
 
 	vif->bss_status &= ~QTNF_STATE_AP_START;
-	vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
 
 	netif_carrier_off(vif->netdev);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 2cd0150..f8165a7 100644
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
