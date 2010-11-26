Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57001 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab0KZTZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 14:25:05 -0500
Date: Fri, 26 Nov 2010 20:41:55 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix frame injection using non-AP vif
Message-ID: <20101126184155.GA2689@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order for frame injection to work properly for some use cases
(e.g., finding the station entry and keys for encryption), mac80211
needs to find the correct sdata entry. This works when the main vif
is in AP mode, but commit a2c1e3dad516618cb0fbfb1a62c36d0b0744573a
broke this particular use case for station main vif. While this type of
injection is quite unusual operation, it has some uses and we should fix
it. Do this by changing the monitor vif sdata selection to allow station
vif to be selected instead of limiting it to just AP vifs. We still need
to skip some iftypes to avoid selecting unsuitable vif for injection.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/tx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-11-26 20:21:02.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-11-26 20:36:22.000000000 +0200
@@ -1595,7 +1595,12 @@ static void ieee80211_xmit(struct ieee80
 						list) {
 				if (!ieee80211_sdata_running(tmp_sdata))
 					continue;
-				if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
+				if (tmp_sdata->vif.type ==
+				    NL80211_IFTYPE_MONITOR ||
+				    tmp_sdata->vif.type ==
+				    NL80211_IFTYPE_AP_VLAN ||
+					tmp_sdata->vif.type ==
+				    NL80211_IFTYPE_WDS)
 					continue;
 				if (compare_ether_addr(tmp_sdata->vif.addr,
 						       hdr->addr2) == 0) {

-- 
Jouni Malinen                                            PGP id EFC895FA
