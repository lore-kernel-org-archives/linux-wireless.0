Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43933 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbbFZTaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 15:30:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwifiex: fix leak of gen_ie storage on exit from mwifiex_del_mgmt_ies
Date: Fri, 26 Jun 2015 15:29:36 -0400
Message-Id: <1435346976-29030-1-git-send-email-linville@tuxdriver.com> (sfid-20150626_213034_362795_67BBDE83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Storage pointed to by gen_ie is allocated with kmalloc, but was
never freed.

Coverity CID #1271251

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/ie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 23e368c77c08..abf52d25b981 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -479,6 +479,7 @@ int mwifiex_del_mgmt_ies(struct mwifiex_private *priv)
 						   ar_ie, &priv->assocresp_idx);
 
 done:
+	kfree(gen_ie);
 	kfree(beacon_ie);
 	kfree(pr_ie);
 	kfree(ar_ie);
-- 
2.1.0

