Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbFWTPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 15:15:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwifiex: do not short circuit exit from mwifiex_set_mgmt_ies
Date: Tue, 23 Jun 2015 15:04:03 -0400
Message-Id: <1435086243-10433-1-git-send-email-linville@tuxdriver.com> (sfid-20150623_211523_323296_BCED9BF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this change, the code simply exits after calling
mwifiex_uap_set_head_tail_ies, leving the call to
mwifiex_set_mgmt_beacon_data_ies as dead code.

Coverity CID #1271292

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/ie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 0ba894509413..23e368c77c08 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -409,6 +409,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 	int ret;
 
 	ret = mwifiex_uap_parse_tail_ies(priv, info);
+
+	if (ret)
 		return ret;
 
 	return mwifiex_set_mgmt_beacon_data_ies(priv, info);
-- 
2.1.0

