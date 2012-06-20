Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44994 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FTKKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:10:24 -0400
Received: by weyu7 with SMTP id u7so5102104wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 03:10:23 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Vitaly Wool <vitalywool@gmail.com>,
	Luciano Coelho <coelho@ti.com>
Subject: [PATCH] mac80211: fix cleanup if driver suspend callback fails
Date: Wed, 20 Jun 2012 13:10:14 +0300
Message-Id: <1340187014-11269-1-git-send-email-eyal@wizery.com> (sfid-20120620_121028_492605_E3588EFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case the driver suspend callback fails, mac80211 is left
with stopped queues which prevents any further traffic as well
as all STAs are left marked with WLAN_STA_BLOCK_BA which will
cause any further ADDBA requests to be declined. Fix it by
undoing both before returning from __iee80211_suspend.

Reported-by: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
---

This was discussed in this thread:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/89571
but no v2 was submitted. We've had this patch applied
on our internal tree for a while so here it is.

 net/mac80211/pm.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 98c128b..5c572e7 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -78,6 +78,16 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		if (err < 0) {
 			local->quiescing = false;
 			local->wowlan = false;
+			if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+				mutex_lock(&local->sta_mtx);
+				list_for_each_entry(sta,
+						    &local->sta_list, list) {
+					clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
+				}
+				mutex_unlock(&local->sta_mtx);
+			}
+			ieee80211_wake_queues_by_reason(hw,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
-- 
1.7.4.1

