Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1EaUGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 16:06:04 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DE54596.8090003@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
	 <1306870318.29989.0.camel@jlt3.sipsolutions.net>
	 <4DE54596.8090003@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 22:05:57 +0200
Message-ID: <1306872357.29989.2.camel@jlt3.sipsolutions.net> (sfid-20110531_220609_074722_AB16B6D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 21:46 +0200, Felix Fietkau wrote:
> On 2011-05-31 9:31 PM, Johannes Berg wrote:
> > On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
> >
> >>  +	rcu_read_lock();
> >>  +
> >>  +	sta = sta_info_get(sdata, sdata->u.wds.remote_addr);
> >>  +
> >>  +	if (!sta) {
> >>  +		rcu_read_unlock();
> >>  +		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
> >>  +				     GFP_KERNEL);
> >>  +		if (!sta)
> >>  +			return;
> >>  +
> >>  +		new = true;
> >>  +	}
> >
> > ...
> >
> >>  +	rcu_read_unlock();
> >
> > definitely doesn't look right.
> It's a bit weird because in the case of a new sta being allocated, the 
> rcu read lock is acquired by sta_info_insert_rcu, and the code inbetween 
> does not need to be covered by the rcu read lock as the sta entry has 
> not been added to the list yet.
> It should be correct though, unless I'm missing something...

Oh right, I forgot about that.

johannes

