Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34879 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab3CUOsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 10:48:22 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so911944eaj.34
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 07:48:21 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 4/4] iwlwifi: mvm: use ieee80211_noa_attr
Date: Thu, 21 Mar 2013 15:47:57 +0100
Message-Id: <1363877277-5108-4-git-send-email-janusz.dziedzic@gmail.com> (sfid-20130321_155111_182714_13BC9644)
In-Reply-To: <1363877277-5108-1-git-send-email-janusz.dziedzic@gmail.com>
References: <1363877277-5108-1-git-send-email-janusz.dziedzic@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_noa_attr structure while
handling P2P PS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 2779235..1f884b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -669,6 +669,7 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_client(struct iwl_mvm *mvm,
 					   u32 action)
 {
 	struct iwl_mac_ctx_cmd cmd = {};
+	struct ieee80211_p2p_noa_attr *noa = &vif->bss_conf.p2p_noa_attr;
 
 	WARN_ON(vif->type != NL80211_IFTYPE_STATION || !vif->p2p);
 
@@ -678,7 +679,8 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_client(struct iwl_mvm *mvm,
 	/* Fill the data specific for station mode */
 	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.p2p_sta.sta);
 
-	cmd.p2p_sta.ctwin = cpu_to_le32(vif->bss_conf.p2p_ctwindow);
+	cmd.p2p_sta.ctwin = cpu_to_le32(noa->oppps_ctwindow &
+					IEEE80211_P2P_OPPPS_CTWINDOW_MASK);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
@@ -914,6 +916,7 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 				   u32 action)
 {
 	struct iwl_mac_ctx_cmd cmd = {};
+	struct ieee80211_p2p_noa_attr *noa = &vif->bss_conf.p2p_noa_attr;
 
 	WARN_ON(vif->type != NL80211_IFTYPE_AP || !vif->p2p);
 
@@ -924,8 +927,11 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.go.ap,
 				     action == FW_CTXT_ACTION_ADD);
 
-	cmd.go.ctwin = cpu_to_le32(vif->bss_conf.p2p_ctwindow);
-	cmd.go.opp_ps_enabled = cpu_to_le32(!!vif->bss_conf.p2p_oppps);
+	cmd.go.ctwin = cpu_to_le32(noa->oppps_ctwindow &
+					IEEE80211_P2P_OPPPS_CTWINDOW_MASK);
+	cmd.go.opp_ps_enabled =
+			cpu_to_le32(!!(noa->oppps_ctwindow &
+					IEEE80211_P2P_OPPPS_ENABLE_BIT));
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
-- 
1.7.9.5

