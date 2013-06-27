Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59019 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3F0SAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 14:00:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath10k: minimally handle new channel width enumeration values
Date: Thu, 27 Jun 2013 13:52:18 -0400
Message-Id: <1372355538-19284-1-git-send-email-linville@tuxdriver.com> (sfid-20130627_200027_969624_B40AA75A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

  CC      drivers/net/wireless/ath/ath10k/mac.o
drivers/net/wireless/ath/ath10k/mac.c: In function ‘chan_to_phymode’:
drivers/net/wireless/ath/ath10k/mac.c:229:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_5’ not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/mac.c:229:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_10’ not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/mac.c:247:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_5’ not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/mac.c:247:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_10’ not handled in switch [-Wswitch]

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 95e306e..da5c333 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -236,6 +236,8 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 		case NL80211_CHAN_WIDTH_40:
 			phymode = MODE_11NG_HT40;
 			break;
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
 		case NL80211_CHAN_WIDTH_80:
 		case NL80211_CHAN_WIDTH_80P80:
 		case NL80211_CHAN_WIDTH_160:
@@ -257,6 +259,8 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 		case NL80211_CHAN_WIDTH_80:
 			phymode = MODE_11AC_VHT80;
 			break;
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
 		case NL80211_CHAN_WIDTH_80P80:
 		case NL80211_CHAN_WIDTH_160:
 			phymode = MODE_UNKNOWN;
-- 
1.8.1.4

