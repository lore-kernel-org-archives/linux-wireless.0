Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1K2SPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 13:15:33 -0500
Subject: Re: Moving scan logic into work-queue?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4ED520DD.8050606@candelatech.com>
References: <4ED520DD.8050606@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 19:15:31 +0100
Message-ID: <1322590531.4110.29.camel@jlt3.sipsolutions.net> (sfid-20111129_191536_091409_37794517)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 10:13 -0800, Ben Greear wrote:
> We've talked before about moving the scan logic into the work-queue.

I think you mean ieee80211_work, not work-queue.

> Since my previous attempts at optimizing this code for scanning & off-channel
> work didn't stick, I thought I might attempt to convert the scan logic
> to the work-queue, with hopes of then being able to make another attempt
> at optimizing things for multiple interfaces & potentially off-channel work
> items.
> 
> Before I start though, I'm hoping for some guidance on how you'd
> want this implemented.  Or, if you think there are other changes
> that should go in first, I'll wait...

In any case, yes, please don't work on this now. I need to rework auth &
assoc handling completely, and get rid of the work items for that etc.
That will probably mean a large rewrite of the work item logic, possibly
even removing most of that code.

johannes

