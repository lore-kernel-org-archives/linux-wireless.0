Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:64350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbZKRVT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:19:29 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2443216fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 13:19:35 -0800 (PST)
Subject: Re: mac80211 breaks suspend to disk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258578199.30511.80.camel@johannes.local>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
	 <1258578199.30511.80.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 23:19:30 +0200
Message-ID: <1258579170.4525.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-18 at 22:03 +0100, Johannes Berg wrote: 
> On Wed, 2009-11-18 at 22:39 +0200, Maxim Levitsky wrote:
> 
> > I forgot to pay attention to few lines before the oops message:
> > 
> > 
> > [  331.307139] No probe response from AP 00:1b:9e:d8:77:02 after 500ms, try 1
> > [  331.320121] ------------[ cut here ]------------
> > [  331.334935] WARNING: at /home/maxim/software/kernel/linux-2.6/kernel/timer.c:791 add_timer+0x36/0x40()
> > [  331.347374] Hardware name: Aspire 5720     
> > .....
> 
> Thanks.
> 
> > This reveals that somehow the ieee80211_sta_work manages to run before
> > ieee80211_sta_restart and it sets the timer....
> 
> Indeed.
> 
> > looking at ieee80211_reconfig it seems suspicious that
> > 'local->suspended = false;' is set so early.
> > In fact it is set again to false just prior to 
> > 
> > list_for_each_entry(sdata, &local->interfaces, list) {....
> > 
> > So, I would suspect some lines in this function trigger the work
> > queue.
> 
> No, I doubt it, it's most likely just receiving a frame to trigger the
> function -- ieee80211_sta_rx_mgmt queues the work. If we were still
> suspended then we'd run into an error situation, like the comment in
> ieee80211_reconfig explains ...
> 
> Catch-22.
> 
> Then again, we drop RX frames while local->suspended is true, and I
> guess we don't really care about missing a few more frames when we're
> just waking up, so it should be OK to keep suspended == true while doing
> the startup.
> 
> EXCEPT drivers are going to start using ieee80211_queue_work() already
> then from the callbacks, which we must allow.
> 
> So ... maybe this?


This will likely fix this problem.
I will run my suspend/resume loop for a while and let you know if it
works.

Best regards,
Maxim Levitsky



