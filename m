Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E86C43610
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C80120866
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C80120866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbeKKUOr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35818 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727579AbeKKUOr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:47 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmwt-00007G-Fy; Sun, 11 Nov 2018 12:26:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 12:26:25 +0200
Message-Id: <20181111102627.18461-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111102627.18461-1-luca@coelho.fi>
References: <20181111102627.18461-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/5] iwlwifi: mvm: fix regulatory domain update when the firmware starts
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the firmware starts, it doesn't have any regulatory
information, hence it uses the world wide limitations. The
driver can feed the firmware with previous knowledge that
was kept in the driver, but the firmware may still not
update its internal tables.

This happens when we start a BSS interface, and then the
firmware can change the regulatory tables based on our
location and it'll use more lenient, location specific
rules. Then, if the firmware is shut down (when the
interface is brought down), and then an AP interface is
created, the firmware will forget the country specific
rules.

The host will think that we are in a certain country that
may allow channels and will try to teach the firmware about
our location, but the firmware may still not allow to drop
the world wide limitations and apply country specific rules
because it was just re-started.

In this case, the firmware will reply with MCC_RESP_ILLEGAL
to the MCC_UPDATE_CMD. In that case, iwlwifi needs to let
the upper layers (cfg80211 / hostapd) know that the channel
list they know about has been updated.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=201105

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c      | 5 ++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 7c09ce20e8b1..00f831d88366 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -301,8 +301,12 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 		goto out;
 	}
 
-	if (changed)
-		*changed = (resp->status == MCC_RESP_NEW_CHAN_PROFILE);
+	if (changed) {
+		u32 status = le32_to_cpu(resp->status);
+
+		*changed = (status == MCC_RESP_NEW_CHAN_PROFILE ||
+			    status == MCC_RESP_ILLEGAL);
+	}
 
 	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev, mvm->cfg,
 				      __le32_to_cpu(resp->n_channels),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 3633f27d048a..6fc5cc1f2b5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -539,9 +539,8 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	}
 
 	IWL_DEBUG_LAR(mvm,
-		      "MCC response status: 0x%x. new MCC: 0x%x ('%c%c') change: %d n_chans: %d\n",
-		      status, mcc, mcc >> 8, mcc & 0xff,
-		      !!(status == MCC_RESP_NEW_CHAN_PROFILE), n_channels);
+		      "MCC response status: 0x%x. new MCC: 0x%x ('%c%c') n_chans: %d\n",
+		      status, mcc, mcc >> 8, mcc & 0xff, n_channels);
 
 exit:
 	iwl_free_resp(&cmd);
-- 
2.19.1

