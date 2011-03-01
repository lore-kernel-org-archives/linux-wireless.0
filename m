Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CAQS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 11:18:27 -0500
Subject: [PATCH] mac80211: make rate control Kconfig warning depend on
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 17:18:26 +0100
Message-ID: <1298996306.6015.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

... Otherwise it is displayed when mac80211 isn't
even turned on, which is completely pointless.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/Kconfig	2011-03-01 17:16:54.000000000 +0100
+++ wireless-testing/net/mac80211/Kconfig	2011-03-01 17:17:00.000000000 +0100
@@ -78,7 +78,7 @@ config MAC80211_RC_DEFAULT
 endif
 
 comment "Some wireless drivers require a rate control algorithm"
-	depends on MAC80211_HAS_RC=n
+	depends on MAC80211 && MAC80211_HAS_RC=n
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"


