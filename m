Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbYHOCEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:55 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/15] mac80211: change number of pre-assoc scans
Date: Fri, 15 Aug 2008 10:01:14 +0800
Message-Id: <1218765680-8378-10-git-send-email-yi.zhu@intel.com> (sfid-20080815_040459_672500_3DBDE9FB)
In-Reply-To: <1218765680-8378-9-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-6-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-8-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes noticed problem in noisy environments of 50+ APs.
That scan fails to find the requested AP on first try, which leads
to connection refusal. Second scan has empirically proven to fix
this problem in almost all cases.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
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
index 784ccd5..e1368f6 100644
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
1.5.3.6

