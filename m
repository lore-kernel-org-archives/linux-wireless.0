Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0147C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 07:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82432173C
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 07:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfC2H42 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:56:28 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51090 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbfC2H42 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 03:56:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h9mNG-0000wD-SE; Fri, 29 Mar 2019 08:56:27 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211_hwsim: calculate if_combination.max_interfaces
Date:   Fri, 29 Mar 2019 08:56:22 +0100
Message-Id: <20190329075622.7534-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If we just set this to 2048, and have multiple limits you
can select from, the total number might run over and cause
a warning in cfg80211. This doesn't make sense, so we just
calculate the total max_interfaces now.

Reported-by: syzbot+8f91bd563bbff230d0ee@syzkaller.appspotmail.com
Fixes: 99e3a44bac37 ("mac80211_hwsim: allow setting iftype support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 77bce2d27841..53710d4e86a1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2644,7 +2644,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	enum nl80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	struct net *net;
-	int idx;
+	int idx, i;
 	int n_limits = 0;
 
 	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
@@ -2768,12 +2768,23 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		goto failed_hw;
 	}
 
+	data->if_combination.max_interfaces = 0;
+	for (i = 0; i < n_limits; i++)
+		data->if_combination.max_interfaces +=
+			data->if_limits[i].max;
+
 	data->if_combination.n_limits = n_limits;
-	data->if_combination.max_interfaces = 2048;
 	data->if_combination.limits = data->if_limits;
 
-	hw->wiphy->iface_combinations = &data->if_combination;
-	hw->wiphy->n_iface_combinations = 1;
+	/*
+	 * If we actually were asked to support combinations,
+	 * advertise them - if there's only a single thing like
+	 * only IBSS then don't advertise it as combinations.
+	 */
+	if (data->if_combination.max_interfaces > 1) {
+		hw->wiphy->iface_combinations = &data->if_combination;
+		hw->wiphy->n_iface_combinations = 1;
+	}
 
 	if (param->ciphers) {
 		memcpy(data->ciphers, param->ciphers,
-- 
2.17.2

