Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C683BC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9DF21850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbeLSJgl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 04:36:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:60157 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbeLSJgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 04:36:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 01:36:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="303418501"
Received: from egrumbac-mobl1.jer.intel.com ([10.12.117.14])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2018 01:36:38 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     sara.sharon@intel.com, sfr@canb.auug.org.au, kvalo@codeaurora.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] iwlwifi: dbg_ini: fix bad ini tlv parsing
Date:   Wed, 19 Dec 2018 11:36:19 +0200
Message-Id: <20181219093619.9867-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.14.4
In-Reply-To: <20181219092922.8021-1-emmanuel.grumbach@intel.com>
References: <20181219092922.8021-1-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add a break at the end of the ini tlv case.
Fix both the internal and external tlv parsing.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: remove our internal tags
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index bc1e4d4bb42d..43d815cb3ce9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -201,6 +201,7 @@ static int iwl_parse_fw_dbg_tlv(struct iwl_trans *trans, const u8 *data,
 		case IWL_UCODE_TLV_TYPE_TRIGGERS:
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			iwl_fw_dbg_copy_tlv(trans, tlv, true);
+			break;
 		default:
 			WARN_ONCE(1, "Invalid TLV %x\n", tlv_type);
 			break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a65ba955783d..bf1be985f36b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1097,6 +1097,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			if (iwlwifi_mod_params.enable_ini)
 				iwl_fw_dbg_copy_tlv(drv->trans, tlv, false);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
-- 
2.14.4

