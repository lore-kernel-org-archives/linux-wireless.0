Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:43230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0KLKLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 05:11:15 -0500
Message-ID: <4CDD12BD.7030208@kernel.org>
Date: Fri, 12 Nov 2010 11:11:09 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com> <4CDC354C.2060503@candelatech.com> <4CDC7860.3070307@candelatech.com>
In-Reply-To: <4CDC7860.3070307@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 11/12/2010 12:12 AM, Ben Greear wrote:
> The lockup (or extreme slowdown?) happens before the
> serious memory pressure.
> 
> One thing I noticed is that at one point near (at?) the beginning
> of the slowdown, it took 36-seconds to complete the
> flush_work() call in ieee80211_do_stop in iface.c
> 
> From some printk's I added:
> 
> Nov 11 14:58:13 localhost kernel: do_stop: sta14 flushing work: e51298b4
> Nov 11 14:58:49 localhost kernel: do_stop: sta14 flushed.
> 
> It is holding RTNL for this entire time, which of course stops
> a large number of other useful processes from making
> progress.
> 
> Is there any good reason for the flush to take so long?

It depends on what the work being flushed was doing.  Which one is it
trying to flush?  Also, if the memory pressure is high enough, due to
the dynamic nature of workqueue, processing of works can be delayed
while trying to create new workers to process them.  Situations like
that usually don't happen often as it's likely that workers get freed
up as other works finish; however, if workers are piling up on
rtnl_lock, there really isn't much it can do.  If there's work user
which can behave like that, it would be a good idea to restrict its
maximum concurrency using a separate workqueue.

Thanks.

-- 
tejun
