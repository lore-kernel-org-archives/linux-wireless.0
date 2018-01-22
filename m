Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:56768
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbeAVMrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:10 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 07/11] qtnfmac: validate interface combinations on changes
Date: Mon, 22 Jan 2018 15:46:30 +0300
Message-Id: <20180122124634.8430-8-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134714_289770_94A2D3BD)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Validate new interface combinations using wireless core checks when new
interface is added or when the type of existing interface is modified.
This is performed to make sure that new interface combination is supported
by hardware. As a result, invalid interface combinations are rejected early,
rather than passed to hardware with sometimes unpredictable results.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 78e8968ab3c7..91830fd41508 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -81,6 +81,41 @@ qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 };
 
 static int
+qtnf_validate_iface_combinations(struct wiphy *wiphy,
+				 struct qtnf_vif *change_vif,
+				 enum nl80211_iftype new_type)
+{
+	struct qtnf_wmac *mac;
+	struct qtnf_vif *vif;
+	int i;
+	int ret = 0;
+	struct iface_combination_params params = {
+		.num_different_channels = 1,
+	};
+
+	mac = wiphy_priv(wiphy);
+	if (!mac)
+		return -EFAULT;
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		vif = &mac->iflist[i];
+		if (vif->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
+			params.iftype_num[vif->wdev.iftype]++;
+	}
+
+	if (change_vif) {
+		params.iftype_num[new_type]++;
+		params.iftype_num[change_vif->wdev.iftype]--;
+	} else {
+		params.iftype_num[new_type]++;
+	}
+
+	ret = cfg80211_check_combinations(wiphy, &params);
+
+	return ret;
+}
+
+static int
 qtnf_change_virtual_intf(struct wiphy *wiphy,
 			 struct net_device *dev,
 			 enum nl80211_iftype type,
@@ -90,6 +125,13 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
 	u8 *mac_addr;
 	int ret;
 
+	ret = qtnf_validate_iface_combinations(wiphy, vif, type);
+	if (ret) {
+		pr_err("VIF%u.%u combination check: failed to set type %d\n",
+		       vif->mac->macid, vif->vifid, type);
+		return ret;
+	}
+
 	if (params)
 		mac_addr = params->macaddr;
 	else
@@ -150,12 +192,20 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
 	u8 *mac_addr = NULL;
+	int ret;
 
 	mac = wiphy_priv(wiphy);
 
 	if (!mac)
 		return ERR_PTR(-EFAULT);
 
+	ret = qtnf_validate_iface_combinations(wiphy, NULL, type);
+	if (ret) {
+		pr_err("MAC%u invalid combination: failed to add type %d\n",
+		       mac->macid, type);
+		return ERR_PTR(ret);
+	}
+
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_AP:
-- 
2.11.0
