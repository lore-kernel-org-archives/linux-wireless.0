Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33822 "EHLO sequoia2.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753289Ab3GaTPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:15:08 -0400
Date: Wed, 31 Jul 2013 12:12:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-wireless@vger.kernel.org,
	Derek Atkins <DAtkins@mocana.com>
Subject: [PATCH] mac80211: fix infinite loop in ieee80211_determine_chantype
Message-ID: <20130731191224.GB28308@sequoia2.sous-sol.org> (sfid-20130731_211512_501019_9CB8E323)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130731132625.GA23521@sequoia2.sous-sol.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "3d9646d mac80211: fix channel selection bug" introduced a possible
infinite loop by moving the out target above the chandef_downgrade
while loop.  When we downgrade to NL80211_CHAN_WIDTH_20_NOHT, we jump
back up to re-run the while loop...indefinitely.  Replace goto with
break and carry on.  This may not be sufficient to connect to the AP,
but will at least keep the cpu from livelocking.  Thanks to Derek Atkins
as an extra pair of debugging eyes.

Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5aab1..b68ca05 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -336,7 +336,7 @@ out:
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT;
-			goto out;
+			break;
 		}
 
 		ret |= chandef_downgrade(chandef);
