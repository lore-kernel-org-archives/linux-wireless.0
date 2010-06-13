Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.clear-code.com ([219.94.198.64]:36440 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0FMGBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 02:01:49 -0400
Received: from localhost (softbank218138133044.bbtec.net [218.138.133.44])
	by mail.clear-code.com (Postfix) with ESMTPSA id EFF55AC084
	for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 14:52:02 +0900 (JST)
Date: Sun, 13 Jun 2010 14:52:00 +0900 (JST)
Message-Id: <20100613.145200.1459063883179763823.kou@clear-code.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw: ignore unknown regulatory domain.
From: Kouhei Sutou <kou@clear-code.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sun_Jun_13_14_52_00_2010_363)--"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

----Next_Part(Sun_Jun_13_14_52_00_2010_363)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

I'm using PLANEX GW-US54GXS (2019:5303) and it works with
the attached patch. Could you consider to merge the attached
patch?

Problem: GW-US54GXS uses zd1211rw but zd1211rw doesn't have
a regulatory domain reported by GW-US54GXS (0x49).

Solutions:

  (1) add a new regulatory domain (0x49). Here is a patch to
      use the approach:

----
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 163a8a0..faf45f1 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -43,6 +43,7 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
 	{ ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
 	{ ZD_REGDOMAIN_JAPAN, "JP" },
 	{ ZD_REGDOMAIN_JAPAN_ADD, "JP" },
+	{ ZD_REGDOMAIN_JAPAN_GW_US54GXS, "JP" },
 	{ ZD_REGDOMAIN_SPAIN, "ES" },
 	{ ZD_REGDOMAIN_FRANCE, "FR" },
 };
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 630c298..7ab19d5 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -214,6 +214,7 @@ struct zd_mac {
 #define ZD_REGDOMAIN_FRANCE	0x32
 #define ZD_REGDOMAIN_JAPAN_ADD	0x40
 #define ZD_REGDOMAIN_JAPAN	0x41
+#define ZD_REGDOMAIN_JAPAN_GW_US54GXS	0x49
 
 enum {
 	MIN_CHANNEL24 = 1,
----

  (2) just ignore unknown regulatory domain. (the attached
      patch approach)


It seems that (2) is a better solution because we can change
regulatory domain by CRDA (*).
(*) http://wireless.kernel.org/en/developers/Regulatory/CRDA


Thanks,
--
kou

----Next_Part(Sun_Jun_13_14_52_00_2010_363)--
Content-Type: Text/X-Patch; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-zd1211rw-ignore-unknown-regulatory-domain.patch"

>From c230320db45e9261814b69e7596d4f641c3c8aad Mon Sep 17 00:00:00 2001
From: Kouhei Sutou <kou@clear-code.com>
Date: Sun, 13 Jun 2010 14:37:54 +0900
Subject: [PATCH] zd1211rw: ignore unknown regulatory domain.

Zd1211rw supports 7 regulatory domains (ZD_REGDOMAIN_*) but they
aren't cover all regulatory domains. For example, PLANEX
GW-US54GXS (2019:5303) uses 0x49 for its regulatory domain.

If zd1211rw can't convert a regulatory domain to alpha2, it
reports that initialization is failed. But we can change
regulatory domain by another way (CRDA). So it seems that zd1211rw
can ignore unknown regulatory domain.

Signed-off-by: Kouhei Sutou <kou@clear-code.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 163a8a0..8b04d93 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -198,11 +198,9 @@ int zd_mac_init_hw(struct ieee80211_hw *hw)
 	if (r)
 		goto disable_int;
 
-	r = zd_reg2alpha2(mac->regdomain, alpha2);
-	if (r)
-		goto disable_int;
+	if (zd_reg2alpha2(mac->regdomain, alpha2))
+		r = regulatory_hint(hw->wiphy, alpha2);
 
-	r = regulatory_hint(hw->wiphy, alpha2);
 disable_int:
 	zd_chip_disable_int(chip);
 out:
-- 
1.7.1


----Next_Part(Sun_Jun_13_14_52_00_2010_363)----
