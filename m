Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EECEC3A5A0
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 14:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5066820651
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 14:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfHSOfZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:35:25 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36796 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727146AbfHSOfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 10:35:24 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hzikk-0007sP-GF; Mon, 19 Aug 2019 17:35:22 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 19 Aug 2019 17:34:50 +0300
Message-Id: <20190819143507.6989-6-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190819143507.6989-1-luca@coelho.fi>
References: <20190819143507.6989-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 05/22] iwlwifi: mvm: remove unnecessary forward declarations
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These static functions are only used after their definition,
so we don't need the forward declarations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 10f18536dd0d..4fae0cb22195 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -67,14 +67,6 @@
 #include "sta.h"
 #include "rs.h"
 
-static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm);
-
-static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
-				u32 sta_id,
-				struct ieee80211_key_conf *key, bool mcast,
-				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
-				u8 key_offset, bool mfp);
-
 /*
  * New version of ADD_STA_sta command added new fields at the end of the
  * structure, so sending the size of the relevant API's structure is enough to
-- 
2.23.0.rc1

