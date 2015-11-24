Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34907 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbKXIVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 03:21:48 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] libertas: check for NULL before use
Date: Tue, 24 Nov 2015 13:51:38 +0530
Message-Id: <1448353298-16110-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20151124_092207_995856_248FEBDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If kzalloc fails it will return NULL. Lets check for NULL first before
using the pointer.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v2: commit message changed

 drivers/net/wireless/marvell/libertas/cfg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 8317afd..e38ad1d 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1108,7 +1108,7 @@ static int lbs_associate(struct lbs_private *priv,
 	size_t len, resp_ie_len;
 	int status;
 	int ret;
-	u8 *pos = &(cmd->iebuf[0]);
+	u8 *pos;
 	u8 *tmp;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
@@ -1117,6 +1117,7 @@ static int lbs_associate(struct lbs_private *priv,
 		ret = -ENOMEM;
 		goto done;
 	}
+	pos = &cmd->iebuf[0];
 
 	/*
 	 * cmd              50 00
-- 
1.9.1

