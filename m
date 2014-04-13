Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:64650 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:34 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so7124809wes.26
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/47] iwlwifi: mvm: don't set AP STA to EINVAL
Date: Sun, 13 Apr 2014 22:19:31 +0300
Message-Id: <1397416802-32403-16-git-send-email-egrumbach@gmail.com> (sfid-20140413_212040_508099_317EF3A3)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Now that mac80211 calls pre_rcu_remove and we set the
fw_id_to_mac_id pointer to -ENOENT before the station is
removed, we don't need to set fw_id_to_mac_id to -EINVAL
when the station is really removed.
Leave fw_id_to_mac_id to be -ENOENT which will let the
drain worker (iwl_mvm_sta_drained_wk) know that this station
is not to be drained.
We don't need to drain this station since it is our AP in
managed mode and we flush all its frames synchronously
anyway.

Setting the AP station to -EINVAL could lead to confusion
since internal stations are also reserved with -EINVAL,
this confusion showed up in the logs as:

Drained sta 0, but it is internal?

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index f339ef8..eb3e4bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -520,14 +520,6 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		/* flush its queues here since we are freeing mvm_sta */
 		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, true);
 
-		/*
-		 * Put a non-NULL since the fw station isn't removed.
-		 * It will be removed after the MAC will be set as
-		 * unassoc.
-		 */
-		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
-				   ERR_PTR(-EINVAL));
-
 		/* if we are associated - we can't remove the AP STA now */
 		if (vif->bss_conf.assoc)
 			return ret;
-- 
1.8.3.2

