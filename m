Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbbLPM4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 07:56:09 -0500
From: "Haim, Maya" <merez@qti.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	qca_merez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] wil6210: fix a warning message condition
Date: Wed, 16 Dec 2015 12:55:58 +0000
Message-ID: <230d7346e47845fca26b7124ba898e20@euamsexm01a.eu.qualcomm.com> (sfid-20151216_135615_463671_16913717)
References: <20151216111000.GC21018@mwanda>
In-Reply-To: <20151216111000.GC21018@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Maya Erez <qca_merez@qca.qualcomm.com>

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, December 16, 2015 1:10 PM
To: qca_merez
Cc: Kalle Valo; linux-wireless@vger.kernel.org; wil6210; kernel-janitors@vger.kernel.org
Subject: [patch] wil6210: fix a warning message condition

"iter" is -1 at the end of the loop and not zero.  It means we don't print a warning message.

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
