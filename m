Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62682 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755820AbXGMRyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 13:54:31 -0400
Message-ID: <4697BC55.1080704@lwfinger.net>
Date: Fri, 13 Jul 2007 12:54:29 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: "Cahill, Ben M" <ben.m.cahill@intel.com>, benmcahill@gmail.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters  for rssi, signal, noise.
References: <20070711022508.36db6129@logostar.upir.cz>	<4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com> <20070713172338.71bc4216@griffin.suse.cz>
In-Reply-To: <20070713172338.71bc4216@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Tue, 10 Jul 2007 21:59:13 -0700, Cahill, Ben M wrote:
>> Postponing the division keeps the running average using more significant
>> bits, so each new sample has a meaningful, surviving impact to the
>> running average.  Sorry, "high-precision" is the best term that I can
>> think of to describe more bits being used in the running average.  The
>> "binary point" is between bits 3 and 4; think of bits 3:0 as
>> "remainder". 
> 
> Thanks, that makes sense. Please include something like this
> explanation in the description of the patch when you resend it.
> 
>> There is a subtle difference between:
>>
>> 1)  last_rssi * 15 / 16
>>
>> 2)  last_rssi - (last_rssi / 16)
>>
>> The first one would get stuck at -801 if there were a series of -51s
>> coming in.
>> -801 * 15 / 16 would get quantized to -750 each time, so the output
>> would be stuck at -801 (-50 dBm).
>>
>> The second one favors the high precision memory, and would progress from
>> -801 to -802, etc., as a series of -51s came in:
>> -801 - (-801/16) = -751
> 
> So it's basically just a different rounding - in the current code, it's
> like float division with the result rounded down, while your change
> makes it to round up (speaking about absolute value). Nothing about
> precision here :-)
> 
>> I saw 2 instances of sta->last_rssi being used in ieee80211_ioctl.c, and
>> STA_FILE(last_rssi, last_rssi, D) in debugfs_sta.c, which I didn't
>> understand (still don't) and was afraid to touch, so I thought the
>> safest thing with least impact would be to add the 3 additional
>> variables, and do the division in one place for each of the 3
>> rssi/signal/noise.
>>
>> If we do the division when passing to user space, how should STA_FILE be
>> handled, if necessary?
> 
> Johannes was quicker than me (thanks) :-)
> 
>> Thanks for your comments.  I'll wait for your answer, and try again.
> 
> Thanks and sorry for the delayed answer,

I added the wireless statistics to d80211 (it was that long ago) and I used 16-point averaging based 
on my experiences with an early version of the bcm43xx-softmac driver where the rssi value was quite 
jittery. From a quick test on the current drivers, the assumptions seem not to be valid and it is 
quite possible that averaging may not be needed, or that one can get by with a 2- or 4-point process.

My suggestion would be to circulate a trial patch with averaging removed and ask for testing to see 
if it makes the results too jumpy. I can prepare that patch if you wish.

Larry
