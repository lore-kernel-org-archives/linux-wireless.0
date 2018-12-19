Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955A8C43444
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E6021852
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbeLSIa7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:30:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:6101 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbeLSIa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 03:30:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 00:30:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="129083805"
Received: from egrumbac-mobl1.jer.intel.com ([10.12.117.14])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2018 00:30:56 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     sara.sharon@intel.com, sfr@canb.auug.org.au, kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: add missing break / fall-through in switch cases
Date:   Wed, 19 Dec 2018 10:30:53 +0200
Message-Id: <20181219083053.17530-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Two switch cases that were added recently missed break
statement and explicit fall-through. Fix this.

Fixes: f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 5 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index bc1e4d4bb42d..b05fe75394fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -196,11 +196,16 @@ static int iwl_parse_fw_dbg_tlv(struct iwl_trans *trans, const u8 *data,
 
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_HCMD:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_REGIONS:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_TRIGGERS:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			iwl_fw_dbg_copy_tlv(trans, tlv, true);
+			break;
 		default:
 			WARN_ONCE(1, "Invalid TLV %x\n", tlv_type);
 			break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a65ba955783d..db95cb81c67d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1091,12 +1091,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			break;
 			}
 		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_HCMD:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_REGIONS:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_TRIGGERS:
+		/* fall-through */
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			if (iwlwifi_mod_params.enable_ini)
 				iwl_fw_dbg_copy_tlv(drv->trans, tlv, false);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
-- 
2.14.4

