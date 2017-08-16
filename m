Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36326 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdHPNSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:18:23 -0400
Received: by mail-pg0-f66.google.com with SMTP id y129so5260318pgy.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:18:23 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 08/11] rsi: use common descriptor for auto rate frame
Date: Wed, 16 Aug 2017 18:43:15 +0530
Message-Id: <1502889198-4478-9-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151826_126281_81907190)
In-Reply-To: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame auto rate request is modified to use common
descriptor struture.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 18 +++++++-----------
 drivers/net/wireless/rsi/rsi_mgmt.h     |  2 +-
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 7c0f27a..c5d48cd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1164,8 +1164,9 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	u32 rate_bitmap = common->bitrate_mask[band];
 
 	u16 *selected_rates, min_rate;
+	u16 frame_len = sizeof(struct rsi_auto_rate);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_auto_rate));
+	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
@@ -1180,8 +1181,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_auto_rate));
-
 	auto_rate = (struct rsi_auto_rate *)skb->data;
 
 	auto_rate->aarf_rssi = cpu_to_le16(((u16)3 << 6) | (u16)(18 & 0x3f));
@@ -1190,10 +1189,10 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	auto_rate->initial_boundary = cpu_to_le16(3);
 	auto_rate->max_threshold_limt = cpu_to_le16(27);
 
-	auto_rate->desc_word[1] = cpu_to_le16(AUTO_RATE_IND);
+	auto_rate->desc.desc_dword0.frame_type = AUTO_RATE_IND;
 
 	if (common->channel_width == BW_40MHZ)
-		auto_rate->desc_word[7] |= cpu_to_le16(1);
+		auto_rate->desc.desc_dword3.qid_tid = BW_40MHZ;
 
 	if (band == NL80211_BAND_2GHZ) {
 		min_rate = RSI_RATE_1;
@@ -1259,15 +1258,12 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 
 	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
 	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
-	auto_rate->desc_word[7] |= cpu_to_le16(0 << 8);
 	num_supported_rates *= 2;
 
-	auto_rate->desc_word[0] = cpu_to_le16((sizeof(*auto_rate) -
-					       FRAME_DESC_SZ) |
-					       (RSI_WIFI_MGMT_Q << 12));
+	rsi_set_len_qno(&auto_rate->desc.desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
 
-	skb_put(skb,
-		sizeof(struct rsi_auto_rate));
+	skb_put(skb, frame_len);
 	kfree(selected_rates);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 9c59250..c50153d 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -425,7 +425,7 @@ struct rsi_set_key {
 } __packed;
 
 struct rsi_auto_rate {
-	__le16 desc_word[8];
+	struct rsi_cmd_desc desc;
 	__le16 failure_limit;
 	__le16 initial_boundary;
 	__le16 max_threshold_limt;
-- 
2.7.4
