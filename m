Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4527 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1LAMpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 07:45:08 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: clarify max_streams for AR9462
Date: Thu, 1 Dec 2011 18:14:01 +0530
Message-ID: <1322743441-3405-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111201_134512_623033_956333BB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

max_streams for AR9462 is '2'. it does not fixes anything, but
improves the code readability

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e9711e2..41b72fa 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -258,6 +258,8 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	if (AR_SREV_9330(ah) || AR_SREV_9485(ah))
 		max_streams = 1;
+	else if (AR_SREV_9462(ah))
+		max_streams = 2;
 	else if (AR_SREV_9300_20_OR_LATER(ah))
 		max_streams = 3;
 	else
-- 
1.7.0.4

