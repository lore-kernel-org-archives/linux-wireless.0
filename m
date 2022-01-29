Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A622C433F5
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Jan 2022 11:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbiA2LQe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Jan 2022 06:16:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:37880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237233AbiA2LQc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Jan 2022 06:16:32 -0500
Received: from 91-156-4-210.elisa-laajakaista.fi ([91.156.4.210] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1nDliY-0002ji-5V;
        Sat, 29 Jan 2022 13:16:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@kernel.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sat, 29 Jan 2022 13:16:16 +0200
Message-Id: <iwlwifi.20220129105618.fcec0204e162.Ib73bf787ab4d83581de20eb89b1f8dbfcaaad0e3@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220129111622.678447-1-luca@coelho.fi>
References: <20220129111622.678447-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/12] iwlwifi: mvm: align locking in D3 test debugfs
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver") we're not only holding the RTNL when going
in and out of suspend, but also the wiphy->mtx. Add that to the
D3 test debugfs in iwlwifi since it's required for various calls
to mac80211.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9f0e436f11f3..a995bba0ba81 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2697,7 +2697,9 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 
 	/* start pseudo D3 */
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	err = __iwl_mvm_suspend(mvm->hw, mvm->hw->wiphy->wowlan_config, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 	if (err > 0)
 		err = -EINVAL;
@@ -2753,7 +2755,9 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	__iwl_mvm_resume(mvm, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 
 	iwl_mvm_resume_tcm(mvm);
-- 
2.34.1

