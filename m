Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44809 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3KHRfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 12:35:04 -0500
Received: by mail-wi0-f178.google.com with SMTP id hn9so2547125wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 09:35:03 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Joe Perches <joe@perches.com>
Subject: [PATCH 3/3] wcn36xx: Fix logging macro with unnecessary semicolon
Date: Fri,  8 Nov 2013 17:34:39 +0000
Message-Id: <1383932079-3791-4-git-send-email-k.eugene.e@gmail.com> (sfid-20131108_183514_031981_36973CE3)
In-Reply-To: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
References: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wcn36xx_err macro should not end in a semicolon as
there are 2 consecutive semicolons in the preprocessed
output.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 58b6383..8fa5cba 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -54,7 +54,7 @@ enum wcn36xx_debug_mask {
 };
 
 #define wcn36xx_err(fmt, arg...)				\
-	printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
+	printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg)
 
 #define wcn36xx_warn(fmt, arg...)				\
 	printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
-- 
1.8.3.2

