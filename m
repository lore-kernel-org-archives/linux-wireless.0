Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDF9C47438
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Dec 2020 03:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2BE23A5E
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Dec 2020 03:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgLTDgi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Dec 2020 22:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgLTDgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Dec 2020 22:36:37 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/10] cfg80211: initialize rekey_data
Date:   Sat, 19 Dec 2020 22:34:49 -0500
Message-Id: <20201220033457.2728519-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033457.2728519-1-sashal@kernel.org>
References: <20201220033457.2728519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit f495acd8851d7b345e5f0e521b2645b1e1f928a0 ]

In case we have old supplicant, the akm field is uninitialized.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.930f0ab7ebee.Ic546e384efab3f4a89f318eafddc3eb7d556aecb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dbac5c0995a0f..5bb2316befb98 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12033,7 +12033,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct nlattr *tb[NUM_NL80211_REKEY_DATA];
-	struct cfg80211_gtk_rekey_data rekey_data;
+	struct cfg80211_gtk_rekey_data rekey_data = {};
 	int err;
 
 	if (!info->attrs[NL80211_ATTR_REKEY_DATA])
-- 
2.27.0

