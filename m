Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57928 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZHKNNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 09:13:05 -0400
Received: by ewy10 with SMTP id 10so3758729ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 06:13:05 -0700 (PDT)
Message-ID: <4A811464.4030108@gmail.com>
Date: Tue, 11 Aug 2009 08:49:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jmalinen@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Fix read buffer overflow
References: <4A7CA188.1070706@gmail.com> <20090810202622.GB6060@tuxdriver.com>
In-Reply-To: <20090810202622.GB6060@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent a read of powInfo[-1] in the first iteration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index ce0e86c..e67db2c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -150,10 +150,10 @@ static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
 						       IS_CHAN_2GHZ(chan))) {
 				matchIndex = i;
 				break;
-			} else if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						      IS_CHAN_2GHZ(chan))) &&
-				   (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						      IS_CHAN_2GHZ(chan)))) {
+			} else if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						IS_CHAN_2GHZ(chan)) && i > 0 &&
+				   freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						IS_CHAN_2GHZ(chan))) {
 				lowIndex = i - 1;
 				break;
 			}
@@ -268,10 +268,10 @@ static void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				matchIndex = i;
 				break;
 			} else
-				if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						       IS_CHAN_2GHZ(chan))) &&
-				    (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						       IS_CHAN_2GHZ(chan)))) {
+				if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						IS_CHAN_2GHZ(chan)) && i > 0 &&
+				    freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						IS_CHAN_2GHZ(chan))) {
 					lowIndex = i - 1;
 					break;
 				}
