Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2C0L7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 07:59:31 -0400
Message-ID: <1332849568.3938.7.camel@jlt3.sipsolutions.net> (sfid-20120327_135934_959781_7AC951B3)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 Mar 2012 13:59:28 +0200
In-Reply-To: <4F71A7AE.3050405@tieto.com>
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
				 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
			 <4F6C82A5.5080302@tieto.com>
		 <1332513075.10384.20.camel@jlt3.sipsolutions.net>
		 <4F7060C2.9070206@tieto.com>
	 <1332765914.5435.7.camel@jlt3.sipsolutions.net>
	 <4F71A7AE.3050405@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-27 at 13:42 +0200, Michal Kazior wrote:

> >> But how do we then check if we need to stop given queue or not? Let's
> >> say a driver stops q=2 which corresponds to BE on vif0 and vif1. But
> >> then comes mac80211 aggregation and stops BE on vif0. I can only think
> >> of a single solution to that: "u8 lock_reasons[256];" in ieee80211_local
> >> but it seems like an overkill or is it not?
> >
> > Essentially that's what I was considering, we'd maintain all the queue
> > state per HW queue ID. I said it would be a u8 for the HW queue ID, but
> > I don't see anyone using more than say 32 or so, so we wouldn't really
> > need 256. But we could go up to 256 if needed (though at that point we
> > should probably do dynamic allocation instead.)
> 
> We could maybe allocate it according to hw.queues? I think it should be 
> okay unless a driver has some kind of non-static queues. Are you aware 
> of such a device/driver?

Yeah, we could do that. I'm not sure I want the complexity though, if
the limit is going to be something like 16 (I said 32 before but now
think for our current use 16 would be sufficient) I don't see much value
in dynamically allocating over just reserving space for 16.

johannes

