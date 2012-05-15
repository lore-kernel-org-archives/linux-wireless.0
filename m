Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60198 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2EOOVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:21:14 -0400
Received: by weyu7 with SMTP id u7so2524649wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:21:13 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: retry auth and assoc on error 17
Date: Tue, 15 May 2012 17:21:16 +0300
Message-Id: <1337091676-29441-1-git-send-email-eliad@wizery.com> (sfid-20120515_162117_536007_AB0D731C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some congested environments APs return
WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA on auth/assoc
attempt. Instead of failing immediately, retry again
in 200 msec.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "mac80211: fail authentication when AP denied authentication"

 net/mac80211/mlme.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2b5235e..6b3ce84 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1790,6 +1790,19 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
 		       sdata->name, mgmt->sa, status_code);
+
+		if (status_code == WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA) {
+			/* can't auth right now, try again in 200 ms */
+			u32 ms = 200;
+			printk(KERN_DEBUG "%s: %pM rejected authentication; "
+			       "try again in %u ms\n",
+			       sdata->name, mgmt->sa, ms);
+			ifmgd->auth_data->timeout = jiffies +
+						    msecs_to_jiffies(ms);
+			run_again(ifmgd, ifmgd->auth_data->timeout);
+			return RX_MGMT_NONE;
+		}
+
 		ieee80211_destroy_auth_data(sdata, false);
 		return RX_MGMT_CFG80211_RX_AUTH;
 	}
@@ -2152,6 +2165,17 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 	}
 
+	if (status_code == WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA) {
+		/* can't assoc us right now, try again in 200 ms */
+		u32 ms = 200;
+		printk(KERN_DEBUG "%s: %pM rejected association; "
+		       "try again in %u ms\n",
+		       sdata->name, mgmt->sa, ms);
+		assoc_data->timeout = jiffies + msecs_to_jiffies(ms);
+		run_again(ifmgd, assoc_data->timeout);
+		return RX_MGMT_NONE;
+	}
+
 	*bss = assoc_data->bss;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
-- 
1.7.6.401.g6a319

