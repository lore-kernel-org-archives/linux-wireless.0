Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3784 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbYCaVdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:33:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Brian Morrison <bdm@fenrir.org.uk>
Subject: [PATCH] cfg80211: add EU regulatory domain
Date: Mon, 31 Mar 2008 17:01:55 -0400
Message-Id: <1206997315-15878-1-git-send-email-linville@tuxdriver.com> (sfid-20080331_223338_206205_85548557)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on initial footwork from Brian Morrison.

Cc: Brian Morrison <bdm@fenrir.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is this worth having?  I'm surprised no one has asked for it until
recently...

Are these values correct?  Including the power and gain values?  Does
anyone know have a link to an authoritative source?

 net/wireless/reg.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8cc6037..998ceb6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -80,6 +80,21 @@ static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
 				     IEEE80211_CHAN_RADAR),
 };
 
+static const struct ieee80211_channel_range ieee80211_EU_channels[] = {
+	/* IEEE 802.11b/g, channels 1..13 */
+	RANGE_PWR(2412, 2472, 27, 6, 0),
+	/* IEEE 802.11a, channel 36*/
+	RANGE_PWR(5180, 5180, 23, 6, 0),
+	/* IEEE 802.11a, channel 40*/
+	RANGE_PWR(5200, 5200, 23, 6, 0),
+	/* IEEE 802.11a, channel 44*/
+	RANGE_PWR(5220, 5220, 23, 6, 0),
+	/* IEEE 802.11a, channels 48..64 */
+	RANGE_PWR(5240, 5320, 23, 6, 0),
+	/* IEEE 802.11a, channels 100..140 */
+	RANGE_PWR(5500, 5700, 23, 6, 0),
+};
+
 #define REGDOM(_code)							\
 	{								\
 		.code = __stringify(_code),				\
@@ -90,6 +105,7 @@ static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
 static const struct ieee80211_regdomain ieee80211_regdoms[] = {
 	REGDOM(US),
 	REGDOM(JP),
+	REGDOM(EU),
 };
 
 
-- 
1.5.3.3

