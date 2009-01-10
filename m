Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42356 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbZAJJrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 04:47:07 -0500
Date: Sat, 10 Jan 2009 11:46:53 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Mark ieee80211_process_sa_query_req() static
Message-ID: <20090110094653.GA5217@jm.kir.nu> (sfid-20090110_104712_611217_AF971207)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is only used within rx.c, so mark it static.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 net/mac80211/rx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-10 11:39:35.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-01-10 11:40:08.000000000 +0200
@@ -1675,9 +1675,9 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 	return RX_CONTINUE;
 }
 
-void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
-				    struct ieee80211_mgmt *mgmt,
-				    size_t len)
+static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_mgmt *mgmt,
+					   size_t len)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;

-- 
Jouni Malinen                                            PGP id EFC895FA
