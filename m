Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:35706 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3JWSyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 14:54:25 -0400
Received: by mail-we0-f172.google.com with SMTP id q58so1272277wes.17
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 11:54:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC] crda: remove antenna gain
Date: Wed, 23 Oct 2013 20:54:21 +0200
Message-Id: <1382554461-27746-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131023_205428_120298_241296A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/reglib.c b/reglib.c
index fa6efe0..b0c61e5 100644
--- a/reglib.c
+++ b/reglib.c
@@ -673,11 +673,6 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	printf("(");
 
-	if (power->max_antenna_gain)
-		printf("%.2f, ", ((float)(power->max_antenna_gain)/100.0));
-	else
-		printf("N/A, ");
-
 	if (power->max_eirp)
 		printf("%.2f)", ((float)(power->max_eirp)/100.0));
 	else
-- 
1.8.4.rc3

