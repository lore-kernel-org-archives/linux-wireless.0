Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF9FC433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99753230FC
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAVMyO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Jan 2021 07:54:14 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41654 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727471AbhAVMyB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jan 2021 07:54:01 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l2vvj-003vnH-Rh; Fri, 22 Jan 2021 14:52:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Jan 2021 14:52:40 +0200
Message-Id: <iwlwifi.20210122144849.bddbf9b57a75.I16e09e2b1404b16bfff70852a5a654aa468579e2@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122125242.107146-1-luca@coelho.fi>
References: <20210122125242.107146-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH for v5.11 5/7] iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matti Gottlieb <matti.gottlieb@intel.com>

The bit that indicates if the device supports 160MHZ
is bit #9. The macro checks bit #8.

Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Fixes: d6f2134a3831 ("iwlwifi: add mac/rf types and 160MHz to the device tables")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 4826f5575dae..86e1d57df65e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #ifndef __IWL_CONFIG_H__
@@ -445,7 +445,7 @@ struct iwl_cfg {
 #define IWL_CFG_CORES_BT_GNSS		0x5
 
 #define IWL_SUBDEVICE_RF_ID(subdevice)	((u16)((subdevice) & 0x00F0) >> 4)
-#define IWL_SUBDEVICE_NO_160(subdevice)	((u16)((subdevice) & 0x0100) >> 9)
+#define IWL_SUBDEVICE_NO_160(subdevice)	((u16)((subdevice) & 0x0200) >> 9)
 #define IWL_SUBDEVICE_CORES(subdevice)	((u16)((subdevice) & 0x1C00) >> 10)
 
 struct iwl_dev_info {
-- 
2.29.2

