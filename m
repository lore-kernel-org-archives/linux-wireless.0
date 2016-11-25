Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751070AbcKYI2y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 03:28:54 -0500
Message-ID: <1480061086.2517.103.camel@coelho.fi> (sfid-20161125_092857_396079_9DB8C861)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 25 Nov 2016 10:04:46 +0200
In-Reply-To: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, 2016-11-22 at 13:31 +0000, Arend van Spriel wrote:
> The interval for scheduled scan may have a minimum value for
> the device. Allow drivers to specify a minimum value in the
> struct wiphy so user-space interval values can be validated
> against it.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---

I'm not sure this is necessary, because the interval is a "soft"
requirement, there being no guarantee on the accuracy of the intervals.
 The minimum interval a firmware can support is probably variable,
depending on how long time it takes for a scan to complete.  Let's say
it takes 1 second to scan a certain amount of channels.  In this case,
the minimum interval is probably 1 second (i.e. you can start a new
scan immediately after the first one completed).  Now, if you're
scanning more channels and it takes, say, 4 seconds to complete, the
minimum interval would be 4 seconds.

The iwlwifi firmware treats the interval as the amount of time to wait
*after* one scan cycle completes before starting the cycle.  Since
sched scan is mostly used while the system is suspended, the interval
can be quite large and the accuracy really doesn't matter.  The
absoulte time when the scan cycles occur will drift over time, but does
it matter?

So, for firmwares that really need to get a minimum value, I think
bumping up to the minimum allowed if the provided value is too low,
should be done in the driver.

--
Cheers,
Luca.
