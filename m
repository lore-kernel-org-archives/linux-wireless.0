Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1DGLvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 07:51:23 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before
 entering power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	 <1301658705.3832.21.camel@jlt3.sipsolutions.net>
	 <AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
	 <1302172435.3779.2.camel@jlt3.sipsolutions.net>
	 <BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 13:51:21 +0200
Message-ID: <1302177081.3779.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-07 at 17:17 +0530, Vivek Natarajan wrote:

> > I'm not sure I understand. Where does the 100ms come from? This code
> > flushes the TX queues, which can take as much time as it wants, no? How
> > does it break applications?
> 
> 100ms is the time after which the dynamic ps timer stops the netif
> queues and flushes all the frames in the driver. Actually two factors
> caused the application to timeout:
>  One is the delay in the flush() for which the netif queues are
> stopped and eventually the application could not send out the frames.
> The second is the dropping of frames in the flush() callback when it
> reaches the timeout period.

Is that an ath9k specific thing? mac80211 never invokes flush() with
drop=true, at this point. I thought we needed it and added it, but I
guess we don't really need it.

johannes


