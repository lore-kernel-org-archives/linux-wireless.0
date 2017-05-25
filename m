Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34426 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032837AbdEYALo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:44 -0400
Received: by mail-pf0-f171.google.com with SMTP id 9so150118854pfj.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:44 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 12/14] mwifiex: don't open-code ARRAY_SIZE()
Date: Wed, 24 May 2017 17:11:17 -0700
Message-Id: <20170525001119.64791-12-briannorris@chromium.org> (sfid-20170525_021435_767481_DD4D9C9B)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c         | 4 +---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 8 ++------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 5 ++---
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index 1ff22055e54f..cb5027a0195b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -180,11 +180,9 @@ static struct region_code_mapping region_code_mapping_t[] = {
 u8 *mwifiex_11d_code_2_region(u8 code)
 {
 	u8 i;
-	u8 size = sizeof(region_code_mapping_t)/
-				sizeof(struct region_code_mapping);
 
 	/* Look for code in mapping table */
-	for (i = 0; i < size; i++)
+	for (i = 0; i < ARRAY_SIZE(region_code_mapping_t); i++)
 		if (region_code_mapping_t[i].code == code)
 			return region_code_mapping_t[i].region;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 83916c1439af..21333e66ffdc 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -189,9 +189,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 	if (pbitmap_rates != NULL) {
 		rate_scope->hr_dsss_rate_bitmap = cpu_to_le16(pbitmap_rates[0]);
 		rate_scope->ofdm_rate_bitmap = cpu_to_le16(pbitmap_rates[1]);
-		for (i = 0;
-		     i < sizeof(rate_scope->ht_mcs_rate_bitmap) / sizeof(u16);
-		     i++)
+		for (i = 0; i < ARRAY_SIZE(rate_scope->ht_mcs_rate_bitmap); i++)
 			rate_scope->ht_mcs_rate_bitmap[i] =
 				cpu_to_le16(pbitmap_rates[2 + i]);
 		if (priv->adapter->fw_api_ver == MWIFIEX_FW_V15) {
@@ -206,9 +204,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 			cpu_to_le16(priv->bitmap_rates[0]);
 		rate_scope->ofdm_rate_bitmap =
 			cpu_to_le16(priv->bitmap_rates[1]);
-		for (i = 0;
-		     i < sizeof(rate_scope->ht_mcs_rate_bitmap) / sizeof(u16);
-		     i++)
+		for (i = 0; i < ARRAY_SIZE(rate_scope->ht_mcs_rate_bitmap); i++)
 			rate_scope->ht_mcs_rate_bitmap[i] =
 				cpu_to_le16(priv->bitmap_rates[2 + i]);
 		if (priv->adapter->fw_api_ver == MWIFIEX_FW_V15) {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index f1d1f56fc23f..97ac10ea4242 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -298,9 +298,8 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 			priv->bitmap_rates[1] =
 				le16_to_cpu(rate_scope->ofdm_rate_bitmap);
 			for (i = 0;
-			     i <
-			     sizeof(rate_scope->ht_mcs_rate_bitmap) /
-			     sizeof(u16); i++)
+			     i < ARRAY_SIZE(rate_scope->ht_mcs_rate_bitmap);
+			     i++)
 				priv->bitmap_rates[2 + i] =
 					le16_to_cpu(rate_scope->
 						    ht_mcs_rate_bitmap[i]);
-- 
2.13.0.219.gdb65acc882-goog
