Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38787 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1LTSqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:46:19 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/6] ath6kl: fix sparse warning on init.c
Date: Tue, 20 Dec 2011 10:46:06 -0800
Message-ID: <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194623_608314_FA29900B)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This fixes this sparse warning:

  CC [M]  drivers/net/wireless/ath/ath6kl/init.o
drivers/net/wireless/ath/ath6kl/init.c: In function ‘ath6kl_init_hw_params’:
drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’ may be used uninitialized in this function

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 368ecbd..ef3641b 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1374,7 +1374,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 static int ath6kl_init_hw_params(struct ath6kl *ar)
 {
-	const struct ath6kl_hw *hw;
+	const struct ath6kl_hw *hw = NULL;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
@@ -1390,6 +1390,9 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		return -EINVAL;
 	}
 
+	if (!hw)
+		return -EINVAL;
+
 	ar->hw = *hw;
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT,
-- 
1.7.4.15.g7811d

