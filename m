Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbZHDHcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 03:32:55 -0400
Subject: [PATCH v2] cfg80211: clear SSID on disconnect/no connection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Joerg Albert <jal2@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1249311832.4561.2.camel@johannes.local>
References: <1249311832.4561.2.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 09:32:23 +0200
Message-Id: <1249371143.9415.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SME state machine in cfg80211 uses the SSID stored
in struct wireless_dev internally, but fails to clear
it in multiple places (when giving up on a connection
attempt and when disconnecting). This doesn't matter to
the SME state machine, but does matter for IBSS. Thus,
in those cases, clear the SSID to avoid messing up the
IBSS state machine.

Reported-by: Joerg Albert <jal2@gmx.de>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/net/wireless/sme.c	2009-08-03 23:12:36.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-04 09:28:16.000000000 +0200
@@ -383,6 +383,7 @@ void __cfg80211_connect_result(struct ne
 		wdev->conn = NULL;
 		kfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
+		wdev->ssid_len = 0;
 		return;
 	}
 
@@ -550,6 +551,7 @@ void __cfg80211_disconnected(struct net_
 
 	wdev->current_bss = NULL;
 	wdev->sme_state = CFG80211_SME_IDLE;
+	wdev->ssid_len = 0;
 
 	if (wdev->conn) {
 		kfree(wdev->conn->ie);
@@ -705,6 +707,7 @@ int __cfg80211_connect(struct cfg80211_r
 			wdev->conn = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
 			wdev->connect_keys = NULL;
+			wdev->ssid_len = 0;
 		}
 
 		return err;
@@ -769,6 +772,7 @@ int __cfg80211_disconnect(struct cfg8021
 			wdev->sme_state = CFG80211_SME_IDLE;
 			kfree(wdev->conn);
 			wdev->conn = NULL;
+			wdev->ssid_len = 0;
 			return 0;
 		}
 


