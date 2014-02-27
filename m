Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64078 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaB0NgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 08:36:23 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so2918299wes.14
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 05:36:21 -0800 (PST)
From: Sylvain Roger Rieuner <sylvain.roger.rieunier@gmail.com>
To: ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] ath9k: fix invalid max frame length
Date: Thu, 27 Feb 2014 14:36:06 +0100
Message-Id: <1393508166-25152-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20140227_143631_416698_89953B84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>

According to 802.11n-2012 standard in paragraph PPDU Fromat(20.3.2) HT-mixed
format  Hearder PPDU contains : L_STF, L_LTF, L_SIG, HT_SIG, HT_STF, HT_LTF
they are symbols in the preamble, there are in time unit(us) that's for why
it can't be computed in bytes

Signed-off-by: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>
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

