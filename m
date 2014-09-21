Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:61314 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIUTWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:36 -0400
Received: by mail-we0-f171.google.com with SMTP id k48so1913029wev.2
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/17] iwlwifi: mvm: Allow schedule scan while connected
Date: Sun, 21 Sep 2014 22:22:08 +0300
Message-Id: <1411327338-23099-7-git-send-email-egrumbach@gmail.com> (sfid-20140921_212240_827148_B3BA31DD)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

In the past when schedule scan was started while connected on one of
interfaces FW crashes were observed. In the newest FW this issue is
solved, so remove limitaion after examining corresponding TLV flag.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bd12f8e..412a8a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2152,7 +2152,13 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!iwl_mvm_is_idle(mvm)) {
+	/* Newest FW fixes sched scan while connected on another interface */
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) {
+		if (!vif->bss_conf.idle) {
+			ret = -EBUSY;
+			goto out;
+		}
+	} else if (!iwl_mvm_is_idle(mvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
-- 
1.9.1

