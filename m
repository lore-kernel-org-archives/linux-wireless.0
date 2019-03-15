Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11401C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D53572077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfCOQgs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44268 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728171AbfCOQgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:47 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp7-0004qp-NR; Fri, 15 Mar 2019 18:36:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:24 +0200
Message-Id: <20190315163634.17315-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/16] mac80211_hwsim: make copying of ciphers safer by checking the length
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Make sure the length of the ciphers we are copying never exceeds the
space we have for storing them.  There is no risk of overcopying at
the moment, because we check n_params before, but this makes this
function safer in case someone changes something in the future.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0838af04d681..809a75357113 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
  * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2776,10 +2776,14 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hw->wiphy->n_iface_combinations = 1;
 
 	if (param->ciphers) {
-		memcpy(data->ciphers, param->ciphers,
-		       param->n_ciphers * sizeof(u32));
+		int ciphers_len = param->n_ciphers * sizeof(data->ciphers[0]);
+
+		if (WARN_ON_ONCE(ciphers_len > sizeof(data->ciphers)))
+			ciphers_len = sizeof(data->ciphers);
+
+		memcpy(data->ciphers, param->ciphers, ciphers_len);
 		hw->wiphy->cipher_suites = data->ciphers;
-		hw->wiphy->n_cipher_suites = param->n_ciphers;
+		hw->wiphy->n_cipher_suites = ciphers_len / sizeof(data->ciphers[0]);
 	}
 
 	INIT_DELAYED_WORK(&data->roc_start, hw_roc_start);
-- 
2.20.1

