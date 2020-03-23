Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD94C54FCE
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BA4620722
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgCWNTm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:19:42 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43428 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728357AbgCWNTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 09:19:42 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jGMzU-00023f-79; Mon, 23 Mar 2020 15:19:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 23 Mar 2020 15:19:19 +0200
Message-Id: <iwlwifi.20200323151304.f436f5b9ad4f.Icaeff714c00a773681dbfee72558afd1c7121c5d@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323131925.208376-1-luca@coelho.fi>
References: <20200323131925.208376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/14] iwlwifi: mvm: enable SF also when we have HE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We shouldn't do this just for HT/VHT, but be future-proof
and also check for HE.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index 9da0dae78510..368b9d117f73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -162,7 +162,9 @@ static void iwl_mvm_fill_sf_command(struct iwl_mvm *mvm,
 	 * capabilities of the AP station, and choose the watermark accordingly.
 	 */
 	if (sta) {
-		if (sta->ht_cap.ht_supported || sta->vht_cap.vht_supported) {
+		if (sta->ht_cap.ht_supported ||
+		    sta->vht_cap.vht_supported ||
+		    sta->he_cap.has_he) {
 			switch (sta->rx_nss) {
 			case 1:
 				watermark = SF_W_MARK_SISO;
-- 
2.25.1

