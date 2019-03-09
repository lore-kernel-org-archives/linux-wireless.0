Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22979C10F00
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61412086A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfCIJWp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:45 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41772 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725791AbfCIJWo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:44 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBm-0000qV-O0; Sat, 09 Mar 2019 11:22:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:30 +0200
Message-Id: <20190309092237.10294-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/8] iwlwifi: mvm: report delayed beacon count to FW
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Support passing to FW delayed beacon count. This
represents the delay the AP can have when moving to
the new channel.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a92c09d4692..1bdc27d07d74 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4473,6 +4473,10 @@ static int iwl_mvm_schedule_client_csa(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (chsw->delay)
+		cmd.cs_delayed_bcn_count =
+			DIV_ROUND_UP(chsw->delay, vif->bss_conf.beacon_int);
+
 	return iwl_mvm_send_cmd_pdu(mvm,
 				    WIDE_ID(MAC_CONF_GROUP,
 					    CHANNEL_SWITCH_TIME_EVENT_CMD),
-- 
2.20.1

