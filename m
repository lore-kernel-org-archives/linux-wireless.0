Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43373 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIG5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:39 -0500
Subject: [PATCH 5/6] ath6kl: remove a warning on a macro
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:35 +0200
Message-ID: <20140309065735.10793.45835.stgit@x230> (sfid-20140309_075742_280751_49EC04BA)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

WARNING: Single statement macros should not use a do {} while (0) loop

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 55c4064..10a89cf 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
 		return -ENOMEM;
 
 #define EPSTAT(name)							\
-	do {								\
-		len = print_endpoint_stat(target, buf, buf_len, len,	\
-					  offsetof(struct htc_endpoint_stats, \
-						   name),		\
-					  #name);			\
-	} while (0)
+	(len = print_endpoint_stat(target, buf, buf_len, len,		\
+				   offsetof(struct htc_endpoint_stats,	\
+					    name),			\
+				   #name))
 
 	EPSTAT(cred_low_indicate);
 	EPSTAT(tx_issued);

