Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E39AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 08:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2932D2147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 08:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfBTIyq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:54:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfBTIyp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 03:54:45 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwNeN-0003N8-HV; Wed, 20 Feb 2019 10:54:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 10:54:39 +0200
Message-Id: <20190220085439.16472-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-12-luca@coelho.fi>
References: <20190215114924.2545-12-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 11/20] iwlwifi: mvm: reject new beacons when in inject mode
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Verify we do not accept new beacon templates while beacon
injection is active.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2:

   * Move definition of beacon_inject_active outside CONFIG_PM;


drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 7 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 80b0b2ed69bb..05a6db2db478 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1238,6 +1238,8 @@ static int _iwl_dbgfs_inject_beacon_ie(struct iwl_mvm *mvm, char *bin, int len)
 		goto out_err;
 	}
 
+	mvm->beacon_inject_active = true;
+
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	info = IEEE80211_SKB_CB(beacon);
 	rate = iwl_mvm_mac_ctxt_get_lowest_rate(info, vif);
@@ -1287,6 +1289,7 @@ static ssize_t iwl_dbgfs_inject_beacon_ie_restore_write(struct iwl_mvm *mvm,
 	int ret = _iwl_dbgfs_inject_beacon_ie(mvm, NULL, 0);
 
 	mvm->hw->extra_beacon_tailroom = 0;
+	mvm->beacon_inject_active = false;
 	return ret ?: count;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 9bd4376cad9b..003a20630252 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1041,6 +1041,11 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 	if (!beacon)
 		return -ENOMEM;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvm->beacon_inject_active)
+		return -EBUSY;
+#endif
+
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
 	dev_kfree_skb(beacon);
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 9993337a2bbd..acb4cca5bdcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -978,6 +978,7 @@ struct iwl_mvm {
 	u32 dbgfs_prph_reg_addr;
 	bool disable_power_off;
 	bool disable_power_off_d3;
+	bool beacon_inject_active;
 
 	bool scan_iter_notif_enabled;
 
-- 
2.20.1

