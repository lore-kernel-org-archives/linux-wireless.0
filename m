Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47828 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbaKTPOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 10:14:25 -0500
Message-ID: <1416496456.8557.2.camel@sipsolutions.net> (sfid-20141120_161431_016981_3E18F3E1)
Subject: Re: [PATCH v6] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Nov 2014 16:14:16 +0100
In-Reply-To: <1416483178-5528-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141120_123314_318179_38B7117E)
References: <1416483178-5528-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141120_123314_318179_38B7117E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-20 at 13:32 +0200, Jukka Rissanen wrote:

> - moved owner netlink port id from cfg80211_sched_scan_request to
>   rdev in order to avoid possible races

How does that really help though? You're not really locking it anyway.

I think you should consider keeping it inside the sched_scan_request,
but maybe make that an __rcu pointer.

Your patch also still has the problem I pointed out to you before - you
can get the following sequence of events:

start_sched_scan (owner=true)
close socket - schedule worker
start_sched_scan (from another socket, owner doesn't matter)
run worker - cancels the new sched_scan

You need to make sure the worker is flushed in start_sched_scan or so,
which might require RTNL work there or something.

johannes

