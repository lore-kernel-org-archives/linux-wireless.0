Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40646 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3LEJC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:02:29 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so11017555eae.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:02:28 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/3] nl80211: back to default bitrate_mask correctly
Date: Thu,  5 Dec 2013 10:02:14 +0100
Message-Id: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100235_103267_51BB1059)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of empty NL80211_ATTR_TX_RATES attribute
in nl80211_set_tx_bitrate_mask() function back to
default bitrate mask, to be able to reset the
state.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c6401a8..072b60d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7311,9 +7311,6 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
 
-	if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
-		return -EINVAL;
-
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
@@ -7331,6 +7328,10 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		       sizeof(mask.control[i].mcs));
 	}
 
+	/* Back to default settings */
+	if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
+		goto out;
+
 	/*
 	 * The nested attribute uses enum nl80211_band as the index. This maps
 	 * directly to the enum ieee80211_band values used in cfg80211.
@@ -7380,6 +7381,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		}
 	}
 
+out:
 	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
 }
 
-- 
1.7.9.5

