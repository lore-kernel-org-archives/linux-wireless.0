Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE9AC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E43D0218A5
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfCWMni (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 08:43:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49100 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfCWMnh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 08:43:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h7fzr-0008VO-Mo; Sat, 23 Mar 2019 13:43:35 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: calculate if_combination.max_interfaces
Date:   Sat, 23 Mar 2019 13:43:20 +0100
Message-Id: <20190323124320.5829-1-johannes@sipsolutions.net>
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
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 77bce2d27841..1fe94dfee5c6 100644
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
@@ -2768,8 +2768,12 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		goto failed_hw;
 	}
 
+	data->if_combination.max_interfaces = 0;
+	for (i = 0; i < n_limits; i++)
+		data->if_combination.max_interfaces +=
+			data->if_limits[n_limits].max;
+
 	data->if_combination.n_limits = n_limits;
-	data->if_combination.max_interfaces = 2048;
 	data->if_combination.limits = data->if_limits;
 
 	hw->wiphy->iface_combinations = &data->if_combination;
-- 
2.17.2

