Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14392 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:53:33 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/4] ath: add a helper for processing reg data on init
Date: Wed, 7 Dec 2011 19:23:18 +0530
Message-ID: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111207_145347_502159_74177A2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>

This has no functional change. The helper can be used later
for other things like country IE changes and following the CTL
for different countries.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/regd.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 65ecb5b..ed4966f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -508,11 +508,7 @@ static void ath_regd_sanitize(struct ath_regulatory *reg)
 	reg->current_rd = 0x64;
 }
 
-int
-ath_regd_init(struct ath_regulatory *reg,
-	      struct wiphy *wiphy,
-	      int (*reg_notifier)(struct wiphy *wiphy,
-				  struct regulatory_request *request))
+static int __ath_regd_init(struct ath_regulatory *reg)
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
@@ -583,7 +579,23 @@ ath_regd_init(struct ath_regulatory *reg,
 	printk(KERN_DEBUG "ath: Regpair used: 0x%0x\n",
 		reg->regpair->regDmnEnum);
 
+	return 0;
+}
+
+int
+ath_regd_init(struct ath_regulatory *reg,
+	      struct wiphy *wiphy,
+	      int (*reg_notifier)(struct wiphy *wiphy,
+				  struct regulatory_request *request))
+{
+	int r;
+
+	r = __ath_regd_init(reg);
+	if (r)
+		return r;
+
 	ath_regd_init_wiphy(reg, wiphy, reg_notifier);
+
 	return 0;
 }
 EXPORT_SYMBOL(ath_regd_init);
-- 
1.7.8

