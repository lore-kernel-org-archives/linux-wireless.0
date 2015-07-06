Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4099 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbbGFHk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:28 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 05/13] wil6210: print "ulong" fields in hex format in the debugfs
Date: Mon,  6 Jul 2015 10:39:41 +0300
Message-Id: <1436168389-3676-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_094042_329165_29D979CA)
In-Reply-To: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the debugfs, there is "ulong" attribute printing. It is used for
bitmap printing, and more appropriate format would be hexadecimal,
not decimal.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 9ed1a94..4cdc5e2 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -306,7 +306,7 @@ static int wil_debugfs_ulong_get(void *data, u64 *val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(wil_fops_ulong, wil_debugfs_ulong_get,
-			wil_debugfs_ulong_set, "%llu\n");
+			wil_debugfs_ulong_set, "0x%llx\n");
 
 static struct dentry *wil_debugfs_create_ulong(const char *name, umode_t mode,
 					       struct dentry *parent,
-- 
2.1.4

