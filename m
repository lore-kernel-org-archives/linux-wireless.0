Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51571 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab1DBROP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 13:14:15 -0400
Received: by ewy4 with SMTP id 4so1337839ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Apr 2011 10:14:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/13 v2] rt2x00: Restructure bw_comp calculation
Date: Sat, 2 Apr 2011 19:14:09 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281331.00838.IvDoorn@gmail.com> <201103281331.31575.IvDoorn@gmail.com>
In-Reply-To: <201103281331.31575.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104021914.10117.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Move the HT40 check inside the calculation function to make it easier
for a later cleanup.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
v2: Fix subject
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2ee6ceb..2f8af7a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1819,11 +1819,15 @@ static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	u8 comp_en;
 	u8 comp_type;
-	int comp_value;
+	int comp_value = 0;
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_DELTA, &eeprom);
 
-	if (eeprom == 0xffff)
+	/*
+	 * HT40 compensation not required.
+	 */
+	if (eeprom == 0xffff ||
+	    !test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
 		return 0;
 
 	if (band == IEEE80211_BAND_2GHZ) {
@@ -1865,13 +1869,12 @@ static u8 rt2800_compesate_txpower(struct rt2x00_dev *rt2x00dev,
 	u8 eirp_txpower;
 	u8 eirp_txpower_criterion;
 	u8 reg_limit;
-	int bw_comp = 0;
+	int bw_comp;
 
 	if (!((band == IEEE80211_BAND_5GHZ) && is_rate_b))
 		return txpower;
 
-	if (test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
-		bw_comp = rt2800_get_txpower_bw_comp(rt2x00dev, band);
+	bw_comp = rt2800_get_txpower_bw_comp(rt2x00dev, band);
 
 	if (test_bit(CONFIG_SUPPORT_POWER_LIMIT, &rt2x00dev->flags)) {
 		/*
-- 
1.7.2.3

