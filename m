Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward2h.cmail.yandex.net ([87.250.230.17]:53213 "EHLO
        forward2h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761479AbcLUWap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 17:30:45 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
To: johannes <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] net: wireless: fix to uses struct
MIME-Version: 1.0
Message-Id: <608881482358981@web17g.yandex.ru> (sfid-20161221_233047_790286_95D0AC67)
Date: Thu, 22 Dec 2016 00:23:01 +0200
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The patch fixed to struct uses in reg.c, I think doesn't need to be use to "struct". 
There is dataype not have to logical link and each is different definitons.

I'm undecided on this patch. I compiled and didn't to errors.
 
Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
---
 net/wireless/reg.c  | 10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dbac37..5b70970 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -490,7 +490,7 @@ static int reg_query_builtin(const char *alpha2)
 	if (!regdom)
 		return -ENODATA;
 
-	request = kzalloc(sizeof(struct reg_regdb_apply_request), GFP_KERNEL);
+	request = kzalloc(sizeof(*reg_regdb_apply_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
 
@@ -2291,7 +2291,7 @@ static int regulatory_hint_core(const char *alpha2)
 {
 	struct regulatory_request *request;
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
 
@@ -2313,7 +2313,7 @@ int regulatory_hint_user(const char *alpha2,
 	if (WARN_ON(!alpha2))
 		return -EINVAL;
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
 
@@ -2385,7 +2385,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 
 	wiphy->regulatory_flags &= ~REGULATORY_CUSTOM_REG;
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	request = kzalloc(sizeof(*regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
 
@@ -2661,7 +2661,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (processing)
 		return 0;
 
-	reg_beacon = kzalloc(sizeof(struct reg_beacon), gfp);
+	reg_beacon = kzalloc(sizeof(*reg_beacon), gfp);
 	if (!reg_beacon)
 		return -ENOMEM;
 
-- 
2.1.4
