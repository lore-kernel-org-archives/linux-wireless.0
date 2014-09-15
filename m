Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41362 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaIOFNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:14 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so3233560wgh.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/28] iwlwifi: mvm: reset ucode_loaded flag when mac80211 stop is called
Date: Mon, 15 Sep 2014 08:12:38 +0300
Message-Id: <1410757980-2138-6-git-send-email-egrumbach@gmail.com> (sfid-20140915_073113_674946_882E4DEC)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We rely on the value of the mvm->ucode_loaded flag to decide whether
or not we can perform certain operations (e.g. access to some debugfs
entries), so we need to reset it when the mac80211 stop operation is
called and the hardware is shutdown.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 069bb8e..bcfb03c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -890,6 +890,8 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	/* the fw is stopped, the aux sta is dead: clean up driver state */
 	iwl_mvm_del_aux_sta(mvm);
 
+	mvm->ucode_loaded = false;
+
 	mutex_unlock(&mvm->mutex);
 
 	/*
-- 
1.9.1

