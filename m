Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD98E7D24B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Sep 2023 08:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjIZIHt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjIZIHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2023 04:07:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781CAFB
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2023 01:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695715661; x=1727251661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7KPEIfZnZJIEk8vYHWCS6OmFMBaSkBISCdKs5Fp1eEk=;
  b=SzfdYvgX6/AMqmbsQ/4H8rlRYMkrWmCvLPfzTYDbcd5AX/E15UoRiFsf
   VsDlmhonmRrfJEPBW2fHcRv3AX2koREA8HJ+K8O3W3DKeAoTJWcM2MD5J
   UBKYVEbgeqdfFwtY9TB2pi5A+QjauRVdi5UnVADNL6sjEiaBiIHpkanO2
   SuB+RwQGCPKjLw6y4tFXXSMSlDIsj5FtkgMU22LuRDzKdFDZYiFrY7xaP
   dvuk9DCBAdPBj7k18m1AFrrHKh0wZoByO+W/XLfDvUkrPXzYg/vAf1PxF
   cNLDK3+KxDMwmmbOC5FAecDtuwxxq/2fAhCsg5GM0FolK55Lg2KFfE+LX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="467797245"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="467797245"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 01:07:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="698369274"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="698369274"
Received: from nbenitzh-mobl2.ger.corp.intel.com (HELO ggreenma-mobl2.intel.com) ([10.251.178.250])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 01:07:39 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 3/9] wifi: iwlwifi: skip opmode start retries on dead transport
Date:   Tue, 26 Sep 2023 11:07:15 +0300
Message-Id: <20230926110319.9f472069d75d.Ib6684c5b2ea8ed98f082c9b0e9bb2b03c3ea4fe3@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230926080721.876640-1-gregory.greenman@intel.com>
References: <20230926080721.876640-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These retries aren't going to succeed if the device was
deemed dead and needs to be unbound/rebound/... to be
recovered; skip the retries in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index fb5e254757e7..41ae4fae4b8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1429,6 +1429,9 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 		if (op_mode)
 			return op_mode;
 
+		if (test_bit(STATUS_TRANS_DEAD, &drv->trans->status))
+			break;
+
 		IWL_ERR(drv, "retry init count %d\n", retry);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
2.38.1

