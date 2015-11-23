Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47163 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbbKWEC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 23:02:58 -0500
Date: Sun, 22 Nov 2015 20:02:56 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net,
	kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 1/2] mac80211: add support to set_coalesce
Message-ID: <20151123040255.GA30395@codeaurora.org> (sfid-20151123_050350_956166_DBADE42B)
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
 <1446199181.3261.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446199181.3261.21.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-10-30 10:59:41, Johannes Berg wrote:
> 
> > +++ b/net/mac80211/driver-ops.h
> > @@ -1355,4 +1355,16 @@ static inline void drv_wake_tx_queue(struct 
> > ieee80211_local *local,
> >  	local->ops->wake_tx_queue(&local->hw, &txq->txq);
> >  }
> >  
> > +static inline int drv_set_coalesce(struct ieee80211_local *local,
> > +				   struct cfg80211_coalesce 
> > *coalesce)
> > +{
> > +	u32 ret = 0;
> > 
> This doesn't seem right - now you're accepting any call even if it's
> not really done by the driver?
> 

I assume you mean we need the following check:

if (!local->ops->set_coalesce)
	return -EOPNOTSUPP

-- 
.Olav

The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
