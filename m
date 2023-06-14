Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6709EB64D9
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 09:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbjFNJph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 05:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244258AbjFNJoi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 05:44:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232CA1FC8
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 02:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735799; x=1718271799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=49sfTHTEHroSKe7ZnRAv7fUyYGbPbhjN3syiSGFoZjk=;
  b=CNt5i6RshzTn9WtQYDaab6bWum13Ry93JKCme2Z4WLreobZkomRozz9H
   16/3j//cFVtGQBVmKruRhxg3dH2Y83pwNbZl+0/f7wWZ/LcjpWOC9ndcD
   zIh0exJgcpNj5zePumHnfi6JJGECMZhpveePxvh0Y7DDFxe97Ng32WSay
   xR7Qugo5ZonO5IQMW3w9x9nPs2OIRea4RPGgdBTrmWiN5A1SU8Bwqex6V
   B99a8Q696Yd8LGnxga2mnFxgj+Q5O/N6QP9rNkUSoTDmfCxu5aPtinvak
   /0OOxUxcABvXj7jT5y6Mj09VQMFjbV1pNRM6yUyJeo7raK9OtHzi1uYFG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361049823"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361049823"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="711989806"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="711989806"
Received: from basharil-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.203.45])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:42:02 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 04/20] wifi: iwlwifi: mvm: use iwl_mvm_is_vendor_in_approved_list()
Date:   Wed, 14 Jun 2023 12:41:21 +0300
Message-Id: <20230614123446.f3741f5cdef4.I5e0bf522189dc595ee38d05e93994211d32ec0f4@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230614094137.379897-1-gregory.greenman@intel.com>
References: <20230614094137.379897-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We have this helper now instead of open-coding the check for
the dmi_tas_approved_list, so use it even here. It was added
for debugfs use, but it's better to be consistent.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index ed9370aac1b6..8d8277d94f56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1182,7 +1182,7 @@ static void iwl_mvm_tas_init(struct iwl_mvm *mvm)
 	if (ret == 0)
 		return;
 
-	if (!dmi_check_system(dmi_tas_approved_list)) {
+	if (!iwl_mvm_is_vendor_in_approved_list()) {
 		IWL_DEBUG_RADIO(mvm,
 				"System vendor '%s' is not in the approved list, disabling TAS in US and Canada.\n",
 				dmi_get_system_info(DMI_SYS_VENDOR));
-- 
2.38.1

