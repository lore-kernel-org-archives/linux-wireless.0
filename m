Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:42539 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaEUGom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 02:44:42 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so1606262wes.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 23:44:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: fix list of 5 GHz channels for 802.11n cards
Date: Wed, 21 May 2014 08:44:20 +0200
Message-Id: <1400654661-3595-2-git-send-email-zajec5@gmail.com> (sfid-20140521_084445_740144_8E449DDC)
In-Reply-To: <1400654661-3595-1-git-send-email-zajec5@gmail.com>
References: <1400654661-3595-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom hardware uses a bit tricky hw_value-s for 5 GHz channels,
values 184-228 are used for 4920-5140 MHz center frequencies. Normally
you expect channels 7-16 (e.g. 5060 MHz is channel 12, not 212). We never
meant to register hw_value 228 with freq 6140 MHz (5000 + 228 * 5).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 88ffba2..5d1a5c7 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -208,6 +208,14 @@ static struct ieee80211_channel b43_2ghz_chantable[] = {
 };
 #undef CHAN2G
 
+#define CHAN4G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_5GHZ,		\
+	.center_freq		= 4000 + (5 * (_channel)),	\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
 #define CHAN5G(_channel, _flags) {				\
 	.band			= IEEE80211_BAND_5GHZ,		\
 	.center_freq		= 5000 + (5 * (_channel)),	\
@@ -217,6 +225,18 @@ static struct ieee80211_channel b43_2ghz_chantable[] = {
 	.max_power		= 30,				\
 }
 static struct ieee80211_channel b43_5ghz_nphy_chantable[] = {
+	CHAN4G(184, 0),		CHAN4G(186, 0),
+	CHAN4G(188, 0),		CHAN4G(190, 0),
+	CHAN4G(192, 0),		CHAN4G(194, 0),
+	CHAN4G(196, 0),		CHAN4G(198, 0),
+	CHAN4G(200, 0),		CHAN4G(202, 0),
+	CHAN4G(204, 0),		CHAN4G(206, 0),
+	CHAN4G(208, 0),		CHAN4G(210, 0),
+	CHAN4G(212, 0),		CHAN4G(214, 0),
+	CHAN4G(216, 0),		CHAN4G(218, 0),
+	CHAN4G(220, 0),		CHAN4G(222, 0),
+	CHAN4G(224, 0),		CHAN4G(226, 0),
+	CHAN4G(228, 0),
 	CHAN5G(32, 0),		CHAN5G(34, 0),
 	CHAN5G(36, 0),		CHAN5G(38, 0),
 	CHAN5G(40, 0),		CHAN5G(42, 0),
@@ -260,18 +280,7 @@ static struct ieee80211_channel b43_5ghz_nphy_chantable[] = {
 	CHAN5G(170, 0),		CHAN5G(172, 0),
 	CHAN5G(174, 0),		CHAN5G(176, 0),
 	CHAN5G(178, 0),		CHAN5G(180, 0),
-	CHAN5G(182, 0),		CHAN5G(184, 0),
-	CHAN5G(186, 0),		CHAN5G(188, 0),
-	CHAN5G(190, 0),		CHAN5G(192, 0),
-	CHAN5G(194, 0),		CHAN5G(196, 0),
-	CHAN5G(198, 0),		CHAN5G(200, 0),
-	CHAN5G(202, 0),		CHAN5G(204, 0),
-	CHAN5G(206, 0),		CHAN5G(208, 0),
-	CHAN5G(210, 0),		CHAN5G(212, 0),
-	CHAN5G(214, 0),		CHAN5G(216, 0),
-	CHAN5G(218, 0),		CHAN5G(220, 0),
-	CHAN5G(222, 0),		CHAN5G(224, 0),
-	CHAN5G(226, 0),		CHAN5G(228, 0),
+	CHAN5G(182, 0),
 };
 
 static struct ieee80211_channel b43_5ghz_aphy_chantable[] = {
@@ -295,6 +304,7 @@ static struct ieee80211_channel b43_5ghz_aphy_chantable[] = {
 	CHAN5G(208, 0),		CHAN5G(212, 0),
 	CHAN5G(216, 0),
 };
+#undef CHAN4G
 #undef CHAN5G
 
 static struct ieee80211_supported_band b43_band_5GHz_nphy = {
-- 
1.8.4.5

