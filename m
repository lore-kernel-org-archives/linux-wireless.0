Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC9BC77B79
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 10:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjDNKMd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 06:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjDNKM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 06:12:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3801FFD
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 03:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681467143; x=1713003143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MA67ytfhR0K3GVI5vrawlY1nmiZWsS555uk6f2KWCbE=;
  b=XBtgevxDfooDs38KcPlyrctQP71ApiKTc15nfpr+ylMQayjWMxVoAXfK
   0DAu7Mpnt2+w1UzEfY7AHcEk4f0RtCM+rebiwgnNS2RqYc2lXMlQvoqvs
   cH7+dF93KsWBUCmxu78uXH0N7IySA//wHkoJPNz0b0+5VS7LXVZN+9cLJ
   5mHoXzUvsIbN57gBxt+OxYIAEdmhE8FUJowOL+YB6+rUpbsyePijIB7Wn
   vfCmKXQ+sCoG51JAQaIb3HC8nvn7SJpJKnTL+iXylZlwu+IBPQZ6XMg71
   hzXqL6EZjlAZP1Ni3UZYPOHVcnyrXIWghWffcm93WL3lJH7qq3Tb/OWGn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346263546"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="346263546"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 03:12:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="692351594"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="692351594"
Received: from yalankry-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.233.156])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 03:12:21 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 02/15] wifi: iwlwifi: add a new PCI device ID for BZ device
Date:   Fri, 14 Apr 2023 13:11:53 +0300
Message-Id: <20230414130637.56342664110d.I5aa6f2858fdcf69fdea4f1a873115a48bd43764e@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230414101206.1170180-1-gregory.greenman@intel.com>
References: <20230414101206.1170180-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

Add support for a new PCI device ID 0x272b once registering with PCIe.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fb0c2c0f236f..31b575f35410 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -504,6 +504,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* Bz devices */
 	{IWL_PCI_DEVICE(0x2727, PCI_ANY_ID, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_trans_cfg)},
 #endif /* CONFIG_IWLMVM */
-- 
2.38.1

