Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5C9C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA0EB20657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfAONY2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:24:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56674 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfAONY2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:24:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOhe-0007iV-2n; Tue, 15 Jan 2019 14:24:26 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: check that n_limits makes sense
Date:   Tue, 15 Jan 2019 14:24:23 +0100
Message-Id: <20190115132423.25046-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Under certain circumstances, radios created via netlink could
have n_limits be zero and no possible interface types, which
makes no sense. Reject this early to prevent a WARN_ON() in
cfg80211.

Fixes: 99e3a44bac37 ("mac80211_hwsim: allow setting iftype support")
Reported-by: syzbot+73fd8b0aa60c67fa4b60@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3a4b8786f7ea..320edcac4699 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2761,6 +2761,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 					BIT(NL80211_CHAN_WIDTH_160);
 	}
 
+	if (!n_limits) {
+		err = -EINVAL;
+		goto failed_hw;
+	}
+
 	data->if_combination.n_limits = n_limits;
 	data->if_combination.max_interfaces = 2048;
 	data->if_combination.limits = data->if_limits;
-- 
2.17.2

