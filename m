Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0LISwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:52:09 -0500
Message-Id: <20101209185002.570182039@sipsolutions.net>
Date: Thu, 09 Dec 2010 19:49:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: clean up RX key checks
References: <20101209184859.155955840@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using the default key for "any key set" isn't
quite what we should do. It works, but with the
upcoming changes it makes life unnecessarily
complex, so do something better here and really
check for "any key".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-12-05 18:09:51.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-12-05 18:09:52.000000000 +0100
@@ -955,12 +955,31 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 * have been expected.
 		 */
 		struct ieee80211_key *key = NULL;
+		struct ieee80211_sub_if_data *sdata = rx->sdata;
+		int i;
+
 		if (ieee80211_is_mgmt(fc) &&
 		    is_multicast_ether_addr(hdr->addr1) &&
 		    (key = rcu_dereference(rx->sdata->default_mgmt_key)))
 			rx->key = key;
-		else if ((key = rcu_dereference(rx->sdata->default_key)))
-			rx->key = key;
+		else {
+			if (rx->sta) {
+				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+					key = rcu_dereference(rx->sta->gtk[i]);
+					if (key)
+						break;
+				}
+			}
+			if (!key) {
+				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+					key = rcu_dereference(sdata->keys[i]);
+					if (key)
+						break;
+				}
+			}
+			if (key)
+				rx->key = key;
+		}
 		return RX_CONTINUE;
 	} else {
 		u8 keyid;


