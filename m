Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5148C282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 759C62146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfA0KT0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbfA0KT0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:26 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXA-0001vC-Gb; Sun, 27 Jan 2019 12:19:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:51 +0200
Message-Id: <20190127101908.6428-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/21] iwlwifi: dvm: remove useless condition
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If we're in the else branch of checking "tt->state == IWL_TI_CT_KILL"
so there's no point in checking "tt->state != IWL_TI_CT_KILL" again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index 4de2727ac63e..a156dcf5b7d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -325,9 +326,9 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 					iwl_prepare_ct_kill_task(priv);
 					tt->state = old_state;
 				}
-			} else if (old_state == IWL_TI_CT_KILL &&
-				 tt->state != IWL_TI_CT_KILL)
+			} else if (old_state == IWL_TI_CT_KILL) {
 				iwl_perform_ct_kill_task(priv, false);
+			}
 			IWL_DEBUG_TEMP(priv, "Temperature state changed %u\n",
 					tt->state);
 			IWL_DEBUG_TEMP(priv, "Power Index change to %u\n",
-- 
2.20.1

