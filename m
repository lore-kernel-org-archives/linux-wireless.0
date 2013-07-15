Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab3GOLqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:46:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 3.9 1/4] iwlwifi: mvm: don't use cts to self
Date: Mon, 15 Jul 2013 14:46:41 +0300
Message-Id: <1373888804-3077-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_134654_038592_A0DE3BB5)
In-Reply-To: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

commit cc7ee2bab3d90b0a09651dcfa2d0c9ec1a115bc8  upstream.

The current fw doesn't currently support cts to self. There
is a bug in the fw that prevents us from using cts to self.
Use full protection (including RTS) for now.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index bf76b17..864cd6d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -553,9 +553,9 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
+	/* Don't use cts to self as the fw doesn't support it currently. */
 	if (vif->bss_conf.use_cts_prot)
-		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT |
-						     MAC_PROT_FLG_SELF_CTS_EN);
+		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
 
 	/*
 	 * I think that we should enable these 2 flags regardless the HT PROT
-- 
1.7.10.4

