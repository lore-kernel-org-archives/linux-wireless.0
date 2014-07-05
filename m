Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35628 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbaGETd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 15:33:56 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so102626wgh.6
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 12:33:55 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: mvm: Fix broadcast filtering
Date: Sat,  5 Jul 2014 22:33:47 +0300
Message-Id: <1404588829-14168-1-git-send-email-egrumbach@gmail.com> (sfid-20140705_213359_359281_B3C02A74)
In-Reply-To: <53B852D4.5060109@gmail.com>
References: <53B852D4.5060109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Current code did not allow sending the broadcast filtering command
for P2P Client interfaces. However, this was not enough, since once
broadcast filtering command was issued over the station interface
after the P2P Client connected, the command also attached the filters
to the P2P Client MAC which is not allowed (FW ASSERT 1063).

Fix this skipping P2P Client interfaces when constructing the broadcast
filtering command

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: ArikX Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1cef708..9bfb906 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1166,8 +1166,12 @@ static void iwl_mvm_bcast_filter_iterator(void *_data, u8 *mac,
 
 	bcast_mac = &cmd->macs[mvmvif->id];
 
-	/* enable filtering only for associated stations */
-	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc)
+	/*
+	 * enable filtering only for associated stations, but not for P2P
+	 * Clients
+	 */
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p ||
+	    !vif->bss_conf.assoc)
 		return;
 
 	bcast_mac->default_discard = 1;
@@ -1244,10 +1248,6 @@ static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
 		return 0;
 
-	/* bcast filtering isn't supported for P2P client */
-	if (vif->p2p)
-		return 0;
-
 	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
 		return 0;
 
-- 
1.8.3.2

