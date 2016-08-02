Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33463 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624AbcHBMVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:21:07 -0400
Received: by mail-lf0-f54.google.com with SMTP id b199so137141028lfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 05:21:06 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath: export alpha2 helper
Date: Tue,  2 Aug 2016 14:20:53 +0200
Message-Id: <1470140454-3899-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20160802_175400_802839_03B46CA1)
In-Reply-To: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
References: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This will be helpful for drivers that can acquire
alpha2 regulatory codes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/regd.c | 3 ++-
 drivers/net/wireless/ath/regd.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7e15ed9ed31f..820bf880ada3 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -449,7 +449,7 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 	}
 }
 
-static u16 ath_regd_find_country_by_name(char *alpha2)
+u16 ath_regd_find_country_by_name(char *alpha2)
 {
 	unsigned int i;
 
@@ -460,6 +460,7 @@ static u16 ath_regd_find_country_by_name(char *alpha2)
 
 	return -1;
 }
+EXPORT_SYMBOL(ath_regd_find_country_by_name);
 
 static int __ath_reg_dyn_country(struct wiphy *wiphy,
 				 struct ath_regulatory *reg,
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 565d3075f06e..5d80be213fac 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -251,6 +251,7 @@ enum CountryCode {
 
 bool ath_is_world_regd(struct ath_regulatory *reg);
 bool ath_is_49ghz_allowed(u16 redomain);
+u16 ath_regd_find_country_by_name(char *alpha2);
 int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
 		  void (*reg_notifier)(struct wiphy *wiphy,
 				       struct regulatory_request *request));
-- 
2.1.2

