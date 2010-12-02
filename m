Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44897 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab0LBUBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 15:01:14 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: remove a redundant check
Date: Thu,  2 Dec 2010 21:01:07 +0100
Message-Id: <1291320068-63275-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_is_nullfunc() implies ieee80211_is_data()

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7948079..f570801 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1067,8 +1067,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr)
 {
-	if (!ieee80211_is_data(hdr->frame_control) &&
-	    !ieee80211_is_nullfunc(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
 	ieee80211_sta_reset_conn_monitor(sdata);
-- 
1.7.3.2

