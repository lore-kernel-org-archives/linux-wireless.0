Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab1FAPSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 11:18:35 -0400
Date: Wed, 1 Jun 2011 17:17:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwl4965: correctly validate temperature value
Message-ID: <20110601151752.GA9254@redhat.com> (sfid-20110601_171838_874130_81074D62)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases we can read wrong temperature value. If after that
temperature value will not be updated to good one, we badly configure
tx power parameters and device is unable to send a data.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=35932

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f5433c7..f9db25b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1543,7 +1543,7 @@ static void iwl4965_temperature_calib(struct iwl_priv *priv)
 	s32 temp;
 
 	temp = iwl4965_hw_get_temperature(priv);
-	if (temp < 0)
+	if (IWL_TX_POWER_TEMPERATURE_OUT_OF_RANGE(temp))
 		return;
 
 	if (priv->temperature != temp) {
