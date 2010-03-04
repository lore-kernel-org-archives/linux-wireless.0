Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:65296 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab0CDUJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 15:09:35 -0500
Date: Fri, 5 Mar 2010 09:11:44 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
cc: Bob Copeland <me@bobcopeland.com>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
In-Reply-To: <133e8d7e1003040840p6d1eddc2nfab2876c4e5af474@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003050857360.1284@kauri.ferryrd.indranet.co.nz>
References: <4B8C3A21.2050105@openwrt.org>  <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>  <4B8D25DC.8070502@openwrt.org>  <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>  <alpine.DEB.2.00.1003031006390.10063@kauri>
 <20100304141256.GA1985@hash.localnet> <133e8d7e1003040840p6d1eddc2nfab2876c4e5af474@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463784191-1660290381-1267733504=:1284"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463784191-1660290381-1267733504=:1284
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi,
On Thu, 4 Mar 2010, Björn Smedman wrote:
> On Thu, Mar 4, 2010 at 3:12 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>
>> Minstrel definitely performs better in real life.
> Agree, minstrel works very well in real life.
yeah - we tested it hard and long outdoors. and indoors.  and with driver 
faults, and it still worked as well as could be expected.
>
>> That said, I looked at the current minstrel code and have a few
>> puzzlements:
>>
>> - As I understand it, minstrel is not supposed to delay packets more
>>  than 24 ms to avoid TCP resends.  However, if I understand the code,
>>  this is done by limiting each MRR segment to 6 ms, which doesn't seem
>>  right to me.  The retries in the second MRR slot will have to wait
>>  a backoff before being used, right?
>
> I took a look at the minstrel code back in madwifi and the comments
> there suggest this 24 ms thing is not very theoretically based. It
> sounds like a very reasonable explanation though so I'm not saying it
> is wrong. But I think there might be another very good reason to limit
> the number of attempts at a given rate: after a certain number of
> retries we have to conclude that our hypothesis about the packet
> error/success rate is probably incorrect, and there is no point in
> more retries at that rate.
Agreed. 24 ms was a value that was guessed at, and works well. However, If 
there is no limit on the time taken for the entire chain, then performance 
drops.
  we observed the packets on the air for a tcp transfer (scp). There was 
sometimes a 100ms gap after the successful transmission of one packet 
before the next one was sent. Turns out that TCP's backoff/congestion 
control mechanism was "upset" because of the long transmit time, and had 
delayed the sending of the next. By limiting the time taken for an entire 
retry chain to be used, we increased TCP throughput.

>
>> - Often, two slots in the MRR array use the same rate (e.g. slots 1 and 3).
>>  Maybe we should pick a 'next lower' rate for the lower slot in such a case?
>>  If we are really in a place where the originally attempted rate isn't
>>  workable, this might slightly boost throughput.
>
> Agree. With the same reasoning as above this can be generalized to: if
> an MRR slot has failed and we have fallen through to the next one then
> that slot should be set up to be optimal under a new hypothesis
> (taking the failed MRR segment into account).
yes, This is an enhancement we have discussed.
It would more quickly fill the statistics tables that Minstrel uses, which 
is a good thing.
Currently, the retry chain is something like
1.rate with the the highest throughput
2.rate with the the second highest throughput
3.rate with the highest probability
4.base rate of 1mbit.

You could change it to:
1.rate with the the highest throughput
2.rate with the the second highest throughput
3.rate with the highest probability,
    such that this rate does not equal 1. or 2.
4.base rate of 1mbit.

Do not use the 'next lower' rate. This is effectively a variant on the 
step up/step down philosophy, which does not apply to rate algorithms.

The philosophy that the success probability of a rate is proportional to 
the bit rate is wrong. 100.00% wrong. Since things like PID have this 
philosophy at their core, PID will always fail.



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
---1463784191-1660290381-1267733504=:1284--
