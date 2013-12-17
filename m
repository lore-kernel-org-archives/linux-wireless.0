Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59970 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3LQUpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:31 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3160763eaj.12
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/36] iwlwifi: mvm: Do not allow AP MAC context update if not active
Date: Tue, 17 Dec 2013 22:44:35 +0200
Message-Id: <1387313079-28123-32-git-send-email-egrumbach@gmail.com> (sfid-20131217_214558_531976_301B1DBF)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Fix a regression introduced in "iwlwifi: mvm: fix ht protection flags"
where an AP/IBSS MAC context could have been updated even before the
context was added to the FW. This fix avoids the following warning:

WARNING: ... at .../drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1132
    iwl_mvm_mac_ctxt_changed+0x75/0x90 [iwlmvm]()
Changing inactive MAC 0c:8b:fd:01:1a:30/3
Modules linked in: [...]
Call Trace:
[<c16041fd>] dump_stack+0x41/0x52
[<c1041074>] warn_slowpath_common+0x84/0xa0
[<f80d8f45>] ? iwl_mvm_mac_ctxt_changed+0x75/0x90 [iwlmvm]
[<f80d8f45>] ? iwl_mvm_mac_ctxt_changed+0x75/0x90 [iwlmvm]
[<c1041133>] warn_slowpath_fmt+0x33/0x40
[<f80d8f45>] iwl_mvm_mac_ctxt_changed+0x75/0x90 [iwlmvm]
[<f80d517a>] iwl_mvm_bss_info_changed+0x22a/0x4b0 [iwlmvm]
[<c160831d>] ? mutex_unlock+0xd/0x10
[<f80d4678>] ? iwl_mvm_configure_filter+0x58/0x70 [iwlmvm]
[<f80d4f50>] ? iwl_mvm_mac_tx+0xc0/0xc0 [iwlmvm]
[<f8132d83>] ieee80211_bss_info_change_notify+0xa3/0x1d0 [mac80211]
[<f8149247>] ? ieee80211_del_virtual_monitor+0x127/0x1f0 [mac80211]
[<f8149cac>] ieee80211_do_open+0x12c/0xeb0 [mac80211]
[<c106c6de>] ? __raw_notifier_call_chain+0x1e/0x30
[<c106c70f>] ? raw_notifier_call_chain+0x1f/0x30
[<f814aa8d>] ieee80211_open+0x5d/0x60 [mac80211]
[<c1500c7b>] __dev_open+0xab/0x140
[<c160b39a>] ? _raw_spin_unlock_bh+0x2a/0x30
[<c1500f41>] __dev_change_flags+0x81/0x160
[<c10ab6fc>] ? __lock_is_held+0x3c/0x60
[<c15010d1>] dev_change_flags+0x21/0x60

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reported-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 272aabd..b61d5a2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1053,11 +1053,16 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 				 struct ieee80211_bss_conf *bss_conf,
 				 u32 changes)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	enum ieee80211_bss_change ht_change = BSS_CHANGED_ERP_CTS_PROT |
 					      BSS_CHANGED_HT |
 					      BSS_CHANGED_BANDWIDTH;
 	int ret;
 
+	/* Changes will be applied when the AP/IBSS is started */
+	if (!mvmvif->ap_ibss_active)
+		return;
+
 	if (changes & ht_change) {
 		ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
 		if (ret)
-- 
1.7.9.5

