Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYIXPTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 11:19:34 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] basic background scan
Date: Wed, 24 Sep 2008 17:19:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809241636.38762.hschaa@suse.de> <1222267578.4257.33.camel@johannes.berg>
In-Reply-To: <1222267578.4257.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809241719.28983.hschaa@suse.de> (sfid-20080924_171938_989006_285AB659)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 24. September 2008 16:46:18 schrieb Johannes Berg:
> On Wed, 2008-09-24 at 16:36 +0200, Helmut Schaa wrote:
> > Could somebody please have a look at the TODO comments (I have no idea
> > how to wait until all null-func frames are ACKed)? Thanks.
>
> It's not really possible.

:(

> > +		if (local->bg_scanning) {
> > +			/*
> > +			 * background scan is in progress, notify all associated
> > +			 * access points about us leaving the channel and
> > +			 * update the filter flags
> > +			 */
> > +			local->sw_scanning = 1;
>
> use true/false please

Sure, my fault.

> > +				netif_tx_wake_all_queues(sdata->dev);
>
> This is worsening a problem we already have -- you can enable queues
> that the driver asked to be disabled. Until we fix that, I don't think
> we should tempt our luck even more.

I see! That's really problematic.
Do you have already an idea on how to fix it?

> > -	if (local->sw_scanning || local->hw_scanning)
> > +	if (local->sw_scanning || local->hw_scanning || local->bg_scanning)
>
> I don't really like that. I think these three bools should become an
> enum now.

Agreed.

> And why is sw_scanning false if bg_scanning is true anyway? 

During a background scan the sw_scanning flag is set when a scan phase is
active and unset when an operation phase is active. Therefore I did not need
to adapt all checks for sw_scanning.

Thanks for your comments,
Helmut
