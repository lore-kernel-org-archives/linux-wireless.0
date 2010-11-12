Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0KLUsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:48:35 -0500
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 12:49:58 -0800
Message-ID: <1289594998.3736.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-12 at 12:07 -0800, greearb@candelatech.com wrote:

> -		flush_work(&sdata->work);
> +		/* Cannot call flush_work here because we are holding
> +		 * RTNL and the worker thread(s) that will be called upon to
> +		 * do the flushing might already be running a piece of work
> +		 * that is blocking on RTNL.  That leads to deadlock and/or
> +		 * OOM.
> +		 */
> +		cancel_work_sync(&sdata->work);

I don't think that comment really belongs into the sources at all ... if
we did that all the time we'd have no sources left between the
comments :-)

However, I also don't think it should be necessary to do this.
sdata->work is always queued on local->workqueue, which is created using
alloc_ordered_workqueue(), and there is no work on this workqueue that
uses the RTNL. Therefore, even flushing the entire workqueue must work,
unless alloc_ordered_workqueue() has no such guarantee any more -- which
I would consider to be a bug in the new workqueue framework.

johannes

