Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56675 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2EMPHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 11:07:10 -0400
Received: by wibhj8 with SMTP id hj8so913822wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 08:07:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fail authentication when AP denied authentication
Date: Sun, 13 May 2012 18:07:04 +0300
Message-Id: <1336921624-5698-1-git-send-email-eliad@wizery.com> (sfid-20120513_170726_757392_964BA6E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_rx_mgmt_auth() doesn't handle denied authentication
properly - it authenticates the station and waits for association
(for 5 seconds) instead of failing the authentication.

Fix it by destroying auth_data and bailing out instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbd4bd9..2b5235e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1790,7 +1790,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
 		       sdata->name, mgmt->sa, status_code);
-		goto out;
+		ieee80211_destroy_auth_data(sdata, false);
+		return RX_MGMT_CFG80211_RX_AUTH;
 	}
 
 	switch (ifmgd->auth_data->algorithm) {
@@ -1812,7 +1813,6 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	}
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
- out:
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	run_again(ifmgd, ifmgd->auth_data->timeout);
-- 
1.7.6.401.g6a319

