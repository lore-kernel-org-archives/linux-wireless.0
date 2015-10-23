Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35802 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbbJWRdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 13:33:01 -0400
From: Punit Vara <punitvara@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, k.eugene.e@gmail.com, bjorn@kryo.se,
	sergei.shtylyov@cogentembedded.com,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH v6 14/15] net: wireless: ath: Remove unneeded variable ret returning 0
Date: Fri, 23 Oct 2015 23:02:42 +0530
Message-Id: <1445621562-7871-1-git-send-email-punitvara@gmail.com> (sfid-20151023_193329_112733_526826EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This warning is reported by coccicheck:

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

