Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40163 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab2B2RSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:18:51 -0500
Subject: [PATCH 02/12] ath6kl: fix checkpatch error with EPSTAT() macro
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:18:45 +0200
Message-ID: <20120229171845.24264.51233.stgit@localhost6.localdomain6> (sfid-20120229_181854_499430_EFB2FC3F)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl/debug.c:739: ERROR: Macros with complex values should be
enclosed in parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 3d0713d..ff4c614 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -737,9 +737,13 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
 		return -ENOMEM;
 
 #define EPSTAT(name)							\
-	len = print_endpoint_stat(target, buf, buf_len, len,		\
-				  offsetof(struct htc_endpoint_stats, name), \
-				  #name)
+	do {								\
+		len = print_endpoint_stat(target, buf, buf_len, len,	\
+					  offsetof(struct htc_endpoint_stats, \
+						   name),		\
+					  #name);			\
+	} while (0)
+
 	EPSTAT(cred_low_indicate);
 	EPSTAT(tx_issued);
 	EPSTAT(tx_pkt_bundled);

