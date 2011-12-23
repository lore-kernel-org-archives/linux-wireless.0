Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:41892 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068Ab1LWIqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 03:46:15 -0500
Received: by lagy4 with SMTP id y4so242382lag.32
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 00:46:10 -0800 (PST)
Subject: Re: [PATCH v2 0/2] report stop sched scan when actually done
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324480244.3401.6.camel@jlt3.sipsolutions.net>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
	 (sfid-20111221_111141_897967_3E904A2C)  <1324480244.3401.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 10:46:06 +0200
Message-ID: <1324629966.2182.317.camel@cumari> (sfid-20111223_094621_592350_CC49F509)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-21 at 16:10 +0100, Johannes Berg wrote: 
> On Wed, 2011-12-21 at 12:11 +0200, Eyal Shapira wrote:
> > Changes in mac/cfg80211 to notify userspace
> > of NL80211_CMD_SCHED_SCAN_STOPPED only when the driver
> > actually reported back that it was stopped. Also
> > blocks other attempts until we're really done.
> > 
> > This fixes a scenario where stop sched scan
> > is issued and immediately afterwards a new sched scan
> > is requested (e.g. with other parameters).
> > Current state caused a race where the driver started
> > stopping the sched scan but didn't finish and got
> > another sched scan request which it couldn't handle.
> 
> Luca really needs to take a close look at this, and I think you should
> also take a look to see if this kind of API change can be avoided.

I had discussed this with Eyal briefly and at first it seemed ok.  But
actually I now agree that this is an API change.

Looking closer, I see that in the current documentation, there's nothing
stating that after sending sched_scan_stop the userspace needs to wait
for the stopped event.  It just says that "[this] event is also sent
when the %NL80211_CMD_STOP_SCHED_SCAN command is received [...]".
Applications may assume that after the stop command completes, it is
really stopped, without waiting for the stopped event.

Could the code be changed so that we delay the STOP_SCHED_SCAN command
completion instead? Then userspace can rely on that (as it should
anyway, because the command can fail) instead of having to wait for the
stopped event (which is a change in the API).

-- 
Cheers,
Luca.

