Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03421C54FD0
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83EB20722
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgCWNTl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:19:41 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43416 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728357AbgCWNTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 09:19:40 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jGMzS-00023f-Ms; Mon, 23 Mar 2020 15:19:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 23 Mar 2020 15:19:17 +0200
Message-Id: <iwlwifi.20200323151304.02d58330878d.I39af135a9e3fc64337d2cced43a70cb48fe3b9c1@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323131925.208376-1-luca@coelho.fi>
References: <20200323131925.208376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/14] iwlwifi: mvm: rs-fw: fix some indentation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

That closing brace for the switch statement is misplaced, fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index e2cf9e015ef8..d6e144fbb941 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -399,8 +399,7 @@ u16 rs_fw_get_max_amsdu_len(struct ieee80211_sta *sta)
 			return IEEE80211_MAX_MPDU_LEN_VHT_7991;
 		default:
 			return IEEE80211_MAX_MPDU_LEN_VHT_3895;
-	}
-
+		}
 	} else if (ht_cap->ht_supported) {
 		if (ht_cap->cap & IEEE80211_HT_CAP_MAX_AMSDU)
 			/*
-- 
2.25.1

