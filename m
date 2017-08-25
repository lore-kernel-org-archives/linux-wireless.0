Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754463AbdHYCay (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:54 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 08/27] qtnfmac: get rid of QTNF_STATE_AP_START usage
Date: Thu, 24 Aug 2017 19:30:05 -0700
Message-Id: <20170825023024.10565-9-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043101_523017_89834775)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

QTNF_STATE_AP_START usage is redundant and imposes additional state
synchronization maintenance. We may as well leave state checking up
to network card and upper layers (cfg80211, nl80211 and userspace).

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 29 +----------------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  3 ---
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  3 +--
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 12 ----------
 4 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 26caaf6..999f1bd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -254,11 +254,6 @@ static int qtnf_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 
-	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("VIF%u.%u: not started\n", vif->mac->macid, vif->vifid);
-		return -EFAULT;
-	}
-
 	return qtnf_mgmt_set_appie(vif, info);
 }
 
@@ -283,17 +278,9 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	ret = qtnf_cmd_send_start_ap(vif);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to start AP\n", vif->mac->macid,
 		       vif->vifid);
-		goto out;
-	}
-
-	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("VIF%u.%u: FW failed to start AP operation\n",
-		       vif->mac->macid, vif->vifid);
-		ret = -EFAULT;
-	}
 
 out:
 	return ret;
@@ -308,7 +295,6 @@ static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	if (ret) {
 		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
 		       vif->mac->macid, vif->vifid);
-		vif->bss_status &= ~QTNF_STATE_AP_START;
 
 		netif_carrier_off(vif->netdev);
 	}
@@ -797,19 +783,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		 params->chandef.chan->hw_value, params->count,
 		 params->radar_required, params->block_tx);
 
-	switch (vif->wdev.iftype) {
-	case NL80211_IFTYPE_AP:
-		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-			pr_warn("AP not started on %s\n", dev->name);
-			return -ENOTCONN;
-		}
-		break;
-	default:
-		pr_err("unsupported vif type (%d) on %s\n",
-		       vif->wdev.iftype, dev->name);
-		return -EOPNOTSUPP;
-	}
-
 	if (vif->vifid != 0) {
 		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
 			return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 6b4ccf7..cb9632b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -173,7 +173,6 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 		goto out;
 	}
 
-	vif->bss_status |= QTNF_STATE_AP_START;
 	netif_carrier_on(vif->netdev);
 
 out:
@@ -286,8 +285,6 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 		goto out;
 	}
 
-	vif->bss_status &= ~QTNF_STATE_AP_START;
-
 	netif_carrier_off(vif->netdev);
 
 out:
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 4d3e036..a40295e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -52,9 +52,8 @@
 #define QTNF_DEF_WDOG_TIMEOUT		5
 #define QTNF_TX_TIMEOUT_TRSHLD		100
 
-#define QTNF_STATE_AP_START		BIT(1)
-
 extern const struct net_device_ops qtnf_netdev_ops;
+
 struct qtnf_bus;
 struct qtnf_vif;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 52e2652..7435986 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -53,12 +53,6 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 		return -EPROTO;
 	}
 
-	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("VIF%u.%u: STA_ASSOC event when AP is not started\n",
-		       mac->macid, vif->vifid);
-		return -EPROTO;
-	}
-
 	sta_addr = sta_assoc->sta_addr;
 	frame_control = le16_to_cpu(sta_assoc->frame_control);
 
@@ -127,12 +121,6 @@ qtnf_event_handle_sta_deauth(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 		return -EPROTO;
 	}
 
-	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("VIF%u.%u: STA_DEAUTH event when AP is not started\n",
-		       mac->macid, vif->vifid);
-		return -EPROTO;
-	}
-
 	sta_addr = sta_deauth->sta_addr;
 	reason = le16_to_cpu(sta_deauth->reason);
 
-- 
2.9.5
