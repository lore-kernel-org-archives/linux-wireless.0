Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41347 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0DPFcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 01:32:45 -0400
Subject: Re: [RFC PATCHv2 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87eiigm0vu.fsf@purkki.valot.fi>
References: <1271228079-27321-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271228079-27321-2-git-send-email-juuso.oikarinen@nokia.com>
	 <87eiigm0vu.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 08:29:07 +0300
Message-ID: <1271395747.6205.23.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2010-04-16 at 07:17 +0200, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> > Determine the dynamic PS timeout based on the configured ps-qos network
> > latency. For backwards wext compatibility, allow the dynamic PS timeout
> > configured by the cfg80211 to overrule the automatically determined value.
> 
> Thanks. I took a quick look, but I haven't tested this yet myself.
> 
> > +		timeout = local->hw.conf.dynamic_ps_forced_timeout;
> > +		if (timeout < 0) {
> > +			if (latency <= 50000)
> > +				timeout = 300;
> > +			else if (latency <= 2000000000)
> > +				timeout = 100;
> > +			else
> > +				timeout = 0;
> > +		}
> > +		local->hw.conf.dynamic_ps_timeout = timeout;
> 
> What will be the timeout value when there are no pm_qos requirements
> from user space applications? Do you know what will be the default
> latency value in that case?

Yes, the default value is 2000000000 (2000 seconds, ugh.) Hence the
value in the if statement for 100ms.

> I'm mostly worried about timeout 0 case, for example I suspect ath9k
> is broken with that value.
> 
> Also does this patch change the default value of dynamic ps timeout?
> 

No, the current default does not change. As the default value for the
latency is 2000s, we will, by default, get a timeout of 100ms.

-Juuso

