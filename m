Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:41612 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2FTM6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:58:23 -0400
Message-ID: <4FE1C8EC.4040902@neratec.com> (sfid-20120620_145826_637909_ABBB3980)
Date: Wed, 20 Jun 2012 14:58:20 +0200
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
References: <1340111463-4554-1-git-send-email-victorg@ti.com>   <1340111463-4554-3-git-send-email-victorg@ti.com>   <1340181856.4655.37.camel@jlt3.sipsolutions.net>   (sfid-20120620_104434_561430_DB0A480E) <1340181992.4655.39.camel@jlt3.sipsolutions.net>  <4FE1B9CB.2090206@neratec.com> <1340193471.4655.57.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340193471.4655.57.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2012 01:57 PM, Johannes Berg wrote:
> On Wed, 2012-06-20 at 13:53 +0200, Zefir Kurtisi wrote:
>> On 06/20/2012 10:46 AM, Johannes Berg wrote:
>>> On Wed, 2012-06-20 at 10:44 +0200, Johannes Berg wrote:
>>>>> +	if ((!chan->radar_detect_timeout ||
>>>>> +	     time_is_after_jiffies(chan->radar_detect_timeout)) &&
>>>>> +	    (chan->flags & IEEE80211_CHAN_RADAR))
>>>>> +		return -EPERM;
>>>>
>>>> Ok so you reject it if it's 0, but the jiffies calculation could return
>>>> 0 too.. in fact, since jiffies start at -5 minutes on boot, you might
>>>> even hit it if you start radar detection 4 minutes after boot.
>>>
>>> Also, it seems that the value should be reset eventually ... at least on
>>> interface down or so. Otherwise you can start CAC, then bring the
>>> interface down to stop the device, and then bring it back up (CAC check
>>> is no longer running) and then you can use the channel after some time
>>> even though you never really checked for radar...
>>>
>> No, if you bring it back up on the same DFS channel,
>> radar_detection_timeout will be set back to +60s by
>> start_radar_detection(). Looks safe to me.
> 
> You need to think a bit more outside the regular code flows ... What if
> I'm not calling start_radar_detection()?
> 
> johannes
> 
If you are not calling start_radar_detection() you are not using
hostapd. With the design approach we agreed on (when we initially
discussed DFS years ago) to have all the logic located in hostapd, it is
inevitable that those who intentionally want to bypass DFS regulatory
restrictions actually can. You can always replace hostapd by some
component that handles DFS control without caring the wait times.

I don't see a reliable and fail-safe method to prevent users doing that.
Other than maybe moving the logic part up to mac80211 or create some
additional barrier like is done with crda (which is exactly that:
additional barriers, but no prevention).


tl;dr: if the DFS regulatory compliance is provided by hostapd, it is
mandatory for master mode - which ensures that start_radar_detection()
is called whenever operating a DFS channel.
