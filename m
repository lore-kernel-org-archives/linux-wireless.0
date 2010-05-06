Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7111 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab0EFCha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 22:37:30 -0400
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] mac80211: check channel switch mode for future frames transmit
Date: Wed,  5 May 2010 20:34:02 -0700
Message-Id: <1273116842-27189-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1273116842-27189-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1273116842-27189-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Check the mode in channel switch ie for either 0 or 1 on transmission.
A channel switch mode set to 1 means that the STA in a BSS to which the
frame containing the element is addressed shall transmit no further
frames 	within the BSS until the scheduled channel switch.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f50d73f..ef98cac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -437,7 +437,8 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (sw_elem->count <= 1) {
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	} else {
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+		if (sw_elem->mode)
+			ieee80211_stop_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 		mod_timer(&ifmgd->chswitch_timer,
-- 
1.5.6.3

