Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62821 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaBZPKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 10:10:03 -0500
Received: by mail-we0-f170.google.com with SMTP id w62so1773269wes.15
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 07:10:02 -0800 (PST)
From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
To: ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] ath9k : ath_max_famelen
Date: Wed, 26 Feb 2014 16:09:14 +0100
Message-Id: <1393427354-29314-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20140226_161013_998990_97877601)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11n-2012 standard in paragraph PPDU Fromat(20.3.2) HT-mixed
format  Hearder PPDU contains : L_STF, L_LTF, L_SIG, HT_SIG, HT_STF, HT_LTF that
for why it's a time(us) and not a bytes unit

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 312314c..544186e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1040,11 +1040,11 @@ static int ath_max_framelen(int usec, int mcs, bool ht40, bool sgi)
 	int symbols, bits;
 	int bytes = 0;
 
+	usec -= L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
 	symbols = sgi ? TIME_SYMBOLS_HALFGI(usec) : TIME_SYMBOLS(usec);
 	bits = symbols * bits_per_symbol[mcs % 8][ht40] * streams;
 	bits -= OFDM_PLCP_BITS;
 	bytes = bits / 8;
-	bytes -= L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
 	if (bytes > 65532)
 		bytes = 65532;
 
-- 
1.7.10.4

