Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:57722 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3FZGzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:55:00 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
CC: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix 5ghz channel definitions
Date: Wed, 26 Jun 2013 08:54:54 +0200
Message-ID: <1372229694-6769-1-git-send-email-michal.kazior@tieto.com> (sfid-20130626_085509_367476_D8743563)
In-Reply-To: <1372060350-31460-3-git-send-email-michal.kazior@tieto.com>
References: <1372060350-31460-3-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nonsense channel flags were being set.

Although it doesn't seem this was visible to the
user the patch makes sure that channel
availability won't be crippled in the future if
ath_common behaviour changes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   48 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4867f30..441a3e7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2798,30 +2798,30 @@ static const struct ieee80211_channel ath10k_2ghz_channels[] = {
 };
 
 static const struct ieee80211_channel ath10k_5ghz_channels[] = {
-	CHAN5G(36, 5180, 14),
-	CHAN5G(40, 5200, 15),
-	CHAN5G(44, 5220, 16),
-	CHAN5G(48, 5240, 17),
-	CHAN5G(52, 5260, 18),
-	CHAN5G(56, 5280, 19),
-	CHAN5G(60, 5300, 20),
-	CHAN5G(64, 5320, 21),
-	CHAN5G(100, 5500, 22),
-	CHAN5G(104, 5520, 23),
-	CHAN5G(108, 5540, 24),
-	CHAN5G(112, 5560, 25),
-	CHAN5G(116, 5580, 26),
-	CHAN5G(120, 5600, 27),
-	CHAN5G(124, 5620, 28),
-	CHAN5G(128, 5640, 29),
-	CHAN5G(132, 5660, 30),
-	CHAN5G(136, 5680, 31),
-	CHAN5G(140, 5700, 32),
-	CHAN5G(149, 5745, 33),
-	CHAN5G(153, 5765, 34),
-	CHAN5G(157, 5785, 35),
-	CHAN5G(161, 5805, 36),
-	CHAN5G(165, 5825, 37),
+	CHAN5G(36, 5180, 0),
+	CHAN5G(40, 5200, 0),
+	CHAN5G(44, 5220, 0),
+	CHAN5G(48, 5240, 0),
+	CHAN5G(52, 5260, 0),
+	CHAN5G(56, 5280, 0),
+	CHAN5G(60, 5300, 0),
+	CHAN5G(64, 5320, 0),
+	CHAN5G(100, 5500, 0),
+	CHAN5G(104, 5520, 0),
+	CHAN5G(108, 5540, 0),
+	CHAN5G(112, 5560, 0),
+	CHAN5G(116, 5580, 0),
+	CHAN5G(120, 5600, 0),
+	CHAN5G(124, 5620, 0),
+	CHAN5G(128, 5640, 0),
+	CHAN5G(132, 5660, 0),
+	CHAN5G(136, 5680, 0),
+	CHAN5G(140, 5700, 0),
+	CHAN5G(149, 5745, 0),
+	CHAN5G(153, 5765, 0),
+	CHAN5G(157, 5785, 0),
+	CHAN5G(161, 5805, 0),
+	CHAN5G(165, 5825, 0),
 };
 
 static struct ieee80211_rate ath10k_rates[] = {
-- 
1.7.9.5

