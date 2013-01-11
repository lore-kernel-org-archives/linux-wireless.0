Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3AKLeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 06:34:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix HT40 connections
Date: Fri, 11 Jan 2013 12:34:25 +0100
Message-Id: <1357904065-11614-1-git-send-email-johannes@sipsolutions.net> (sfid-20130111_123414_306161_A306BB5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My commit 4bf88530be971bf95a7830ca61b4120980bf4347
("mac80211: convert to channel definition struct")
accidentally broke HT40 connections due to swapped
channel flag checks -- fix that.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Tested-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d90c07b1..e930175 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -199,11 +199,11 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	case NL80211_CHAN_WIDTH_40:
 		if (sdata->vif.bss_conf.chandef.chan->center_freq >
 				sdata->vif.bss_conf.chandef.center_freq1 &&
-		    chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+		    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
 			disable_40 = true;
 		if (sdata->vif.bss_conf.chandef.chan->center_freq <
 				sdata->vif.bss_conf.chandef.center_freq1 &&
-		    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+		    chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 			disable_40 = true;
 		break;
 	default:
-- 
1.8.0

