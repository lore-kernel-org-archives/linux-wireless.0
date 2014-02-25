Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43546 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBYLcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 06:32:32 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so4178261wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 03:32:31 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: don't downgrade VHT20 to HT20
Date: Tue, 25 Feb 2014 12:27:08 +0100
Message-Id: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com> (sfid-20140225_123235_732272_03ECE807)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check led to VHT-capable devices being unable
to pair in VHT20 and were instead paired in HT20.

This improves throughput for VHT20 pairing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
The check was originally introduced in:

e1a0c6b3a4b27ed5f21291d0bbee2167ec201ef5
(mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40)

Was it really necessary to introduce this check?


 net/mac80211/vht.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index e9e36a2..21c7e5b 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -129,10 +129,6 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
-	/* A VHT STA must support 40 MHz */
-	if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-		return;
-
 	vht_cap->vht_supported = true;
 
 	own_cap = sband->vht_cap;
-- 
1.8.5.3

