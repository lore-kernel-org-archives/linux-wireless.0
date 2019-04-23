Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6316AC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF3320685
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfDWIuV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 04:50:21 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:42838 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726648AbfDWIuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 04:50:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIr87-0000YC-5T; Tue, 23 Apr 2019 11:50:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 1/8] iwlwifi: mvm: Don't sleep in RX path
Date:   Tue, 23 Apr 2019 11:50:07 +0300
Message-Id: <20190423085014.15390-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423085014.15390-1-luca@coelho.fi>
References: <20190423085014.15390-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Don't use cancel_delayed_work_sync() inside the channel switch
notifications as they are handled synchronously as part of the RX path.
Fix that by replacing it with cancel_delayed_work(). This should be safe
as we don't really care whether the work is already started and in such
case we would disconnect anyway.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index fcec25b7b679..53c217af13c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1570,7 +1570,7 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 		return;
 	case NL80211_IFTYPE_STATION:
 		iwl_mvm_csa_client_absent(mvm, vif);
-		cancel_delayed_work_sync(&mvmvif->csa_work);
+		cancel_delayed_work(&mvmvif->csa_work);
 		ieee80211_chswitch_done(vif, true);
 		break;
 	default:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 50314018d157..4d34e5ab1bff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -234,7 +234,7 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 			break;
 		}
 		iwl_mvm_csa_client_absent(mvm, te_data->vif);
-		cancel_delayed_work_sync(&mvmvif->csa_work);
+		cancel_delayed_work(&mvmvif->csa_work);
 		ieee80211_chswitch_done(te_data->vif, true);
 		break;
 	default:
-- 
2.20.1

