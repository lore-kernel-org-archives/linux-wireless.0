Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:16996 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3JNXZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 19:25:23 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 2/2] mac80211: store the channel in wdev upon ibss_join
Date: Tue, 15 Oct 2013 00:38:02 +0200
Message-Id: <1381790282-1146-2-git-send-email-antonio@meshcoding.com> (sfid-20131015_012530_069401_40F47D0E)
In-Reply-To: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

To allow cfg80211 to use the real channel to pick up the
proper (i)bss object, store the used channel in
wdev->channel during ibss_join

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a12afe7..2b5aa4b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -331,6 +331,12 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss = cfg80211_inform_bss_width_frame(local->hw.wiphy, chan,
 					      scan_width, mgmt,
 					      presp->head_len, 0, GFP_KERNEL);
+
+	/* store the channel so that it can be used by cfg80211 to retrieve the
+	 * correct bss object
+	 */
+	sdata->wdev.channel = chan;
+
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
-- 
1.8.3.2

