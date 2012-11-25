Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:17476 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753516Ab2KYWZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 17:25:25 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: in ADHOC print debug message for every Auth message
Date: Sun, 25 Nov 2012 23:24:27 +0100
Message-ID: <1353882267-27576-1-git-send-email-antonio@open-mesh.com> (sfid-20121125_232535_288498_085B9BCC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug message has to be printed also for an Auth message with
auth_sequence != 1. This helps understanding whether the two Auth
messages are exchanged correctly or not.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index cc11558..845973b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -374,11 +374,13 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 
-	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
-		return;
 	ibss_dbg(sdata,
 		 "RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
 		 mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
+
+	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
+		return;
+
 	sta_info_destroy_addr(sdata, mgmt->sa);
 	sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
 	rcu_read_unlock();
-- 
1.8.0

