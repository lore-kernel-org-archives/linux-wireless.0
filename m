Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751201AbdJEBiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:23 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 5/8] qtnfmac: get rid of QTNF_STATE_AP_START flag
Date: Wed,  4 Oct 2017 18:38:10 -0700
Message-Id: <20171005013813.13332-6-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033830_982819_018A3B96)
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

QTNF_STATE_AP_START usage is redundant and imposes additional state
synchronization maintenance. We may as well leave state checking
to network card and upper layers (cfg80211, nl80211 and userspace).

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 29 +----------------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  3 ---
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  3 +--
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 12 ----------
 4 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index c660846..08f1f54 100644
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
@@ -784,19 +770,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
 	if (!cfg80211_chandef_valid(&params->chandef)) {
 		pr_err("%s: invalid channel\n", dev->name);
 		return -EINVAL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 59ca6ca..60d65df 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -173,7 +173,6 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 		goto out;
 	}
 
-	vif->bss_status |= QTNF_STATE_AP_START;
 	netif_carrier_on(vif->netdev);
 
 out:
@@ -287,8 +286,6 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 		goto out;
 	}
 
-	vif->bss_status &= ~QTNF_STATE_AP_START;
-
 	netif_carrier_off(vif->netdev);
 
 out:
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index f8165a7..b35200d 100644
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
index 7481d5b..d7fb076 100644
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
