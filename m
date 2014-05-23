Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45118 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaEWR37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:29:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, cprevotaux@nltinc.com
Subject: [PATCH] mac80211: fix a memory leak on sta rate selection table
Date: Fri, 23 May 2014 19:29:54 +0200
Message-Id: <1400866194-62234-1-git-send-email-nbd@openwrt.org> (sfid-20140523_193007_433251_5C76D62F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@vger.kernel.org
Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/sta_info.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 632d372..8b42f49 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -227,6 +227,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
+	struct ieee80211_sta_rates *rates;
 	int i;
 
 	if (sta->rate_ctrl)
@@ -238,6 +239,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 		kfree(sta->tx_lat);
 	}
 
+	rates = rcu_dereference_protected(sta->sta.rates, true);
+	if (rates)
+		kfree(rates);
+
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
 	kfree(sta);
-- 
1.8.5.2 (Apple Git-48)

