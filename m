Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51901 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaE0UeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:34:02 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, cprevotaux@nltinc.com
Subject: [PATCH v2] mac80211: fix a memory leak on sta rate selection table
Date: Tue, 27 May 2014 22:33:57 +0200
Message-Id: <1401222837-93492-1-git-send-email-nbd@openwrt.org> (sfid-20140527_223406_969440_FDC57A31)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
Fixes: 0d528d85c5
Cc: stable@vger.kernel.org # v3.10+
---
 net/mac80211/sta_info.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 632d372..3f26740 100644
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
 
+	rates = rcu_dereference_raw(sta->sta.rates);
+	if (rates)
+		kfree(rates);
+
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
 	kfree(sta);
-- 
1.8.5.2 (Apple Git-48)

