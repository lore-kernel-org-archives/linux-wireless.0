Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:59134 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751455Ab0LVBsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 20:48:15 -0500
Date: Tue, 21 Dec 2010 20:48:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <87ipymwysi.fsf@deeprootsystems.com>
Message-ID: <Pine.LNX.4.44L0.1012212045220.11252-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 21 Dec 2010, Kevin Hilman wrote:

> That being said, another thing we discussed briefly at LPC was wondering
> about reason(s) behind the DPM core locking out runtime PM transitions
> in the first place.

The reason is to prevent confusion from unwanted runtime-PM state 
changes during a system sleep transition.

> Currently runtime PM transitions are blocked in dpm_prepare() and only
> allowed again in dpm_complete().  How about locking out runtime PM
> transitions only until the DPM suspend operation is complete.  IOW,
> rather than waiting for dpm_complete() to re-allow runtime PM
> transitions, what about allowing them after dpm_suspend()?  I haven't
> actually tested this yet, since I'm busy with getting OMAP PM stuff
> ready for the merge window, so it's just and idea so far.  Of course
> similar will be needed to block runtime PM transitions during
> dpm_resume().  

That would defeat the purpose.  We need to prevent unwanted state
changes during the entire sleep transition, not just during the time 
that dpm_suspend is running.

Alan Stern

