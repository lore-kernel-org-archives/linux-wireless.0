Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46825 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab1D0Lsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:48:47 -0400
Date: Wed, 27 Apr 2011 17:10:11 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110427114010.GA18939@hertz.marvell.com> (sfid-20110427_134852_843381_84A46DFD)
References: <20110415084005.GC11576@hertz.marvell.com>
 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
 <20110415105140.GD11576@hertz.marvell.com>
 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
 <20110421121513.GC27527@hertz.marvell.com>
 <1303389236.3597.8.camel@jlt3.sipsolutions.net>
 <20110421124624.GA29211@hertz.marvell.com>
 <1303390788.3597.10.camel@jlt3.sipsolutions.net>
 <20110427110303.GA18370@hertz.marvell.com>
 <1303903676.3542.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303903676.3542.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 04:27:56AM -0700, Johannes Berg wrote:
> On Wed, 2011-04-27 at 16:33 +0530, Yogesh Ashok Powar wrote:
> > On Thu, Apr 21, 2011 at 05:59:48AM -0700, Johannes Berg wrote:
> > > Well, it kinda goes like this:
> > > 
> > > key added           -> need tailroom code
> > > key put into HW     -> no longer need tailroom code
> > > key removed from HW -> need tailroom code again
> > > key deleted         -> no longer need tailroom code
> > > 
> > Following patch takes care of these four states. Kindly review.
> 
> Looks fine, but still I think it might get out of sync when HW restart
> happens?
How about this?

Thanks
Yogesh

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e180149..ca3c626 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -503,8 +503,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	list_for_each_entry(key, &sdata->key_list, list)
+	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
+
+	list_for_each_entry(key, &sdata->key_list, list) {
+		sdata->local->crypto_tx_tailroom_needed_cnt++;
 		ieee80211_key_enable_hw_accel(key);
+	}
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
