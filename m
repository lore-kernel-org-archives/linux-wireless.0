Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43159 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbbCTPY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:24:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: mesh: avoid pointless station lookup
Date: Fri, 20 Mar 2015 16:24:23 +0100
Message-Id: <1426865064-17707-4-git-send-email-johannes@sipsolutions.net> (sfid-20150320_162454_494581_938E993A)
In-Reply-To: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
References: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_build_hdr(), the station is looked up to build the
header correctly (QoS field) and to check for authorization. For
mesh, authorization isn't checked here, and QoS capability is
mandatory, so the station lookup can be avoided.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d6344679bf1..5af35ef35322 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2052,12 +2052,14 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/*
-	 * There's no need to try to look up the destination
-	 * if it is a multicast address (which can only happen
-	 * in AP mode)
+	 * There's no need to try to look up the destination station
+	 * if it is a multicast address. In mesh, there's no need to
+	 * look up the station at all as it always must be QoS capable
+	 * and mesh mode checks authorization later.
 	 */
 	multicast = is_multicast_ether_addr(hdr.addr1);
-	if (!multicast && !have_station) {
+	if (!multicast && !have_station &&
+	    !ieee80211_vif_is_mesh(&sdata->vif)) {
 		sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-- 
2.1.4

