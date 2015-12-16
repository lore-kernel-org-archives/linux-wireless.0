Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26047 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806AbbLPLKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 06:10:11 -0500
Date: Wed, 16 Dec 2015 14:10:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com, kernel-janitors@vger.kernel.org
Subject: [patch] wil6210: fix a warning message condition
Message-ID: <20151216111000.GC21018@mwanda> (sfid-20151216_121019_683348_9CB3F4AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"iter" is -1 at the end of the loop and not zero.  It means we don't
print a warning message.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 48687f1..4544e8c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -985,7 +985,7 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 	mutex_lock(&wil->mutex);
 
-	if (!iter)
+	if (iter < 0)
 		wil_err(wil, "timeout waiting for idle FW/HW\n");
 
 	wil_reset(wil, false);
