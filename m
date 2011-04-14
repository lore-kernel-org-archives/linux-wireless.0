Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56858 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1DNLLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 07:11:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 04:11:28 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/1] ath: Add a missing world regulatory domain 0x6C
Date: Thu, 14 Apr 2011 16:41:30 +0530
Message-ID: <1302779490-4670-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some customers use 0x6C world regulatory domain and this patch
adds the support.

Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/regd.c        |    7 ++++---
 drivers/net/wireless/ath/regd_common.h |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 0e1b879..14952f0 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -97,8 +97,8 @@ static const struct ieee80211_regdomain ath_world_regdom_66_69 = {
 	}
 };
 
-/* Can be used by 0x67, 0x6A and 0x68 */
-static const struct ieee80211_regdomain ath_world_regdom_67_68_6A = {
+/* Can be used by 0x67, 0x68, 0x6A and 0x6C */
+static const struct ieee80211_regdomain ath_world_regdom_67_68_6A_6C = {
 	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -151,7 +151,8 @@ ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 	case 0x67:
 	case 0x68:
 	case 0x6A:
-		return &ath_world_regdom_67_68_6A;
+	case 0x6C:
+		return &ath_world_regdom_67_68_6A_6C;
 	default:
 		WARN_ON(1);
 		return ath_default_world_regdomain();
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 5c2cfe6..24b5383 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -86,6 +86,7 @@ enum EnumRd {
 	WOR9_WORLD = 0x69,
 	WORA_WORLD = 0x6A,
 	WORB_WORLD = 0x6B,
+	WORC_WORLD = 0x6C,
 
 	MKK3_MKKB = 0x80,
 	MKK3_MKKA2 = 0x81,
@@ -282,6 +283,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{WOR9_WORLD, NO_CTL, NO_CTL},
 	{WORA_WORLD, NO_CTL, NO_CTL},
 	{WORB_WORLD, NO_CTL, NO_CTL},
+	{WORC_WORLD, NO_CTL, NO_CTL},
 };
 
 static struct country_code_to_enum_rd allCountries[] = {
-- 
1.7.0.4

