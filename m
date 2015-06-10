Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbbFJMfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 08:35:52 -0400
Message-ID: <1433939749.3145.6.camel@sipsolutions.net> (sfid-20150610_143555_472528_13275EA0)
Subject: Re: [PATCH] cfg80211: check correct maximum bandwidth for quarter
 and half rate.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Jun 2015 14:35:49 +0200
In-Reply-To: <55782CE5.9010300@neratec.com>
References: <1433863625-30579-1-git-send-email-matthias.may@neratec.com>
		 (sfid-20150609_173523_482237_45077999) <1433881789.1892.29.camel@sipsolutions.net>
	 <55782CE5.9010300@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 14:26 +0200, Matthias May wrote:

> I'm not sure what exactly you mean that the handle_channel_custom needs 
> to loop through 5/10/20.
> The freq_reg_info_regd sets the disabled flag on the channel at init.

That's kinda my point - this isn't true. freg_req_info_regd() *doesn't*
change any channel flags, it just returns some information, and through
freq_reg_info() this is even exported to drivers.

> This is not while trying to start operation on a channel, because the 
> channel is already disabled.
> Or do you mean to actually have different sets of flags for the 
> different bandwidths?

I mean basically what you did below, except handle it explicitly at the
outer level.

> I see that it's erroneously possible to run a 10/20MHz channel on 5175, 
> even though this shouldn't be allowed.
> However setting the proper flags bw_flags should fix this.
> 
> Expanding the patch with the patch below ensures that one can't start 
> operation on a channel which it's not allowed on.
> Or is there a better way?

I was thinking you should extend freq_reg_info_regd() to get the desired
bandwidth, in which case you'd have to call it three times (5, 10, 20).

However, you could also make the API so that freq_reg_info_regd() gets
the *minimum* bandwidth [that the caller is willing to handle].

That way, you could set the argument to 20 MHz (for now) in
freq_reg_info(), and to 5 MHz in the other callers that you're modifying
(with the proposed additional patch) to actually handle the returned
bandwidth lower than 20 MHz.



This is really the crux of the problem - with your patch,
freq_reg_info_regd() and thus freq_reg_info() can return something that
doesn't fit the requested channel. You're changing the semantics of this
function to no longer mean "return the rule that fits a 20MHz channel
around the given center frequency" but to mean "return a rule around the
given center frequency" - no matter how wide that rule can allow
channels to be.

If you change the function to pass in a "minimum required bandwidth"
argument *and* change the checking as suggested with the combination, I
think it'll be OK.

johannes

