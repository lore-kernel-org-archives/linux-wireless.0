Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47109 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab2I3Qat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:30:49 -0400
Message-Id: <20120930163042.322136336@w1.fi> (sfid-20120930_183133_658398_BC39192C)
Date: Sun, 30 Sep 2012 19:29:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 2/4] mac80211: Add debug print on unexpect authentication state
References: <20120930162936.046757966@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful when debugging authentication process issues.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/mlme.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c	2012-09-30 19:16:52.591842581 +0300
+++ wireless-testing/net/mac80211/mlme.c	2012-09-30 19:16:55.831842519 +0300
@@ -1858,8 +1858,13 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
 	if (auth_alg != ifmgd->auth_data->algorithm ||
-	    auth_transaction != ifmgd->auth_data->expected_transaction)
+	    auth_transaction != ifmgd->auth_data->expected_transaction) {
+		sdata_info(sdata, "%pM unexpected authentication state: alg %d (expected %d) transact %d (expected %d)\n",
+			   mgmt->sa, auth_alg, ifmgd->auth_data->algorithm,
+			   auth_transaction,
+			   ifmgd->auth_data->expected_transaction);
 		return RX_MGMT_NONE;
+	}
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",

