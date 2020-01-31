Return-Path: <SRS0=91MJ=3U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E127C2D0DB
	for <linux-wireless@archiver.kernel.org>; Fri, 31 Jan 2020 13:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C381220705
	for <linux-wireless@archiver.kernel.org>; Fri, 31 Jan 2020 13:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgAaNpm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 31 Jan 2020 08:45:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728718AbgAaNpm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Jan 2020 08:45:42 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1ixWc8-0002Nv-Lq; Fri, 31 Jan 2020 15:45:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 31 Jan 2020 15:45:27 +0200
Message-Id: <20200131134530.931641-5-luca@coelho.fi>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131134530.931641-1-luca@coelho.fi>
References: <20200131134530.931641-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.6 4/7] iwlwifi: mvm: avoid use after free for pmsr request
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

When a FTM request is aborted, the driver sends the abort command to
the fw and waits for a response. When the response arrives, the driver
calls cfg80211_pmsr_complete() for that request.
However, cfg80211 frees the requested data immediately after sending
the abort command, so this may lead to use after free.

Fix it by clearing the request data in the driver when the abort
command arrives and ignoring the fw notification that will come
afterwards.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Fixes: fc36ffda3267 ("iwlwifi: mvm: support FTM initiator")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index f783d6d53b6f..6e1ea921c299 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -528,6 +530,8 @@ void iwl_mvm_ftm_abort(struct iwl_mvm *mvm, struct cfg80211_pmsr_request *req)
 	if (req != mvm->ftm_initiator.req)
 		return;
 
+	iwl_mvm_ftm_reset(mvm);
+
 	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_RANGE_ABORT_CMD,
 						 LOCATION_GROUP, 0),
 				 0, sizeof(cmd), &cmd))
@@ -641,7 +645,6 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (!mvm->ftm_initiator.req) {
-		IWL_ERR(mvm, "Got FTM response but have no request?\n");
 		return;
 	}
 
-- 
2.24.1

