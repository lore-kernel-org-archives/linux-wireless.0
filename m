Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2FGMrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 08:47:25 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.5] mac80211: add back channel change flag
Date: Thu,  7 Jun 2012 14:47:21 +0200
Message-Id: <1339073241-3090-1-git-send-email-sgruszka@redhat.com> (sfid-20120607_144728_340866_AE775F01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 24398e39c8ee4a9d9123eed322b859ece4d16cac
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Mar 28 10:58:36 2012 +0200

    mac80211: set HT channel before association

removed IEEE80211_CONF_CHANGE_CHANNEL argument from ieee80211_hw_config,
which is required by iwl4965 driver, otherwise that driver does not
configure channel properly and is not able to associate.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 04c3063..b5fb5e1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3106,7 +3106,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	}
 
 	local->oper_channel = cbss->channel;
-	ieee80211_hw_config(local, 0);
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	if (!have_sta) {
 		u32 rates = 0, basic_rates = 0;
-- 
1.7.1

