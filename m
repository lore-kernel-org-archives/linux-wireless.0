Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33756 "EHLO sequoia2.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751894Ab3GaRwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 13:52:10 -0400
Date: Wed, 31 Jul 2013 10:49:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-wireless@vger.kernel.org,
	Derek Atkins <DAtkins@mocana.com>
Subject: Re: [PATCH 3.11] mac80211: ignore HT primary channel while connected
Message-ID: <20130731174915.GA28308@sequoia2.sous-sol.org> (sfid-20130731_195213_445935_0F91641C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130731132625.GA23521@sequoia2.sous-sol.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Chris Wright (chrisw@sous-sol.org) wrote:
> 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
> 					IEEE80211_CHAN_DISABLED)) {
> 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
> 			ret = IEEE80211_STA_DISABLE_HT |
> 			      IEEE80211_STA_DISABLE_VHT;
> 			goto out;
> 		}

Actually, it just looks like this above loop is broken.  Code flow is:

	chandef->width = NL80211_CHAN_WIDTH_20;
...
	if (!vht_oper || !sband->vht_cap.vht_supported) {
		ret = IEEE80211_STA_DISABLE_VHT;
		goto out;
	}
...
out:
	/* don't print the message below for VHT mismatch if VHT is disabled */
	if (ret & IEEE80211_STA_DISABLE_VHT)
		vht_chandef = *chandef;

	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
					IEEE80211_CHAN_DISABLED)) {
		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
			ret = IEEE80211_STA_DISABLE_HT |
			      IEEE80211_STA_DISABLE_VHT;
			goto out;
		}

		ret |= chandef_downgrade(chandef);
	}

We enter the while loop w/ width NL80211_CHAN_WIDTH_20
(i.e. ht_cap.ht_supported is true), do one downgrade to
NL80211_CHAN_WIDTH_20_NOHT, and then we are stuck in a permanent loop.
I did not see any way that cfg80211_chandef_usable() will update chandef->width
so once width is NL80211_CHAN_WIDTH_20_NOHT and ht_cap.ht_supported is
true there is no end to the goto loop.

So here is a hack that at least gets wireless working (only because
there's another AP that's not got 11n enabled I believe).

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
