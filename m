Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2DTMNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 08:13:45 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH v2] cfg80211: Validate legacy rateset.
Date: Fri, 20 Apr 2012 17:43:21 +0530
Message-ID: <1334924001-8584-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120420_141349_224433_434B8225)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy rates are not validated while configuring
tx rateset using iw. So below cmd is accepted by nl80211.
sudo iw wlan2 set bitrates legacy-2.4 1 2 3

Validate legacy rates and return
error if any rate in the rateset is not valid.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 net/wireless/nl80211.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bcf6f70..f822e7c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5577,6 +5577,9 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 				sband,
 				nla_data(tb[NL80211_TXRATE_LEGACY]),
 				nla_len(tb[NL80211_TXRATE_LEGACY]));
+			if (mask.control[band].legacy == 0 &&
+				nla_len(tb[NL80211_TXRATE_LEGACY]))
+				return -EINVAL;
 		}
 		if (tb[NL80211_TXRATE_MCS]) {
 			if (!ht_rateset_to_mask(
-- 
1.7.4.1

