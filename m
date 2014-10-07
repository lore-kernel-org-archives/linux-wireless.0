Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48724 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaJGEnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 00:43:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 1/6] ath: Fix smatch warning
Date: Tue,  7 Oct 2014 10:14:36 +0530
Message-Id: <1412657081-3202-2-git-send-email-sujith@msujith.org> (sfid-20141007_064403_200928_8CCABDB4)
In-Reply-To: <1412657081-3202-1-git-send-email-sujith@msujith.org>
References: <1412657081-3202-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

drivers/net/wireless/ath/main.c:88 ath_printk()
	 error: we previously assumed 'common->hw' could be null (see line 82)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 83f47af..338d723 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -79,13 +79,13 @@ void ath_printk(const char *level, const struct ath_common* common,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	if (common && common->hw && common->hw->wiphy)
+	if (common && common->hw && common->hw->wiphy) {
 		printk("%sath: %s: %pV",
 		       level, wiphy_name(common->hw->wiphy), &vaf);
-	else
+		trace_ath_log(common->hw->wiphy, &vaf);
+	} else {
 		printk("%sath: %pV", level, &vaf);
-
-	trace_ath_log(common->hw->wiphy, &vaf);
+	}
 
 	va_end(args);
 }
-- 
2.1.2

