Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0DFJIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:08:04 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270544765.3929.2.camel@jlt3.sipsolutions.net>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1270544765.3929.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 11:08:00 +0200
Message-ID: <1270544880.3929.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 11:06 +0200, Johannes Berg wrote:

> > -	if (list_empty(&local->work_list) && local->scan_req)
> > +	mutex_lock(&local->scan_mtx);
> > +
> > +	if (list_empty(&local->work_list) && local->scan_req &&
> > +	    !local->scanning)
> >  		ieee80211_queue_delayed_work(&local->hw,
> >  					     &local->scan_work,
> >  					     round_jiffies_relative(0));
> >  
> > +	mutex_unlock(&local->scan_mtx);
> > +
> >  	mutex_unlock(&local->work_mtx);
> 
> That really doesn't look right ... at all.

Oops, confused the two locks.

Still though, wouldn't the scan work simply not do anything?

johannes

