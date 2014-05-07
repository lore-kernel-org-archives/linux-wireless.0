Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54617 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEGTyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:10 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so5926276wiw.14
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:54:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/23] iwlwifi: mvm: rs: enable MCS9 for Tx
Date: Wed,  7 May 2014 22:53:00 +0300
Message-Id: <1399492380-12050-23-git-send-email-egrumbach@gmail.com> (sfid-20140507_222145_030836_7004DF50)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

After fixes to the rs algorithm reenable MCS9.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6d5af48..10ad1dc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2440,10 +2440,6 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
-			/* Disable MCS9 as a workaround */
-			if (i == IWL_RATE_MCS_9_INDEX)
-				continue;
-
 			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
 			if (i == IWL_RATE_MCS_9_INDEX &&
 			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
@@ -2462,10 +2458,6 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
-			/* Disable MCS9 as a workaround */
-			if (i == IWL_RATE_MCS_9_INDEX)
-				continue;
-
 			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
 			if (i == IWL_RATE_MCS_9_INDEX &&
 			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
-- 
1.8.3.2

