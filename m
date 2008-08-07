Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYHGWuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 18:50:52 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/2] mac80211: change number of pre-assoc scans
Date: Fri,  8 Aug 2008 01:50:46 +0300
Message-Id: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com> (sfid-20080808_005057_722245_9F2BC0CF)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes noticed problem in noisy environments of 50+ APs
that scan fails to find the requested AP on first try, which
leads to connection refusal. second scan has empirically proven to fix
this problem in almost all cases.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |    4 +++-
 net/mac80211/mlme.c        |    9 +++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d19f67e..f71785e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -369,7 +369,9 @@ struct ieee80211_if_sta {
 
 	struct sk_buff_head skb_queue;
 
-	int auth_tries, assoc_tries;
+	int assoc_scan_tries; /* number of scans done pre-association */
+	int auth_tries; /* retries for auth req */
+	int assoc_tries; /* retries for assoc req */
 
 	unsigned long request;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5426df1..5276c73 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -34,6 +34,7 @@
 #include "led.h"
 #include "mesh.h"
 
+#define IEEE80211_ASSOC_SCANS_MAX_TRIES 2
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
@@ -599,6 +600,7 @@ static void ieee80211_set_disassoc(struct net_device *dev,
 {
 	if (deauth)
 		ifsta->auth_tries = 0;
+	ifsta->assoc_scan_tries = 0;
 	ifsta->assoc_tries = 0;
 	ieee80211_set_associated(dev, ifsta, 0);
 }
@@ -3437,7 +3439,9 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,
 		ifsta->auth_alg = WLAN_AUTH_OPEN;
 	ifsta->auth_transaction = -1;
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-	ifsta->auth_tries = ifsta->assoc_tries = 0;
+	ifsta->assoc_scan_tries = 0;
+	ifsta->auth_tries = 0;
+	ifsta->assoc_tries = 0;
 	netif_carrier_off(dev);
 }
 
@@ -3544,7 +3548,8 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
-		if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE) {
+		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
+			ifsta->assoc_scan_tries++;
 			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
 				ieee80211_sta_start_scan(dev, NULL, 0);
 			else
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

