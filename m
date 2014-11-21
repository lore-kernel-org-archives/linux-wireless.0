Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53362 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaKUJMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:12:01 -0500
Message-ID: <1416561105.1881.0.camel@sipsolutions.net> (sfid-20141121_101239_820381_7838CCD5)
Subject: Re: [PATCH v6] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Nov 2014 10:11:45 +0100
In-Reply-To: <1416556822.2703.4.camel@jrissane-mobl.ger.corp.intel.com>
References: <1416483178-5528-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141120_123314_318179_38B7117E) <1416496456.8557.2.camel@sipsolutions.net>
	 <1416556822.2703.4.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 10:00 +0200, Jukka Rissanen wrote:

> > Your patch also still has the problem I pointed out to you before - you
> > can get the following sequence of events:
> > 
> > start_sched_scan (owner=true)
> > close socket - schedule worker
> > start_sched_scan (from another socket, owner doesn't matter)
> 
> If I am reading the code correctly from
> nl80211.c:nl80211_start_sched_scan() this socket will get -EINPROGRESS.
> Only after the worker has finished and called
> __cfg80211_stop_sched_scan() will the other socket able to start a new
> scheduled scan. Or I might have just missed some important detail
> here :)

Oh, you're right, my mistake.

johannes

