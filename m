Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 14/16] rtl8xxxu: Rename rtl8723b_channel_to_group()
Date: Mon, 18 Apr 2016 11:49:34 -0400
Message-Id: <1460994576-24091-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180722_116429_92E7C60C)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This renames rtl8723b_channel_to_group() to
rtl8xxxu_gen2_channel_to_group() to reflect it is used by all
currently supported gen2 parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index fb13a77..bec2c4d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2201,7 +2201,7 @@ static int rtl8723a_channel_to_group(int channel)
 /*
  * Valid for rtl8723bu and rtl8192eu
  */
-static int rtl8723b_channel_to_group(int channel)
+static int rtl8xxxu_gen2_channel_to_group(int channel)
 {
 	int group;
 
@@ -2613,7 +2613,7 @@ rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	int group, tx_idx;
 
 	tx_idx = 0;
-	group = rtl8723b_channel_to_group(channel);
+	group = rtl8xxxu_gen2_channel_to_group(channel);
 
 	cck = priv->cck_tx_power_index_B[group];
 	val32 = rtl8xxxu_read32(priv, REG_TX_AGC_A_CCK1_MCS32);
@@ -2652,7 +2652,7 @@ rtl8192e_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	int group, tx_idx;
 
 	tx_idx = 0;
-	group = rtl8723b_channel_to_group(channel);
+	group = rtl8xxxu_gen2_channel_to_group(channel);
 
 	cck = priv->cck_tx_power_index_A[group];
 
-- 
2.5.5

