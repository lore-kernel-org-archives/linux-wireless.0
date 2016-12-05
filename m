Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43420 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbcLEOyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:54:49 -0500
Message-ID: <1480949686.31788.31.camel@sipsolutions.net> (sfid-20161205_155451_518009_C9755890)
Subject: Re: [PATCH 1/2] mac80211:  Show pending txqlen in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 15:54:46 +0100
In-Reply-To: <58457DF8.5020808@candelatech.com>
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
                 (sfid-20161129_190601_478280_B404B299) <1480946371.31788.7.camel@sipsolutions.net>
         <58457DF8.5020808@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-05 at 06:47 -0800, Ben Greear wrote:
> 
> On 12/05/2016 05:59 AM, Johannes Berg wrote:
> > 
> > +static ssize_t misc_read(struct file *file, char __user *user_buf,
> > > 
> > > +			 size_t count, loff_t *ppos)
> > > +{
> > > +	struct ieee80211_local *local = file->private_data;
> > > +	size_t bufsz = 1000;
> > > +	char *buf = kzalloc(bufsz, GFP_KERNEL);
> > 
> > You need at most IEEE80211_MAX_QUEUES * 16 (==256) which I think
> > you
> > can put on the stack?
> 
> I actually run with 64 queues in my tree, 

Heh, well, in that case the 1000 is actually potentially too small for
you :) (it'll work because there never are many packets on the queues
though)

> and either way, I thought large-ish things on the stack were frowned
> upon for systems that want to run smaller stacks?

Yeah but the limit is more like 1KB :)

Maybe allocate, but actually do 16*NUM_QUEUES? The 1000 is just
arbitrarily magic in there.

johannes
