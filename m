Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50217 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaFNNvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:51:43 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so3019552pac.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:51:43 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id fe3sm9000107pbd.66.2014.06.14.06.51.41
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:51:42 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/16] rsi: Changed the rsi_set_channel() and rsi_program_bb_rf().
Date: Sat, 14 Jun 2014 19:21:33 +0530
Message-Id: <1402753893-14010-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155145_980962_E72D3C0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Made required changes to rsi_set_channel() and rsi_program_bb_rf()
functions.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c3d8da9..5c122e8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -596,7 +596,7 @@ static int rsi_program_bb_rf(struct rsi_common *common)
 
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
-	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
+	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
 
 	if (common->rf_reset) {
 		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
@@ -849,23 +849,6 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 	rsi_dbg(MGMT_TX_ZONE,
 		"%s: Sending scan req frame\n", __func__);
 
-	if (common->band == IEEE80211_BAND_5GHZ) {
-		if ((channel >= 36) && (channel <= 64))
-			channel = ((channel - 32) / 4);
-		else if ((channel > 64) && (channel <= 140))
-			channel = ((channel - 102) / 4) + 8;
-		else if (channel >= 149)
-			channel = ((channel - 151) / 4) + 18;
-		else
-			return -EINVAL;
-	} else {
-		if (channel > 14) {
-			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
-				__func__, channel, common->band);
-			return -EINVAL;
-		}
-	}
-
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -885,6 +868,7 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 					       (RSI_RF_TYPE << 4));
 
 	mgmt_frame->desc_word[5] = cpu_to_le16(0x01);
+	mgmt_frame->desc_word[6] = cpu_to_le16(0x12);
 
 	if (common->channel_width == BW_40MHZ)
 		mgmt_frame->desc_word[5] |= cpu_to_le16(0x1 << 8);
-- 
1.7.1

