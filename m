Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49316 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303Ab1D2TPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:15:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54: avoid uninitialized variable warning for freq
Date: Fri, 29 Apr 2011 15:11:20 -0400
Message-Id: <1304104280-29734-1-git-send-email-linville@tuxdriver.com> (sfid-20110429_211551_522874_72E9FD27)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/p54/eeprom.o
drivers/net/wireless/p54/eeprom.c: In function ‘p54_parse_rssical’:
drivers/net/wireless/p54/eeprom.c:494:8: warning: ‘freq’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54/eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 13d750d..54cc0bb 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -491,7 +491,7 @@ static int p54_parse_rssical(struct ieee80211_hw *dev,
 		struct pda_rssi_cal_entry *cal = (void *) &data[offset];
 
 		for (i = 0; i < entries; i++) {
-			u16 freq;
+			u16 freq = 0;
 			switch (i) {
 			case IEEE80211_BAND_2GHZ:
 				freq = 2437;
-- 
1.7.4.4

