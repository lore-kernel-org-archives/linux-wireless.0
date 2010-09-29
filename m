Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0I2RD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:03:57 -0400
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA3704E.1070702@candelatech.com>
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
	 <1285743733.3756.3.camel@jlt3.sipsolutions.net>
	 <4CA35BAB.8090701@candelatech.com>
	 <1285778901.3756.25.camel@jlt3.sipsolutions.net>
	 <4CA3704E.1070702@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 19:03:56 +0200
Message-ID: <1285779836.3756.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 09:58 -0700, Ben Greear wrote:

> >> +			if (!(wk->chan == local->scan_channel ||
> >> +			      (wk->chan == local->oper_channel&&
> >
> > I don't think work items will ever run while scanning? And also, this
> > might need to check the channel type as well, which isn't quite
> > necessary right now (since no works requires HT channels) but would seem
> > cleaner.
> 
> Just in case work ever does happen when scanning, I think we should
> leave this check in.

I think we'll have bigger problems if that happens, since scanning will
switch away from the channel again quickly, likely before the work
finishes. I'd rather add an assertion that it _doesn't_ happen, I think.

johannes

