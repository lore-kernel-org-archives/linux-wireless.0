Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F0EC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 15:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB70B206B8
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 15:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfDCPhq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:37:46 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.200]:40572 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbfDCPhq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 11:37:46 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 11:37:46 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id C709C12E1E4
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 10:37:45 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BhxRhL3ijdnCeBhxRhASMm; Wed, 03 Apr 2019 10:37:45 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=41268 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBhxR-000tLH-2O; Wed, 03 Apr 2019 10:37:45 -0500
Date:   Wed, 3 Apr 2019 10:37:44 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] nl80211: Use struct_size() in kzalloc()
Message-ID: <20190403153744.GA14333@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.114.183
X-Source-L: No
X-Exim-ID: 1hBhxR-000tLH-2O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:41268
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);
instance = kzalloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)

Notice that, in this case, variable size_of_regd is not necessary,
hence it is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/wireless/nl80211.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e7ee18ab6cb7..f8bca386c904 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3843,8 +3843,7 @@ static struct cfg80211_acl_data *parse_acl_data(struct wiphy *wiphy,
 	if (n_entries > wiphy->max_acl_mac_addrs)
 		return ERR_PTR(-ENOTSUPP);
 
-	acl = kzalloc(sizeof(*acl) + (sizeof(struct mac_address) * n_entries),
-		      GFP_KERNEL);
+	acl = kzalloc(struct_size(acl, mac_addrs, n_entries), GFP_KERNEL);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 
@@ -6882,7 +6881,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *nl_reg_rule;
 	char *alpha2;
 	int rem_reg_rules, r;
-	u32 num_rules = 0, rule_idx = 0, size_of_regd;
+	u32 num_rules = 0, rule_idx = 0;
 	enum nl80211_dfs_regions dfs_region = NL80211_DFS_UNSET;
 	struct ieee80211_regdomain *rd;
 
@@ -6907,10 +6906,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (!reg_is_valid_request(alpha2))
 		return -EINVAL;
 
-	size_of_regd = sizeof(struct ieee80211_regdomain) +
-		       num_rules * sizeof(struct ieee80211_reg_rule);
-
-	rd = kzalloc(size_of_regd, GFP_KERNEL);
+	rd = kzalloc(struct_size(rd, reg_rules, num_rules), GFP_KERNEL);
 	if (!rd)
 		return -ENOMEM;
 
-- 
2.21.0

