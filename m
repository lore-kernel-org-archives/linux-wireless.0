Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F089FC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567432080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbeLNUam (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42076 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNUal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:30:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5w-0002RG-Df; Fri, 14 Dec 2018 22:30:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:40 +0200
Message-Id: <20181214202945.32375-14-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/18] iwlwifi: remove unused and wrong PHY_CFG_* macros
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

These macros are never used and are actually wrong, so it's very
confusing.  Remove them.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/config.h b/drivers/net/wireless/intel/iwlwifi/fw/api/config.h
index 7f645b62804e..5e88fa2e6fb7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/config.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/config.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -127,17 +129,6 @@ struct iwl_phy_cfg_cmd {
 	struct iwl_calib_ctrl calib_control;
 } __packed;
 
-#define PHY_CFG_RADIO_TYPE	(BIT(0) | BIT(1))
-#define PHY_CFG_RADIO_STEP	(BIT(2) | BIT(3))
-#define PHY_CFG_RADIO_DASH	(BIT(4) | BIT(5))
-#define PHY_CFG_PRODUCT_NUMBER	(BIT(6) | BIT(7))
-#define PHY_CFG_TX_CHAIN_A	BIT(8)
-#define PHY_CFG_TX_CHAIN_B	BIT(9)
-#define PHY_CFG_TX_CHAIN_C	BIT(10)
-#define PHY_CFG_RX_CHAIN_A	BIT(12)
-#define PHY_CFG_RX_CHAIN_B	BIT(13)
-#define PHY_CFG_RX_CHAIN_C	BIT(14)
-
 /*
  * enum iwl_dc2dc_config_id - flag ids
  *
-- 
2.19.2

