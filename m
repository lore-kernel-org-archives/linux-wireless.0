Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BA2C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A006218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfAaUWV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727966AbfAaUWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqo-0004pL-E5; Thu, 31 Jan 2019 22:22:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:50 +0200
Message-Id: <20190131202206.15903-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/21] iwlwifi: dvm: use %u for sscanf() into unsigned variable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Use %u instead of using %d which looks signed but then won't
get signed output if using an unsigned variable. It doesn't
matter much, but be consistent.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 3d2e44a642de..e64cdafc5623 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -3,6 +3,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -2238,7 +2239,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
-	if (sscanf(buf, "%d", &event_log_flag) != 1)
+	if (sscanf(buf, "%u", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
 		iwl_dump_nic_event_log(priv, true, NULL);
-- 
2.20.1

