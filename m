Return-Path: <SRS0=CMgv=ZM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996E6C432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 10:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FC02243F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 10:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfKTK1m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:27:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:58672 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728201AbfKTK1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Nov 2019 05:27:42 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iXNCR-0001kS-Vq; Wed, 20 Nov 2019 12:27:04 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 20 Nov 2019 12:26:48 +0200
Message-Id: <20191120102650.514376-11-luca@coelho.fi>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120102650.514376-1-luca@coelho.fi>
References: <20191120102650.514376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/12] iwlwifi: mvm: remove outdated comment referring to wake lock
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no multicast wake lock in the driver, remove the comment
that refers to it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 22136e4832ea..25d7faea1c62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -370,8 +370,6 @@ static void iwl_mvm_power_config_skip_dtim(struct iwl_mvm *mvm,
 	if (dtimper >= 10)
 		return;
 
-	/* TODO: check that multicast wake lock is off */
-
 	if (host_awake) {
 		if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_LP)
 			return;
-- 
2.24.0

