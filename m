Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752177AbdKMK2f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:35 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 04/10] qtnfmac: change default interface mode from AP to STA
Date: Mon, 13 Nov 2017 13:28:09 +0300
Message-Id: <20171113102815.11254-5-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112927_600219_AC7B98C3)
In-Reply-To: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

To mimic mac80211 behaviour, change default interface type from AP to STA.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  2 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 11 ++++-------
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  3 +--
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 64fc4119b3a6..a11278de678d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -190,7 +190,7 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 		goto err_mac;
 	}
 
-	if (qtnf_core_net_attach(mac, vif, name, name_assign_t, type)) {
+	if (qtnf_core_net_attach(mac, vif, name, name_assign_t)) {
 		pr_err("VIF%u.%u: failed to attach netdev\n", mac->macid,
 		       vif->vifid);
 		goto err_net;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 2d2c1ea65cb2..ea850cb7dffc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -258,7 +258,7 @@ static void qtnf_mac_init_primary_intf(struct qtnf_wmac *mac)
 {
 	struct qtnf_vif *vif = &mac->iflist[QTNF_PRIMARY_VIF_IDX];
 
-	vif->wdev.iftype = NL80211_IFTYPE_AP;
+	vif->wdev.iftype = NL80211_IFTYPE_STATION;
 	vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
 	vif->wdev.wiphy = priv_to_wiphy(mac);
 	INIT_WORK(&vif->reset_work, qtnf_vif_reset_handler);
@@ -298,8 +298,7 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 }
 
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
-			 const char *name, unsigned char name_assign_type,
-			 enum nl80211_iftype iftype)
+			 const char *name, unsigned char name_assign_type)
 {
 	struct wiphy *wiphy = priv_to_wiphy(mac);
 	struct net_device *dev;
@@ -320,7 +319,6 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	dev->needs_free_netdev = true;
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = &vif->wdev;
-	dev->ieee80211_ptr->iftype = iftype;
 	ether_addr_copy(dev->dev_addr, vif->mac_addr);
 	SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
@@ -418,7 +416,7 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
 		goto error;
 	}
 
-	ret = qtnf_cmd_send_add_intf(vif, NL80211_IFTYPE_AP, vif->mac_addr);
+	ret = qtnf_cmd_send_add_intf(vif, vif->wdev.iftype, vif->mac_addr);
 	if (ret) {
 		pr_err("MAC%u: failed to add VIF\n", macid);
 		goto error;
@@ -446,8 +444,7 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
 
 	rtnl_lock();
 
-	ret = qtnf_core_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM,
-				   NL80211_IFTYPE_AP);
+	ret = qtnf_core_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM);
 	rtnl_unlock();
 
 	if (ret) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 1b7bc0318f3e..8e42d1bdc65f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -144,8 +144,7 @@ struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
 struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac);
 struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
-			 const char *name, unsigned char name_assign_type,
-			 enum nl80211_iftype iftype);
+			 const char *name, unsigned char name_assign_type);
 void qtnf_main_work_queue(struct work_struct *work);
 int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed);
 int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
-- 
2.11.0
