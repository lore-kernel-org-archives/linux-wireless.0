Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933559AbeE2MAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:32 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 4/9] qtnfmac: cleanup wdev structure between its uses
Date: Tue, 29 May 2018 15:00:00 +0300
Message-Id: <20180529120005.21498-5-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140059_393851_F40602D0)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver uses statically allocated wdev structures for each virtual
interface. However wdev structure is not properly cleaned up between
its uses. As a result, various bugs appear when userspace tools
like hostapd were not gracefully stopped.

In particular, this commit fixes the following issue:
- start hostapd with more than 2 mBSS
- kill hostapd using SIGKILL
- start again hostapd with more than 2 mBSS
However only two mBSS entities will be started: primary
and the last BSS listed in hostapd config.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 8 +++-----
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index bf624d975953..2089cb095283 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -177,8 +177,6 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	vif->netdev->ieee80211_ptr = NULL;
 	vif->netdev = NULL;
 	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
-	eth_zero_addr(vif->mac_addr);
-	eth_zero_addr(vif->bssid);
 
 	return 0;
 }
@@ -216,10 +214,12 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 		}
 
 		eth_zero_addr(vif->mac_addr);
+		eth_zero_addr(vif->bssid);
 		vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+		memset(&vif->wdev, 0, sizeof(vif->wdev));
 		vif->wdev.wiphy = wiphy;
 		vif->wdev.iftype = type;
-		vif->sta_state = QTNF_STA_DISCONNECTED;
 		break;
 	default:
 		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
@@ -255,8 +255,6 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 	qtnf_cmd_send_del_intf(vif);
 err_cmd:
 	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
-	eth_zero_addr(vif->mac_addr);
-	eth_zero_addr(vif->bssid);
 
 	return ERR_PTR(-EFAULT);
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index b3bfb4faa918..3ccbc427cf56 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -394,7 +394,6 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	dev = alloc_netdev_mqs(sizeof(struct qtnf_vif *), name,
 			       name_assign_type, ether_setup, 1, 1);
 	if (!dev) {
-		memset(&vif->wdev, 0, sizeof(vif->wdev));
 		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 		return -ENOMEM;
 	}
-- 
2.11.0
