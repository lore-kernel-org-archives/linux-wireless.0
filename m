Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7620 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965977AbbFJQdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 12:33:39 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ath5k: use swap() in ath5k_hw_get_median_noise_floor()
Date: Wed, 10 Jun 2015 18:33:34 +0200
Message-Id: <1433954015-24872-1-git-send-email-fabf@skynet.be> (sfid-20150610_183542_446730_29208F9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/ath/ath5k/phy.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 0fce1c7..ef108a3 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1566,17 +1566,13 @@ static s16
 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 {
 	s16 sort[ATH5K_NF_CAL_HIST_MAX];
-	s16 tmp;
 	int i, j;
 
 	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
 	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
 		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
-			if (sort[j] > sort[j - 1]) {
-				tmp = sort[j];
-				sort[j] = sort[j - 1];
-				sort[j - 1] = tmp;
-			}
+			if (sort[j] > sort[j - 1])
+				swap(sort[j], sort[j]);
 		}
 	}
 	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX; i++) {
-- 
2.4.2

