Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0I2SOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:14:41 -0400
Subject: Re: [PATCH 2/2] mac80211:  Don't go off-channel in work_work
 unless needed.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA38155.90306@candelatech.com>
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
	 <1285783383-20822-2-git-send-email-greearb@candelatech.com>
	 <1285783598.3756.31.camel@jlt3.sipsolutions.net>
	 <4CA38155.90306@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 20:14:41 +0200
Message-ID: <1285784081.3756.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 11:11 -0700, Ben Greear wrote:

> >> +	bool went_off_channel = false;
> >
> > Heh, this is not going to work ... the return may be done in a separate
> > invocation of the function. Would have been nice to test this ;-)
> 
> What is a good way to test this?  I brought up several STA interfaces
> and an AP and ran traffic..but I guess I need to do something different?

The work stuff gets invoked when you try to auth, assoc, do off-channel
work, etc... best way is probably to use iw's off-channel command that
translates to a work item here...

johannes

