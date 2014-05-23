Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44377 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbaEWNau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 09:30:50 -0400
Message-ID: <1400851841.25946.41.camel@dubbel> (sfid-20140523_153055_388283_14994ADA)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: michal.kazior@tieto.com, linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 16:30:41 +0300
In-Reply-To: <1400851461.4358.40.camel@jlt4.sipsolutions.net>
References: <1400838772.4358.22.camel@jlt4.sipsolutions.net>
	 <1400844793-18069-1-git-send-email-luca@coelho.fi>
	 <1400851461.4358.40.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 1/2] mac80211: add a single-transaction driver op to
 switch contexts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 15:24 +0200, Johannes Berg wrote:
> On Fri, 2014-05-23 at 14:33 +0300, Luca Coelho wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> > 
> > In some cases, when the driver is already using all the channel
> > contexts it can handle at once, we have to do an in-place switch
> > (ie. we cannot afford using an extra context temporarily for the
> > transaction).  But some drivers may not support switching the channel
> > context assigned to a vif on the fly (ie. without unassigning and
> > assigning it) while others may only work if the context is changed on
> > the fly, without unassigning it first.
> > 
> > To allow these different scenarios, add a new driver operation that
> > let's the driver decide how to handle an in-place switch.
> 
> Ok, I've applied this. I extended the warning for the new context (to
> check that it exists in the reassign case) and changed the tracing
> structs slightly (fixing the ifname length and marking the structs
> packed to avoid alignment issues)

Great, thanks!

I was just adding the __packed in the struct, because I am implementing
the parser for trace-cmd and noticed we could have trouble. :)

--
Luca.

