Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:63035 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0CAXC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 18:02:27 -0500
Date: Tue, 2 Mar 2010 12:04:20 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Felix Fietkau <nbd@openwrt.org>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
In-Reply-To: <4B8C4685.8020202@openwrt.org>
Message-ID: <alpine.DEB.2.00.1003021203230.14059@kauri.acheron.indranet.co.nz>
References: <4B8C3A21.2050105@openwrt.org> <alpine.DEB.2.00.1003021122550.14059@kauri.acheron.indranet.co.nz> <4B8C4685.8020202@openwrt.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 1 Mar 2010, Felix Fietkau wrote:

> On 2010-03-01 11:38 PM, Derek Smithies wrote:
>> Hi,
>>   Great work on getting this far - it was a huge undertaking.
>>
>>   Ok, before diving into the code, can we take a quick moment to think on
>> this. I wonder if you can answer the following questions:
>>
>> a)Minstrel worked hard at using information that is good and reliable: -
>>     which is the record of what rates worked, and what rates failed.
>>   Minstrel avoids using things like RSSI (which is not reliable)
> Yes, I still rely purely on tx status feedback, no RSSI voodoo.
>
>> b)You have stated in previous emails that with 802.11n there are too many
>>   rates for minstrels random sampling technique.
>>
>> What is the approach taken in 802.11n & minstrel? I remember some comment
>> about dividing the 802.11n rate set up into groups, and then minstrel does
>> its thing within the rates of each group. - Do I have the idea here?
> The previous comments were based on faulty tx status feedback because of
> an ath9k issue that I resolved in a previous patch. The current
> implementation still does random sampling, with one exception: each
> sampling attempt goes to a different MCS group.
> Other than that, I split up the MCS rates into groups mainly because
> it's easier to deal with and allows me to calculate raw transmit
> durations at compile time.
>
> I did add some small special cases though. For instance if the code
> detects that the current transmit rate is failing really quickly on a
> multi-stream rate, it falls back to the max_tp_rate of a single-stream
> group, while leaving around enough feedback for EWMA.
> This reduces the strength of the throughput drop when I disconnect one
> antenna (which kills off pretty much all of the dual-stream rates
> immediately).
>
>> Where have you tested 802.11n & minstrel?
> Only at home. I just finished ironing out most of the important bugs
> today, so this hasn't seen any significant long-term testing yet.
>
>> Does 802.11n&minstrel pass the basic test
>>    a) put two nodes on the desk - rate is high
>>    b) move one of the nodes (or remove antenna) - rate should drop
>>    c) move nodes back to the configuration of a)
>>              -rate should go high again
> Yes, this was my primary test. I also did some tests with removing both
> antennas and moving the laptop away and back again.
>
> I also did quite a few tests switching back and forth between
> minstrel_ht and the ath9k rate control to compare them as accurately as
> possible. In HT40, rate adaptation with minstrel is usually a little
> slower (only a minor difference here, probably caused by the much larger
> search space), but it's able to deal with sources of interference (e.g.
> Bluetooth) a lot better.
> It also reacts much faster to problems with spatial multiplexing, and
> seems to get a better average throughput in HT20 in my tests.
>
>> Does 802.11n&minstrel work well with time?
>> In other words, is the throughput 10 hours later the same as at the start
>> of the test?
> If I force it to single-stream mode, then it seems to be just as
> reliable at sticking to a specific rate as the legacy implementation.
>
> With dual-stream rates it's hard to tell, because the reliability of
> rates varies quickly, even if the positions is fixed. I do not see any
> *significant* variations in throughput though.

  Fantastic. This is encouraging, time to test further then.

Derek.

-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"The only thing IE should be used for is to download Fire Fox"

"My favorite language is call STAR. It's extremely concise. It has
  exactly one verb '*', which does exactly what I want at the moment."
     --Larry Wall
