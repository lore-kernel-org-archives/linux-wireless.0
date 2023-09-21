Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C55E7D0A2
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 19:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjIUTha (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjIUThL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 15:37:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539817B96B
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2023 10:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318643; x=1726854643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tVoQrmfnhoSK2Yw1Szds+cnZ/mg7294DZlsD59Knyps=;
  b=H9rovLqBwsWggD3g0gt0pBOWThGJTFAK6j9CiqCOw5REaRwd3e2Kg8EX
   rGQuV04DgLX45NK17MBxycvu6iiTyyjMpAX7X18rbxTQkx0ez3Yw8e/Ux
   5CJVF17+xk26OVoE36p0dHauO+ZDnA6oDzzki3sQueNHtXXLBhMp8I+ej
   ne09qEP/LbyMSCsqzQozGg5i3TpE85gfc+lxXWL1UnbMXwK20MrwuP6I1
   nzcI13DHPaovtZRueV9SXrJTDTp009k75lZuzh2hoHhPzrZt74U9gHS0O
   2X3+Zx0d1PijJ42cGAUsUzj/nrY16KmfBVnUorLrshhLqPRuL7rLmH4wz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="384305491"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="384305491"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:59:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="740545685"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="740545685"
Received: from rchuwer-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.229.163])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:59:09 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 12/12] wifi: iwlwifi: add mapping of a periphery register crf for WH RF
Date:   Thu, 21 Sep 2023 11:58:10 +0300
Message-Id: <20230921110727.ccfc4868111f.I94dd75fc82443facf571f2fe8e23c50e9053a35a@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230921085810.693048-1-gregory.greenman@intel.com>
References: <20230921085810.693048-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

Add the support for prph register RF details and map it
to get the RF ID of NIC.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 6dd381ff0f9e..6fad5b65a836 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -452,6 +452,7 @@ enum {
 #define REG_CRF_ID_TYPE_FM			0x910
 #define REG_CRF_ID_TYPE_FMI			0x930
 #define REG_CRF_ID_TYPE_FMR			0x900
+#define REG_CRF_ID_TYPE_WHP			0xA10
 
 #define HPM_DEBUG			0xA03440
 #define PERSISTENCE_BIT			BIT(12)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index bc83d2ba55c6..e8687683ff29 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1196,6 +1196,9 @@ static int map_crf_id(struct iwl_trans *iwl_trans)
 	case REG_CRF_ID_TYPE_FMR:
 		iwl_trans->hw_rf_id = (IWL_CFG_RF_TYPE_FM << 12);
 		break;
+	case REG_CRF_ID_TYPE_WHP:
+		iwl_trans->hw_rf_id = (IWL_CFG_RF_TYPE_WH << 12);
+		break;
 	default:
 		ret = -EIO;
 		IWL_ERR(iwl_trans,
-- 
2.38.1

