Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00771EB64D7
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Jun 2023 10:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjFUKOV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjFUKOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2023 06:14:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D521FC8
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2023 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687342430; x=1718878430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xtq7L2qDPv07OBpYb9onxo90388/s2qnuqaaYgV0VAE=;
  b=hk5aJFXBe0gsuU43IKNc+6DCiSaumOM76kBil5ah19GBadNnILNejMvf
   dKElXTAmRtlm9BHCMa35oQmuRTlMumUG5/bgYtXJPitd/8s+zXypFAxpt
   +qdv0S+wEn2eFMxFJDzQiqWdLKCm8AW3v9HVGwm6AU8F1JxIj/6B/TOJK
   DVEhLQw4+gL/+p5J8vg46Cel3QIB7Bw7V9nbNu8dzq7kZmgOh6E1BR8IT
   EUtputpOHTO0p2g0RF4kA8bL+gQ8Gb/P1oiU2PfYdBiKOXGJ0ErdSlR/g
   i6+GgRy9HT+QIV+AX87oXWopuFZTW2nQL/A17dLBRX/+gQmIDfYtTdRDZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="446506373"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="446506373"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 03:12:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="664599117"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="664599117"
Received: from ggreenma-mobl2.jer.intel.com ([10.13.17.65])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 03:12:50 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 05/18] wifi: iwlwifi: don't load old firmware for Sc
Date:   Wed, 21 Jun 2023 13:12:09 +0300
Message-Id: <20230621130443.a15e7bf936cb.I68c3c71fda62c837e4da885a42471bf772ac1202@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230621101222.218083-1-gregory.greenman@intel.com>
References: <20230621101222.218083-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is a future product, don't try to load ancient
firmware images for it, they don't exist anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index 296ac689d075..53b2a5969db6 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -13,7 +13,7 @@
 #define IWL_SC_UCODE_API_MAX	82
 
 /* Lowest firmware API version supported */
-#define IWL_SC_UCODE_API_MIN	39
+#define IWL_SC_UCODE_API_MIN	82
 
 /* NVM versions */
 #define IWL_SC_NVM_VERSION		0x0a1d
-- 
2.38.1

