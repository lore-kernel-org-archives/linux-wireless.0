Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:14543 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYKAXiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:38:21 -0400
Received: by ey-out-2122.google.com with SMTP id 6so664662eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 16:38:19 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4] rt2x00: Remove RATE_BASIC flag
Date: Sun, 2 Nov 2008 00:36:40 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811020036.40746.IvDoorn@gmail.com> (sfid-20081102_003834_083429_D474A4C2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 is in charge of determining the basic rates,
so we are not using the RATE_BASIC flag anymore.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt2x00lib.h |    1 -
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 477a944..a8fee68 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -717,31 +717,31 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
  */
 const struct rt2x00_rate rt2x00_supported_rates[12] = {
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_BASIC,
+		.flags = DEV_RATE_CCK,
 		.bitrate = 10,
 		.ratemask = BIT(0),
 		.plcp = 0x00,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 20,
 		.ratemask = BIT(1),
 		.plcp = 0x01,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 55,
 		.ratemask = BIT(2),
 		.plcp = 0x02,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 110,
 		.ratemask = BIT(3),
 		.plcp = 0x03,
 	},
 	{
-		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
+		.flags = DEV_RATE_OFDM,
 		.bitrate = 60,
 		.ratemask = BIT(4),
 		.plcp = 0x0b,
@@ -753,7 +753,7 @@ const struct rt2x00_rate rt2x00_supported_rates[12] = {
 		.plcp = 0x0f,
 	},
 	{
-		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
+		.flags = DEV_RATE_OFDM,
 		.bitrate = 120,
 		.ratemask = BIT(6),
 		.plcp = 0x0a,
@@ -765,7 +765,7 @@ const struct rt2x00_rate rt2x00_supported_rates[12] = {
 		.plcp = 0x0e,
 	},
 	{
-		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
+		.flags = DEV_RATE_OFDM,
 		.bitrate = 240,
 		.ratemask = BIT(8),
 		.plcp = 0x09,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 9f214f8..c52ee21 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -43,7 +43,6 @@ struct rt2x00_rate {
 #define DEV_RATE_CCK			0x0001
 #define DEV_RATE_OFDM			0x0002
 #define DEV_RATE_SHORT_PREAMBLE		0x0004
-#define DEV_RATE_BASIC			0x0008
 
 	unsigned short bitrate; /* In 100kbit/s */
 	unsigned short ratemask;
-- 
1.5.6.1

