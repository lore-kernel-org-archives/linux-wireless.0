Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50077 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaIQEdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 00:33:10 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
Date: Wed, 17 Sep 2014 10:03:42 +0530
Message-Id: <1410928422-25587-1-git-send-email-sujith@msujith.org> (sfid-20140917_063314_454329_F65824C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

With drivers that support multi-channel concurrency,
make sure that the correct context is in use before
sending a deauth frame. The driver could be in a different
context, in which case the frame could be dropped.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2de8870..43332ce 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4606,6 +4606,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			   req->bssid, req->reason_code,
 			   ieee80211_get_reason_code_string(req->reason_code));
 
+		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, tx, frame_buf);
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
-- 
2.1.0

