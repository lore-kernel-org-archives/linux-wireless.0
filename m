Return-Path: <SRS0=ssZ+=5L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315EEC43331
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 13:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08D8820748
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 13:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgCZNO2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:14:28 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44388 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725994AbgCZNO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Mar 2020 09:14:28 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jHSGm-00044K-Iz; Thu, 26 Mar 2020 15:10:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 26 Mar 2020 15:09:41 +0200
Message-Id: <iwlwifi.20200326150855.554d1199b309.Id86fd36e3d88d2a75d6e0c6618fd93ce8fe84065@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326130943.623208-1-luca@coelho.fi>
References: <20200326130943.623208-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 10/12] mac80211_hwsim: indicate in IBSS that we have transmitted beacons
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is actually true because there's no functional beacon distribution
and lets us get active scanning working - without it, mac80211 doesn't
respond to probe requests.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4d7141d06027..21148c6d24af 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2464,6 +2464,11 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != MAC80211_HWSIM_SSTATS_LEN);
 }
 
+static int mac80211_hwsim_tx_last_beacon(struct ieee80211_hw *hw)
+{
+	return 1;
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.start = mac80211_hwsim_start,				\
@@ -2474,6 +2479,7 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 	.config = mac80211_hwsim_config,			\
 	.configure_filter = mac80211_hwsim_configure_filter,	\
 	.bss_info_changed = mac80211_hwsim_bss_info_changed,	\
+	.tx_last_beacon = mac80211_hwsim_tx_last_beacon,	\
 	.sta_add = mac80211_hwsim_sta_add,			\
 	.sta_remove = mac80211_hwsim_sta_remove,		\
 	.sta_notify = mac80211_hwsim_sta_notify,		\
-- 
2.25.1

