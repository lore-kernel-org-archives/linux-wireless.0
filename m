Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:58857 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaAMUWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:06 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3558009ead.34
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:04 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/18] iwlwifi: mvm: clear ap_ibss_active in case of failure
Date: Mon, 13 Jan 2014 22:21:40 +0200
Message-Id: <1389644517-22807-1-git-send-email-egrumbach@gmail.com> (sfid-20140113_212210_221884_0CDCE965)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The state variable was not set to false in case of a failure to
complete the start_ap_ibss() flow.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 14a974e..2ac3b25 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1012,6 +1012,9 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unbind;
 
+	/* must be set before quota calculations */
+	mvmvif->ap_ibss_active = true;
+
 	ret = iwl_mvm_update_quotas(mvm, vif);
 	if (ret)
 		goto out_rm_bcast;
@@ -1026,6 +1029,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	return 0;
 
 out_rm_bcast:
+	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 out_unbind:
 	iwl_mvm_binding_remove_vif(mvm, vif);
-- 
1.7.9.5

