Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49076 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970497AbdAELiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:38:25 -0500
Message-ID: <1483616301.4394.6.camel@sipsolutions.net> (sfid-20170105_123829_384904_A229747D)
Subject: Re: SIOCSIWFREQ while in NL80211_IFTYPE_STATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>,
        netdev@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Jan 2017 12:38:21 +0100
In-Reply-To: <685811c3-6247-77fd-8c70-617951886451@linaro.org> (sfid-20170105_120230_642426_9BEC69AB)
References: <685811c3-6247-77fd-8c70-617951886451@linaro.org>
         (sfid-20170105_120230_642426_9BEC69AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+linux-wireless, where this should've gone

> I am running a single wlan0 interface in managed mode (no aliases,
> no  other wireless interfaces).
> The association with the AP still hasn't happened.
> 
> I noticed that if trying to change the frequency to one of the valid 
> values, the driver returns EBUSY.
> 
> The call stack is
> cfg80211_wext_siwfreq
> -->cfg80211_mgd_wext_siwfreq
> --->cfg80211_set_monitor_channel (notice call to set 'monitor'
> channel 
> in managed mode)
> ----> fails with EBUSY
> 
> Is therefore the expected behavior to fail under the above
> circumstances 
> (managed mode && single wlan0 interface && no association)?
> And if it is, please could you clarify when would it be valid to
> change the frequency in managed mode?

Frankly, I don't remember - all of this is plastered all over with
backward compatibility hooks etc.

How are you running into this? Why are you even trying to do this? You
really shouldn't use wireless extensions any more.

Also, there shouldn't be much reason to be setting the channel anyway,
unless you want to trigger a connection specifically on that channel,
but then when you use nl80211 you get that included in the CONNECT
command there.

Finally, I suspect that this particular backward compatibility hook
can't really work anyway and could be removed, but I'm not sure that
would have the effect you want either.

johannes
