Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946816Ab3BHRZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 07/14] mac80211: fix HT/VHT disable flags
Date: Fri,  8 Feb 2013 18:25:37 +0100
Message-Id: <1360344344-15742-8-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183442_860251_B0B40864)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to disable HT and VHT if VHT was advertised
without VHT is wrong -- it accidentally uses the wrong
flags. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5ac7e52..23c3604 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3587,8 +3587,8 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 			vht_oper = NULL;
 			sdata_info(sdata,
 				   "AP advertised VHT without HT, disabling both\n");
-			sdata->flags |= IEEE80211_STA_DISABLE_HT;
-			sdata->flags |= IEEE80211_STA_DISABLE_VHT;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 		}
 	}
 
-- 
1.8.0

