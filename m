Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43837 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0DPGKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:10:25 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCHv2 1/2] mac80211: Determine dynamic PS timeout based on ps-qos network latency
References: <1271228079-27321-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271228079-27321-2-git-send-email-juuso.oikarinen@nokia.com>
	<87eiigm0vu.fsf@purkki.valot.fi>
	<1271395747.6205.23.camel@wimaxnb.nmp.nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 16 Apr 2010 09:10:23 +0300
In-Reply-To: <1271395747.6205.23.camel@wimaxnb.nmp.nokia.com> (Juuso Oikarinen's message of "Fri\, 16 Apr 2010 08\:29\:07 +0300")
Message-ID: <87aat4lygg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> Hi,

Moi,

>> > +		timeout = local->hw.conf.dynamic_ps_forced_timeout;
>> > +		if (timeout < 0) {
>> > +			if (latency <= 50000)
>> > +				timeout = 300;
>> > +			else if (latency <= 2000000000)
>> > +				timeout = 100;
>> > +			else
>> > +				timeout = 0;
>> > +		}
>> > +		local->hw.conf.dynamic_ps_timeout = timeout;
>> 
>> What will be the timeout value when there are no pm_qos requirements
>> from user space applications? Do you know what will be the default
>> latency value in that case?
>
> Yes, the default value is 2000000000 (2000 seconds, ugh.) Hence the
> value in the if statement for 100ms.

Ah, now I understand better.

And ugh indeed, having a default of 2000 seconds for latency is very
awkward. I would have preferred to have a magic value denoting (like
-1 or something) that user space doesn't care. But I guess we have to
live with this :/

Maybe at some point we can talk with QoS framework about this.

>> I'm mostly worried about timeout 0 case, for example I suspect ath9k
>> is broken with that value.
>> 
>> Also does this patch change the default value of dynamic ps timeout?
>> 
>
> No, the current default does not change. As the default value for the
> latency is 2000s, we will, by default, get a timeout of 100ms.

Excellent. Thank you for explaining these.

>From my point of view these patches look good and I have nothing to
complain. 

(I hope Juuso didn't hit his head when falling off from his chair when
reading this.)

-- 
Kalle Valo
