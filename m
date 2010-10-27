Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45179 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376Ab0J0Kks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 06:40:48 -0400
Date: Wed, 27 Oct 2010 13:40:33 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix scan_ies_len to include DS Params
Message-ID: <20101027104033.GA8305@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 651b52254fc061f02d965524e71de4333a009a5a added DS Parameter Set
information into Probe Request frames that are transmitted on 2.4 GHz
band, but it failed to increment local->scan_ies_len to cover this new
information. This variable needs to be updated to match the maximum IE
data length so that the extra buffer need gets reduced from the driver
limit.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- uml.orig/net/mac80211/main.c	2010-10-27 12:56:39.000000000 +0300
+++ uml/net/mac80211/main.c	2010-10-27 12:58:32.000000000 +0300
@@ -677,10 +677,11 @@ int ieee80211_register_hw(struct ieee802
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
-	 * includes the (extended) supported rates and HT
+	 * includes the DS Params, (extended) supported rates, and HT
 	 * information -- SSID is the driver's responsibility.
 	 */
-	local->scan_ies_len = 4 + max_bitrates; /* (ext) supp rates */
+	local->scan_ies_len = 4 + max_bitrates /* (ext) supp rates */ +
+		3 /* DS Params */;
 	if (supp_ht)
 		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
