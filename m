Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2GAGqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 02:46:22 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 60g v1 2/5] wireless: rate check logic for 60g
Date: Sun, 1 Jul 2012 09:45:51 +0300
Message-ID: <1341125155-628-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120701_084700_490077_7ECBF4D7)
In-Reply-To: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the 60g band, there is no 'basic rates'. Only MCS used.
Instead of mandatory basic rates, standard requires support for
mandatory MCS 1..4

Modify logic to comply with 60g requirements

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/core.c |   10 ++++++++--
 net/wireless/util.c |    5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 907f62c..e25234d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -458,8 +458,14 @@ int wiphy_register(struct wiphy *wiphy)
 			continue;
 
 		sband->band = band;
-
-		if (WARN_ON(!sband->n_channels || !sband->n_bitrates))
+		if (WARN_ON(!sband->n_channels))
+			return -EINVAL;
+		/*
+		 * on 60gHz band, there are no legacy rates, so
+		 * n_bitrates is 0
+		 */
+		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
+				!sband->n_bitrates))
 			return -EINVAL;
 
 		/*
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f3ce35b..11188c6 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -151,6 +151,11 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 		}
 		WARN_ON(want != 0 && want != 3 && want != 6);
 		break;
+	case IEEE80211_BAND_60GHZ:
+		/* check for mandatory HT MCS 1..4 */
+		WARN_ON(!sband->ht_cap.ht_supported);
+		WARN_ON((sband->ht_cap.mcs.rx_mask[0] & 0x1e) != 0x1e);
+		break;
 	case IEEE80211_NUM_BANDS:
 		WARN_ON(1);
 		break;
-- 
1.7.9.5

