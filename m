Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58106 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3LQUpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:32 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so3120441eak.16
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:31 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/36] iwlwifi: mvm: rs: disable MCS9 Tx workaround
Date: Tue, 17 Dec 2013 22:44:36 +0200
Message-Id: <1387313079-28123-33-git-send-email-egrumbach@gmail.com> (sfid-20131217_214550_733794_C64D6A48)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

MCS9 introduces some corner cases in the current rs
algorithm which may lead to non optimal throughput and
instability in the throughput. Until all the corner
cases are resolved disable MCS9 for Tx as a workaround
which yields better throughput results as MCS8 is much
more stable.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 62b29d7..1f06450 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2207,6 +2207,10 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
+			/* Disable MCS9 as a workaround */
+			if (i == IWL_RATE_MCS_9_INDEX)
+				continue;
+
 			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
 			if (i == IWL_RATE_MCS_9_INDEX &&
 			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
@@ -2225,6 +2229,10 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 			if (i == IWL_RATE_9M_INDEX)
 				continue;
 
+			/* Disable MCS9 as a workaround */
+			if (i == IWL_RATE_MCS_9_INDEX)
+				continue;
+
 			/* VHT MCS9 isn't valid for 20Mhz for NSS=1,2 */
 			if (i == IWL_RATE_MCS_9_INDEX &&
 			    sta->bandwidth == IEEE80211_STA_RX_BW_20)
-- 
1.7.9.5

