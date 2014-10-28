Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48741 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753683AbaJ1Ld6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 07:33:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johill@sipsolutions.net
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Date: Tue, 28 Oct 2014 13:33:05 +0200
Message-Id: <1414495985-26937-3-git-send-email-luca@coelho.fi> (sfid-20141028_123402_116818_22D615D1)
In-Reply-To: <1414495985-26937-1-git-send-email-luca@coelho.fi>
References: <1414495985-26937-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211: schedule the actual switch of the station before CSA count 0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Due to the time it takes to process the beacon that started the CSA
process, we may be late for the switch if we try to reach exactly
beacon 0.  To avoid that, use count - 1 when calculating the switch time.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae9f3bd..284ddda 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1195,7 +1195,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(csa_ie.count * cbss->beacon_interval));
+			  TU_TO_EXP_TIME((csa_ie.count - 1) *
+					 cbss->beacon_interval));
 }
 
 static bool
-- 
2.1.1

