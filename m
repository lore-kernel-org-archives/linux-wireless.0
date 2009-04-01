Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54199 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764234AbZDAOYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 10:24:13 -0400
Date: Wed, 1 Apr 2009 17:23:54 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Report rejected association to user space SME
Message-ID: <20090401142354.GA8695@jm.kir.nu> (sfid-20090401_162417_433906_F94231EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using nl80211 association, we need to send association response
with a failure code to user space SME instead of just internally
trying to send out the same (re)association request again couple of
times. This fixes problems in association process getting stuck on a
failure when user space is not notified in any way that something
actually failed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    5 +++++
 1 file changed, 5 insertions(+)

--- uml.orig/net/mac80211/mlme.c	2009-04-01 17:20:11.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-04-01 17:21:15.000000000 +0300
@@ -1363,6 +1363,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 		 * association next time. This works around some broken APs
 		 * which do not correctly reject reassociation requests. */
 		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
+		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
+			/* Wait for SME to decide what to do next */
+			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		}
 		return;
 	}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
