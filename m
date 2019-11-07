Return-Path: <SRS0=sGVr=Y7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03155FA372C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 11:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14FE20673
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 11:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfKGLv6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:51:58 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55144 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387468AbfKGLv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Nov 2019 06:51:58 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iSgKR-0000wr-Uw; Thu, 07 Nov 2019 13:51:56 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu,  7 Nov 2019 13:51:48 +0200
Message-Id: <20191107115149.10709-2-luca@coelho.fi>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191107115149.10709-1-luca@coelho.fi>
References: <20191107115149.10709-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.4 2/3] mac80211: fix ieee80211_txq_setup_flows() failure path
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If ieee80211_txq_setup_flows() fails, we don't clean up WEP/LED
state properly, leading to crashes later on, fix that.

Fixes: dc8b274f0952 ("mac80211: Move up init of TXQs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aba094b4ccfc..2d05c4cfaf6d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1292,8 +1292,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_remove_interfaces(local);
  fail_rate:
 	rtnl_unlock();
-	ieee80211_led_exit(local);
  fail_flows:
+	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
-- 
2.24.0.rc1

