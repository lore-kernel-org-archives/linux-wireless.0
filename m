Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:32774 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965180AbbJVS5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 14:57:52 -0400
From: Punit Vara <punitvara@gmail.com>
To: kvalo@codeaurora.org
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, jirislaby@gmail.com,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH v5 14/15] net: wireless: ath: Remove unneeded variable ret returning 0
Date: Fri, 23 Oct 2015 00:27:34 +0530
Message-Id: <1445540254-4207-1-git-send-email-punitvara@gmail.com> (sfid-20151022_205840_146856_A0ECE3B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove empty line suggested by Sergei

This patch is to the ath5k/eeprom.c that fixes up warning caught by
coccicheck:

Unneeded variable: "ret". Return "0" on line 980

Remove unneeded variable ret created to return zero.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 900e72a..94bcc08 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -935,8 +935,6 @@ static const struct ieee80211_ops wcn36xx_ops = {
 
 static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 {
-	int ret = 0;
-
 	static const u32 cipher_suites[] = {
 		WLAN_CIPHER_SUITE_WEP40,
 		WLAN_CIPHER_SUITE_WEP104,
@@ -977,7 +975,7 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 	wcn->hw->sta_data_size = sizeof(struct wcn36xx_sta);
 	wcn->hw->vif_data_size = sizeof(struct wcn36xx_vif);
 
-	return ret;
+	return 0;
 }
 
 static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
-- 
2.5.3

