Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E13EB64DA
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbjFNJpq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 05:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbjFNJou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 05:44:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C345E271B
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735834; x=1718271834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2uBa9Pp/VnXmxZ+CjSZQlPD0j/bGGqxqxKbZPWcgTWU=;
  b=TGk4a/1+uaN4Nfp0/S1L4STEeD5732MeDXIk3MmlxLmu62EVTViS2wEa
   n3o1DelRMIXBV7xJYVPLJwOwACXr4nBb55lfkXgkeyyJAXNFGCHjdDdOX
   sti8Au2iQGHjmAuSzTZmOeOsGK8T/suxIPm5H+n5+jJMH1OZ5KHSHszbd
   Ci4O5M2CtTlZcbTp9HD69yTiyWgmVATH0DA17Yz1lgwDrtVL6afyCN4y9
   SJsyNv2ATn2+Ci8oUKIv/LX0hdEhi4uxqswf7PAmyGtBGmLMVVVEUImvY
   UoRqOu6/4c6BTJ7qvqcWbuZxxqCyQBpPrWRvEiNhnJVgRNcI39LrG3Org
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361049874"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361049874"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="711989883"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="711989883"
Received: from basharil-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.203.45])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:42:22 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 13/20] wifi: iwlwifi: mvm: always send spec link ID in link commands
Date:   Wed, 14 Jun 2023 12:41:30 +0300
Message-Id: <20230614123446.daecd0e626f7.I0f8a16a6d80a283c9f947c9bb0fc50a7c6853948@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230614094137.379897-1-gregory.greenman@intel.com>
References: <20230614094137.379897-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The firmware technically only needs this when the link is
newly added, but it's much easier for debugging if it's
always available, so include it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/link.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index af9ace787ec5..563396dfd3cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -245,6 +245,7 @@ int iwl_mvm_link_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd.modify_mask = cpu_to_le32(changes);
 	cmd.flags = cpu_to_le32(flags);
 	cmd.flags_mask = cpu_to_le32(flags_mask);
+	cmd.spec_link_id = link_conf->link_id;
 
 	ret = iwl_mvm_link_cmd_send(mvm, &cmd, FW_CTXT_ACTION_MODIFY);
 	if (!ret && (changes & LINK_CONTEXT_MODIFY_ACTIVE))
@@ -271,6 +272,7 @@ int iwl_mvm_remove_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd.link_id = cpu_to_le32(link_info->fw_link_id);
 	iwl_mvm_release_fw_link_id(mvm, link_info->fw_link_id);
 	link_info->fw_link_id = IWL_MVM_FW_LINK_ID_INVALID;
+	cmd.spec_link_id = link_conf->link_id;
 
 	ret = iwl_mvm_link_cmd_send(mvm, &cmd, FW_CTXT_ACTION_REMOVE);
 
-- 
2.38.1

