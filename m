Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:40142 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab2FTLxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 07:53:51 -0400
Message-ID: <4FE1B9CB.2090206@neratec.com> (sfid-20120620_135354_364358_6E22D3F3)
Date: Wed, 20 Jun 2012 13:53:47 +0200
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
References: <1340111463-4554-1-git-send-email-victorg@ti.com>  <1340111463-4554-3-git-send-email-victorg@ti.com>  <1340181856.4655.37.camel@jlt3.sipsolutions.net>  (sfid-20120620_104434_561430_DB0A480E) <1340181992.4655.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340181992.4655.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2012 10:46 AM, Johannes Berg wrote:
> On Wed, 2012-06-20 at 10:44 +0200, Johannes Berg wrote:
>>> +	if ((!chan->radar_detect_timeout ||
>>> +	     time_is_after_jiffies(chan->radar_detect_timeout)) &&
>>> +	    (chan->flags & IEEE80211_CHAN_RADAR))
>>> +		return -EPERM;
>>
>> Ok so you reject it if it's 0, but the jiffies calculation could return
>> 0 too.. in fact, since jiffies start at -5 minutes on boot, you might
>> even hit it if you start radar detection 4 minutes after boot.
> 
> Also, it seems that the value should be reset eventually ... at least on
> interface down or so. Otherwise you can start CAC, then bring the
> interface down to stop the device, and then bring it back up (CAC check
> is no longer running) and then you can use the channel after some time
> even though you never really checked for radar...
> 
No, if you bring it back up on the same DFS channel,
radar_detection_timeout will be set back to +60s by
start_radar_detection(). Looks safe to me.

> And if you start CAC on two different devices on the same channel, but
> they happen to share channel structs in the driver then this will all
> conflict quite badly.
> 
Details ;) In fact, if you start device A at a DFS channel and device B
at the same channel 50secs later and device A did not detect radars
after 60secs, ideally both should get TX enabled at the same time with
B's CAC being aborted after 10secs.

For that radar_detect_timeout had to be per wiphy.

With the proposal here you have to wait for the last device to pass the
CAC and if you alternatively put devices A and B up and down every
30secs you can effectively prevent them from TXing forever.
> 
> This needs a lot of more thinking it seems.
> 
> johannes
> 


