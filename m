Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2LMSXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:23:47 -0500
Message-ID: <1355423047.9463.9.camel@jlt4.sipsolutions.net> (sfid-20121213_192352_293430_50F585FD)
Subject: Re: Add a new work-queue for destructing stations?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 13 Dec 2012 19:24:07 +0100
In-Reply-To: <50CA1C44.5030300@candelatech.com>
References: <50CA1470.4030107@candelatech.com>
	  (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>
	 <50CA1C44.5030300@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 10:19 -0800, Ben Greear wrote:

> > I don't think that's easy, but you're welcome to try. The
> > free_sta_work() function references the sdata so it absolutely must run
> > at this point.

> So, cancel_work_sync(&sdata->work) would appear to remove
> all pending sdata->work items from the work-queue.  As long as
> there are no other different work items that reference
> sdata (and maybe there are..I haven't looked at all of them),
> then we should be safe to execute the free_sta_work()
> on a different work-queue safely, I think....

Sorry, I don't get it. free_sta_work() *itself* has to be executed
before the sdata is destroyed. cancel_work_sync(&sdata->work) has
nothing to do with free_sta_work.

johannes

