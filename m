Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48801 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3EaF3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 01:29:55 -0400
Received: by mail-ie0-f176.google.com with SMTP id at20so2587708iec.7
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 22:29:54 -0700 (PDT)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: johannes.berg@intel.com, wey-yi.w.guy@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH] iwlwifi: fix chain noise calibration
Date: Fri, 31 May 2013 01:29:12 -0400
Message-Id: <1369978152-506-1-git-send-email-mar.kolya@gmail.com> (sfid-20130531_073011_850072_0FBA6033)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First step of chain noise calibration process had disable flag check inverted.
Chain noise calibration never started because of this.

Tested on intel 5300 with two antennas attached. Driver correctly disabled one chain.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 707446f..cd1ad001 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1378,7 +1378,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
-- 
1.8.1.2

