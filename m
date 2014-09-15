Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33070 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaIOFNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:37 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so3447162wiv.7
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/28] iwlwifi: mvm: reduce active dwell time
Date: Mon, 15 Sep 2014 08:12:54 +0300
Message-Id: <1410757980-2138-22-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_554663_00176BB5)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Reduce basic active dwell time from 30 ms on 2.4 GHz and 20 on 5.2 to
20 on 2.4 and 10 on 5.2.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index bf9c63d..09545f2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -160,8 +160,8 @@ static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
 static u16 iwl_mvm_get_active_dwell(enum ieee80211_band band, int n_ssids)
 {
 	if (band == IEEE80211_BAND_2GHZ)
-		return 30  + 3 * (n_ssids + 1);
-	return 20  + 2 * (n_ssids + 1);
+		return 20  + 3 * (n_ssids + 1);
+	return 10  + 2 * (n_ssids + 1);
 }
 
 static u16 iwl_mvm_get_passive_dwell(enum ieee80211_band band)
-- 
1.9.1

