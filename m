Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933652AbeE2MAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:48 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 9/9] qtnfmac: fix invalid STA state on EAPOL failure
Date: Tue, 29 May 2018 15:00:05 +0300
Message-Id: <20180529120005.21498-10-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140101_502153_6C80EBEB)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver switches vif sta_state into QTNF_STA_CONNECTING when cfg80211
core initiates connect procedure. Further this state is changed either
to QTNF_STA_CONNECTED or to QTNF_STA_DISCONNECTED by BSS_JOIN and
BSS_LEAVE events from firmware. However it is possible that no such
events will be sent by firmware, e.g. if EAPOL timed out.

In this case vif sta_mode will remain in QTNF_STA_CONNECTING state and
all subsequent connection attempts will fail with -EBUSY error code.
Fix this by perfroming STA state transition from QTNF_STA_CONNECTING
to QTNF_STA_DISCONNECTED in cfg80211 disconnect callback.
No need to rely upon firmware events in this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 21 ++++++++++++++-------
 drivers/net/wireless/quantenna/qtnfmac/event.c    |  8 +++-----
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 1fcd94bf7c59..220e2b710208 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -649,30 +649,37 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct qtnf_vif *vif;
-	int ret;
+	int ret = 0;
 
 	vif = qtnf_mac_get_base_vif(mac);
 	if (!vif) {
 		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out;
 	}
 
-	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	qtnf_scan_done(mac, true);
 
 	if (vif->sta_state == QTNF_STA_DISCONNECTED)
-		return 0;
+		goto out;
 
 	ret = qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
 		       vif->vifid);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	if (vif->sta_state == QTNF_STA_CONNECTING)
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+
+	return ret;
 }
 
 static int
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 16617c44f81b..68da81bec4e9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -211,11 +211,9 @@ qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
 		return -EPROTO;
 	}
 
-	if (vif->sta_state != QTNF_STA_CONNECTED) {
-		pr_err("VIF%u.%u: BSS_LEAVE event when STA is not connected\n",
-		       vif->mac->macid, vif->vifid);
-		return -EPROTO;
-	}
+	if (vif->sta_state != QTNF_STA_CONNECTED)
+		pr_warn("VIF%u.%u: BSS_LEAVE event when STA is not connected\n",
+			vif->mac->macid, vif->vifid);
 
 	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
 
-- 
2.11.0
