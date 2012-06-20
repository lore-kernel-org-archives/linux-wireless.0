Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:42550 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2FTNi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 09:38:56 -0400
Message-ID: <4FE1D26D.8060702@neratec.com> (sfid-20120620_153859_838869_6F9743C4)
Date: Wed, 20 Jun 2012 15:38:53 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on
 op-channel
References: <1340111463-4554-1-git-send-email-victorg@ti.com>    <1340111463-4554-3-git-send-email-victorg@ti.com>    <1340181856.4655.37.camel@jlt3.sipsolutions.net>    (sfid-20120620_104434_561430_DB0A480E) <1340181992.4655.39.camel@jlt3.sipsolutions.net>   <4FE1B9CB.2090206@neratec.com>  <1340193471.4655.57.camel@jlt3.sipsolutions.net>  <4FE1C8EC.4040902@neratec.com> <1340197920.4655.62.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340197920.4655.62.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2012 03:12 PM, Johannes Berg wrote:
> On Wed, 2012-06-20 at 14:58 +0200, Zefir Kurtisi wrote:
> 
>>>> No, if you bring it back up on the same DFS channel,
>>>> radar_detection_timeout will be set back to +60s by
>>>> start_radar_detection(). Looks safe to me.
>>>
>>> You need to think a bit more outside the regular code flows ... What if
>>> I'm not calling start_radar_detection()?
> 
>> If you are not calling start_radar_detection() you are not using
>> hostapd. With the design approach we agreed on (when we initially
>> discussed DFS years ago) to have all the logic located in hostapd, it is
>> inevitable that those who intentionally want to bypass DFS regulatory
>> restrictions actually can. You can always replace hostapd by some
>> component that handles DFS control without caring the wait times.
> 
> But this kernel patch is attempting to enforce the wait time. Are you
> saying it shouldn't even pretend to enforce it?
> 
> johannes
> 
No, it serves its purpose to ensure hostapd is not going mad and tries
to enable TX before the CAC is over via redundant checks.

What I'm saying is this: we defined that DFS regulatory compliance is
provided by and distributed over driver, mac80211, and hostapd. We
always must ensure that a working combination of those operates in
compliance. But we have no control over it when a component is exchanged
or modified.

The regulatory statement we all signed does not even ask for that, it
states that 'average users should not accidentally fail to comply...'
which can be denied to be accidental for someone running master mode
without hostapd.


Back to topic: as stated above, radar_detection_timeout should be per
wiphy. That would also resolve your concern, right?

