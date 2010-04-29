Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626Ab0D3SIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:41 -0400
Subject: [PATCH] mac80211: tell driver about IBSS merge
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1272532707.3736.14.camel@jlt3.sipsolutions.net>
References: <1272469243.3565.27.camel@jlt3.sipsolutions.net>
	 <1272532707.3736.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 21:34:01 +0200
Message-ID: <1272569641.27378.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch "mac80211: notify driver about
IBSS status" left a problem -- when we merge with
a new BSSID, we never tell the driver that we left
the old one. Fix that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Incremental patch since you already have the other one.

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -92,6 +92,12 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (memcmp(ifibss->bssid, bssid, ETH_ALEN))
 		sta_info_flush(sdata->local, sdata);
 
+	/* if merging, indicate to driver that we leave the old IBSS */
+	if (sdata->vif.bss_conf.ibss_joined) {
+		sdata->vif.bss_conf.ibss_joined = false;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
+	}
+
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;


