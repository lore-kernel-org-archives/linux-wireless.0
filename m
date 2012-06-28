Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10381 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2F1LR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:17:56 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [RFC 60g 2/5] wireless: rate check logic for 60g
Date: Thu, 28 Jun 2012 14:16:57 +0300
Message-ID: <1340882220-31768-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120628_131759_318555_7C6D3DF7)
In-Reply-To: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index 907f62c..bef6dbe 100644
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
+		    !sband->n_bitrates))
 			return -EINVAL;
 
 		/*
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 5c7195e..98b2a8d 100644
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

