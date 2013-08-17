Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:34947 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3HQVgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 17:36:33 -0400
Received: by mail-yh0-f53.google.com with SMTP id b6so514117yha.40
        for <linux-wireless@vger.kernel.org>; Sat, 17 Aug 2013 14:36:32 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] net: rfkill: Check the return value of regulator_enable()
Date: Sat, 17 Aug 2013 18:36:07 -0300
Message-Id: <1376775367-17068-1-git-send-email-festevam@gmail.com> (sfid-20130817_233637_078502_E8973748)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following build warning:

net/rfkill/rfkill-regulator.c:43:20: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 net/rfkill/rfkill-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-regulator.c b/net/rfkill/rfkill-regulator.c
index d11ac79..0aa922c 100644
--- a/net/rfkill/rfkill-regulator.c
+++ b/net/rfkill/rfkill-regulator.c
@@ -30,6 +30,7 @@ struct rfkill_regulator_data {
 static int rfkill_regulator_set_block(void *data, bool blocked)
 {
 	struct rfkill_regulator_data *rfkill_data = data;
+	int ret;
 
 	pr_debug("%s: blocked: %d\n", __func__, blocked);
 
@@ -40,7 +41,9 @@ static int rfkill_regulator_set_block(void *data, bool blocked)
 		}
 	} else {
 		if (!rfkill_data->reg_enabled) {
-			regulator_enable(rfkill_data->vcc);
+			ret = regulator_enable(rfkill_data->vcc);
+			if (ret)
+				return ret;
 			rfkill_data->reg_enabled = true;
 		}
 	}
-- 
1.8.1.2

