Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46861 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JLKfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 06:35:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k: fill channel mode in caldata
Date: Fri, 12 Oct 2012 14:07:24 +0530
Message-ID: <1350031045-11860-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121012_124456_495046_8EDA81BF)
In-Reply-To: <1350031045-11860-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350031045-11860-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is useful to have channel mode in caldata to find out
whether operaing channel is in HT40/20 when we are currently
on offchannel. It will be used by BTCOEX to enable/disable
concurrent tx mechanism later.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 1 +
 drivers/net/wireless/ath/ath9k/hw.h    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e5cceb0..f3448a0 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -410,6 +410,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1d4f5f1..3e73bfe 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -401,6 +401,7 @@ enum ath9k_int {
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
+	u32 chanmode;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
-- 
1.7.12.2

