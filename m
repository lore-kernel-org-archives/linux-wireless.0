Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3628 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0KZTuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 14:50:32 -0500
Date: Fri, 26 Nov 2010 14:37:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Octav Chipara <ochipara@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: help with ath5k --- wlan0 no private ioctls
Message-ID: <20101126193754.GB5815@hash.localnet>
References: <AANLkTikCQPq-HVUJhDet-ZbA97nt+1uYTKgtzvK2cyd7@mail.gmail.com> <AANLkTikgkBZPEVOuZQHeJSXiiwBsVgMOGxRwOu315Vn4@mail.gmail.com> <AANLkTikMDT5qXrNZSdwsZDE6_rCcHnbv9pCWpHVaZo3K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikMDT5qXrNZSdwsZDE6_rCcHnbv9pCWpHVaZo3K@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 09:09:25AM -0800, Octav Chipara wrote:
> HI,
> 
> > Hmm, someone can correct me if I'm wrong, but according to my
> > reading of the code, minstrel only uses hw->max_rate_tries
> > and not wiphy->retry_{short,long}.  Also it looks like the only
> > drivers that poke at these values only use it for failure
> > indication when they don't support accurate tx status reporting.
> >
> 
> Is there an easy way to control them? Can you set it through iwconfig?

No, you can easily patch the driver but this is ostensibly a
hardware-specific setting (although in ath5k it is more or less
arbitrary).

You can use pid controller, or maybe try this completely untested patch.
Again this is only based on a glance at the code, I do not know if this
is a real diagnosis of your issue.

From: Bob Copeland <me@bobcopeland.com>
Date: Fri, 26 Nov 2010 14:28:35 -0500
Subject: [PATCH] mac80211: minstrel: honor max retry counts from cfg80211

We may configure dot11{Short,Long}RetryLimit in addition to whatever
the hardware sets up as the maximum frame retry limit.  The pid
controller used these values but minstrel did not.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/rc80211_minstrel.c |    9 +++++++--
 net/mac80211/rc80211_minstrel.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 778c604..cf5393d 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -424,10 +424,10 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 			tx_time_cts += tx_time_single + mi->sp_ack_dur;
 			tx_time_rtscts += tx_time_single + 2 * mi->sp_ack_dur;
 			if ((tx_time_cts < mp->segment_size) &&
-				(mr->retry_count_cts < mp->max_retry))
+				(mr->retry_count_cts < mp->max_long_retry))
 				mr->retry_count_cts++;
 			if ((tx_time_rtscts < mp->segment_size) &&
-				(mr->retry_count_rtscts < mp->max_retry))
+				(mr->retry_count_rtscts < mp->max_long_retry))
 				mr->retry_count_rtscts++;
 		} while ((tx_time < mp->segment_size) &&
 				(++mr->retry_count < mp->max_retry));
@@ -526,6 +526,11 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 		/* safe default, does not necessarily have to match hw properties */
 		mp->max_retry = 7;
 
+	mp->max_long_retry = min(mp->max_retry,
+		(unsigned int) hw->conf.long_frame_max_tx_count);
+	mp->max_retry = min(mp->max_retry,
+		(unsigned int) hw->conf.short_frame_max_tx_count);
+
 	if (hw->max_rates >= 4)
 		mp->has_mrr = true;
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 0f5a833..5079b88 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -73,6 +73,7 @@ struct minstrel_priv {
 	unsigned int cw_min;
 	unsigned int cw_max;
 	unsigned int max_retry;
+	unsigned int max_long_retry;
 	unsigned int ewma_level;
 	unsigned int segment_size;
 	unsigned int update_interval;
-- 
1.5.6.5

-- 
Bob Copeland %% www.bobcopeland.com

