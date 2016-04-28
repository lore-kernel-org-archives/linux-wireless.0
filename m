Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/11] rtl8xxxu: rename rtl8723a_channel_group() to rtl8xxxu_gen1_channel_to_group()
Date: Thu, 28 Apr 2016 15:19:11 -0400
Message-Id: <1461871155-11826-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211936_961255_C06ACB87)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This function is generic for most (if not all) gen1 parts, so rename
it to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 34f94bb..9b12aed 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1053,7 +1053,7 @@ static void rtl8xxxu_stop_tx_beacon(struct rtl8xxxu_priv *priv)
  *
  * Note: We index from 0 in the code
  */
-static int rtl8723a_channel_to_group(int channel)
+static int rtl8xxxu_gen1_channel_to_group(int channel)
 {
 	int group;
 
@@ -1350,7 +1350,7 @@ rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	u8 val8;
 	int group, i;
 
-	group = rtl8723a_channel_to_group(channel);
+	group = rtl8xxxu_gen1_channel_to_group(channel);
 
 	cck[0] = priv->cck_tx_power_index_A[group] - 1;
 	cck[1] = priv->cck_tx_power_index_B[group] - 1;
-- 
2.5.5

