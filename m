Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:50258 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYDASxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:53:23 -0400
Received: by yw-out-2324.google.com with SMTP id 5so261088ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 11:53:14 -0700 (PDT)
Subject: Re: [PATCH] mac80211: fix deadlocks in debugfs_netdev.c
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	linville@tuxdriver.com
In-Reply-To: <1207051350.5143.56.camel@johannes.berg>
References: <47f18973.1498600a.3eb4.ffffbefb@mx.google.com>
	 (sfid-20080401_020142_502048_1A55C83F)  <1207051350.5143.56.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 11:53:12 -0700
Message-Id: <1207075992.7552.3.camel@localhost> (sfid-20080401_195327_911619_5B8C8A72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 14:02 +0200, Johannes Berg wrote:
> On Mon, 2008-03-31 at 15:10 -0700, Luis Carlos Cobo wrote:
> > The bug shows up with CONFIG_PREEMPT enabled. Pointed out by Andrew Morton.
> 
> > @@ -51,13 +53,13 @@ static ssize_t ieee80211_if_write(
> >  
> >  	memset(buf, 0x00, sizeof(buf));
> >  	buf_size = min(count, (sizeof(buf)-1));
> > -	read_lock(&dev_base_lock);
> >  	if (copy_from_user(buf, userbuf, buf_size))
> 
> Do we actually still need all this ieee80211_if_write code? It seems
> that nl80211 can fully replace it now.

Yes we do. We cannot tune mesh parameters (Mesh TTL, auto open peer
links, retries, timeouts, and other dozen parameters) through nl80211. 

As the values for those parameters are not yet defined, these knobs are
very useful for performance analysis.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


