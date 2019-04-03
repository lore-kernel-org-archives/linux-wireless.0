Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFA7C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 15:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8D73206BA
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 15:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDCPxT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:53:19 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.200]:31997 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfDCPxT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 11:53:19 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 02A3F28319
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 10:31:53 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BhrkhKw5pdnCeBhrkhAKmc; Wed, 03 Apr 2019 10:31:52 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=41252 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBhrk-000pSV-3q; Wed, 03 Apr 2019 10:31:52 -0500
Date:   Wed, 3 Apr 2019 10:31:51 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cfg80211: Use struct_size() in kzalloc()
Message-ID: <20190403153151.GA32496@embeddedor>
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
X-Exim-ID: 1hBhrk-000pSV-3q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:41252
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
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
 net/wireless/reg.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0ba778f371cb..816425ffe05a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -427,14 +427,10 @@ static const struct ieee80211_regdomain *
 reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 {
 	struct ieee80211_regdomain *regd;
-	int size_of_regd;
 	unsigned int i;
 
-	size_of_regd =
-		sizeof(struct ieee80211_regdomain) +
-		src_regd->n_reg_rules * sizeof(struct ieee80211_reg_rule);
-
-	regd = kzalloc(size_of_regd, GFP_KERNEL);
+	regd = kzalloc(struct_size(regd, reg_rules, src_regd->n_reg_rules),
+		       GFP_KERNEL);
 	if (!regd)
 		return ERR_PTR(-ENOMEM);
 
@@ -948,12 +944,10 @@ static int regdb_query_country(const struct fwdb_header *db,
 	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
 	struct fwdb_collection *coll = (void *)((u8 *)db + ptr);
 	struct ieee80211_regdomain *regdom;
-	unsigned int size_of_regd, i;
-
-	size_of_regd = sizeof(struct ieee80211_regdomain) +
-		coll->n_rules * sizeof(struct ieee80211_reg_rule);
+	unsigned int i;
 
-	regdom = kzalloc(size_of_regd, GFP_KERNEL);
+	regdom = kzalloc(struct_size(regdom, reg_rules, coll->n_rules),
+			 GFP_KERNEL);
 	if (!regdom)
 		return -ENOMEM;
 
@@ -1489,7 +1483,7 @@ static struct ieee80211_regdomain *
 regdom_intersect(const struct ieee80211_regdomain *rd1,
 		 const struct ieee80211_regdomain *rd2)
 {
-	int r, size_of_regd;
+	int r;
 	unsigned int x, y;
 	unsigned int num_rules = 0;
 	const struct ieee80211_reg_rule *rule1, *rule2;
@@ -1520,10 +1514,7 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	if (!num_rules)
 		return NULL;
 
-	size_of_regd = sizeof(struct ieee80211_regdomain) +
-		       num_rules * sizeof(struct ieee80211_reg_rule);
-
-	rd = kzalloc(size_of_regd, GFP_KERNEL);
+	rd = kzalloc(struct_size(rd, reg_rules, num_rules), GFP_KERNEL);
 	if (!rd)
 		return NULL;
 
-- 
2.21.0

