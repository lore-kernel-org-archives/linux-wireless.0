Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaKUIAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 03:00:24 -0500
Message-ID: <1416556822.2703.4.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141121_090027_589581_06E8081E)
Subject: Re: [PATCH v6] nl80211: Stop scheduled scan if netlink client
 disappears
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Nov 2014 10:00:22 +0200
In-Reply-To: <1416496456.8557.2.camel@sipsolutions.net>
References: <1416483178-5528-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141120_123314_318179_38B7117E) <1416496456.8557.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On to, 2014-11-20 at 16:14 +0100, Johannes Berg wrote:
> On Thu, 2014-11-20 at 13:32 +0200, Jukka Rissanen wrote:
> 
> > - moved owner netlink port id from cfg80211_sched_scan_request to
> >   rdev in order to avoid possible races
> 
> How does that really help though? You're not really locking it anyway.
> 
> I think you should consider keeping it inside the sched_scan_request,
> but maybe make that an __rcu pointer.
> 
> Your patch also still has the problem I pointed out to you before - you
> can get the following sequence of events:
> 
> start_sched_scan (owner=true)
> close socket - schedule worker
> start_sched_scan (from another socket, owner doesn't matter)

If I am reading the code correctly from
nl80211.c:nl80211_start_sched_scan() this socket will get -EINPROGRESS.
Only after the worker has finished and called
__cfg80211_stop_sched_scan() will the other socket able to start a new
scheduled scan. Or I might have just missed some important detail
here :)

> run worker - cancels the new sched_scan
> 
> You need to make sure the worker is flushed in start_sched_scan or so,
> which might require RTNL work there or something.
> 
> johannes
> 


Cheers,
Jukka


