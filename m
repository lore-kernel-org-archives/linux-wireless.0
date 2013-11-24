Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43378 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3KXUH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:26 -0500
Received: by mail-wi0-f173.google.com with SMTP id hm4so2718456wib.12
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:25 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/29] iwlwifi: mvm: don't enable VHT MCS9 in 20Mhz
Date: Sun, 24 Nov 2013 22:06:45 +0200
Message-Id: <1385323606-3603-28-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_448040_B83C6C7B)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

MCS9 in NSS=1 or NSS=2 isn't valid for 20Mhz so don't enable
it in case we're dealing with a 20Mhz sta. Trying to configure an
MCS9 rate with 20Mhz in the LQ rate table would lead to a FW assert.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 9565260..f1364b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2241,6 +2241,11 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
+			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
+			if (i == IWL_RATE_MCS_9_INDEX &&
+			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
+				continue;
+
 			lq_sta->active_siso_rate |= BIT(i);
 		}
 	}
@@ -2251,6 +2256,11 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
+			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
+			if (i == IWL_RATE_MCS_9_INDEX &&
+			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
+				continue;
+
 			lq_sta->active_mimo2_rate |= BIT(i);
 		}
 	}
-- 
1.7.9.5

