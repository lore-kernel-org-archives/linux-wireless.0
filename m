Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbcCGRXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 12:23:02 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Avery Pennarun <apenwarr@gmail.com>,
	Dave Taht <dave.taht@gmail.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Tim Shepard <shep@alum.mit.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Andrew Mcgregor <andrewmcgr@google.com>,
	=?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
Date: Mon, 7 Mar 2016 17:22:57 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA5E027@hasmsx107.ger.corp.intel.com> (sfid-20160307_182307_278300_55B29741)
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
 <E1abfnE-0000VS-00@www.xplot.org>
 <CA+BoTQk6J7kgdie9aX24MB+8PxN3oFUh0eVdmVrdyptW5RxQXg@mail.gmail.com>
 <CAPp0ZBYP9UzUTtPz=vivUQkE2FiGSsJjDaecQtPuK8y_d3ccqA@mail.gmail.com>
 <56DD99AA.8050403@openwrt.org>
 <CAHqTa-2-uZ0PUdwp33E588EU2a7T6KnTYs8RWfNDEzgOLseG9g@mail.gmail.com>
 <CAA93jw4JG_uEZaxk1JDKndq9K0+QPwKaAmK6=gZ8e-7qNmc=Cw@mail.gmail.com>
 <CAHqTa-1m3209qqLO19diB5ONd1o3whEnBGJkbPpV1m3UfSGJvA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/07/2016 07:15 PM, Avery Pennarun wrote:
> On Mon, Mar 7, 2016 at 11:54 AM, Dave Taht <dave.taht@gmail.com> wrote:
>> If I can just get a coherent patch set that I can build, I will gladly
>> join you on the testing ath9k in particular... can probably do ath10k,
>> too - and do a bit of code review... this week. it's very exciting
>> watching all this activity...
>>
>> but I confess that I've totally lost track of what set of trees and
>> patchwork I should try to pull from. wireless-drivers-next? ath10k?
>> wireless-next? net-next? toke and I have a ton of x86 platforms
>> available to test on....
>>
>> Avery - which patches did you use??? on top of what?
>
> The patch series I'm currently using can be found here:
>
>    git fetch https://gfiber.googlesource.com/vendor/opensource/backports
> ath9k_txq+fq_codel
>
> That's again backports-20160122, which comes from linux-next as of
> 20160122.  You can either build backports against whatever kernel
> you're using (probably easiest) or try to use that version of
> linux-next, or rebase the patches onto your favourite kernel.
>
>> In terms of "smoothing" codel...
>>
>> I emphatically do not think codel in it's current form is "ready" for
>> wireless, at the very least the target should not be much lower than
>> 20ms in your 2 station tests.  There is another bit in codel where the
>> algo "turns off" with only a single MTU's worth of packets
>> outstanding, which could get bumped to the ideal size of the
>> aggregate. "ideal" kind of being a variable based on a ton of other
>> factors...
>
> Yeah, I figured that sort of thing would come up.  I'm feeling forward
> progress just by finally seeing the buggy oscillations finally happen,
> though. :)
>
>> the underlying code needs to be striving successfully for per-station
>> airtime fairness for this to work at all, and the driver/card
>> interface nearly as tight as BQL is for the fq portion to behave
>> sanely. I'd configure codel at a higher target and try to observe what
>> is going on at the fq level til that got saner.
>
> That seems like two good goals.  So Emmanuel's BQL-like thing seems
> like we'll need it soon.

Well... I am going to do that for station only, and only for iwlwifi.
I haven't had a chance to work on that since then :( but I hope to get 
back to it. I also need to check what happens in multiple channels 
scenarios (in which there is inherent latency).
AP and stations have different challenges.

>
> As for per-station airtime fairness, what's a good approximation of
> that?  Perhaps round-robin between stations, one aggregate per turn,
> where each aggregate has a maximum allowed latency?  I don't know how
> the current code works, but it's probably almost like that, as long as
> we only put one aggregate's worth of stuff into each hwq, which I
> guess is what the BQL-like thing will do.
>
> So if I understand correctly, what we need is, in the following order:
> 1) Disable fq_codel for now, and get BQL-like thing working in ath9k
> (and ensure we're getting airtime fairness even without fq_codel);
> 2) Re-enable fq_codel and increase fq_codel's target up to 20ms for now;
> 3) Tweak fq_codel's "turn off" size to be larger (how important is this?)
>
> Is that right?
>
