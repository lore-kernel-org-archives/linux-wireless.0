Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:41555 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYCYQF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 12:05:56 -0400
Message-ID: <47E92235.80500@tiscali.nl> (sfid-20080325_160602_111851_66E3EEDB)
Date: Tue, 25 Mar 2008 17:03:01 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from include/linux/ieee80211.h:274:
#define IEEE80211_HT_CAP_SUP_WIDTH              0x0002
---
! has a higher priority than &

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d727de8..6576757 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
 
 	if (sta_ht_inf) {
 		if ((!sta_ht_inf->ht_supported) ||
-		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
 			return 0;
 	}
 
