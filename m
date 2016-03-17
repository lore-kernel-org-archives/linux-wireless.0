Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38451 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbcCQJDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:03:47 -0400
Received: by mail-wm0-f52.google.com with SMTP id l68so106895554wml.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 02:03:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw5cUaj_qM+CYHHoRaghLDLC+BUgF4AjT=Oec+SB-zb74g@mail.gmail.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQ=65mHN5iLnZjTE+tyEG7nfmCx4NZNbGRF6+VpRaNmOYw@mail.gmail.com>
	<CAA93jw5cUaj_qM+CYHHoRaghLDLC+BUgF4AjT=Oec+SB-zb74g@mail.gmail.com>
Date: Thu, 17 Mar 2016 10:03:45 +0100
Message-ID: <CA+BoTQn539Wmn0hfS+0mxjdrqXTr+tT1HQ0u_OU8_xq5xBdFhg@mail.gmail.com> (sfid-20160317_100356_105806_C651E49B)
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Tim Shepard <shep@alum.mit.edu>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 March 2016 at 16:37, Dave Taht <dave.taht@gmail.com> wrote:
> it is helpful to name the test files coherently in the flent tests, in
> addition to using a directory structure and timestamp. It makes doing
> comparison plots in data->add-other-open-data-files simpler. "-t
> patched-mac-300mbps", for example.

Sorry. I'm still trying to figure out what variables are worth
considering for comparison purposes.


> Also netperf from svn (maybe 2.7, don't remember) will restart udp_rr
> after a packet loss in 250ms. Seeing a loss on UDP_RR and it stop for
> a while is "ok".

I'm using 2.6 straight out of debian repos so yeah. I guess I'll try
using more recent netperf if I can't figure out the hiccups.


Michał


> Dave Täht
> Let's go make home routers and wifi faster! With better software!
> https://www.gofundme.com/savewifi
>
>
> On Wed, Mar 16, 2016 at 3:26 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 16 March 2016 at 11:17, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> Hi,
>>>
>>> Most notable changes:
>> [...]
>>>  * ath10k proof-of-concept that uses the new tx
>>>    scheduling (will post results in separate
>>>    email)
>>
>> I'm attaching a bunch of tests I've done using flent. They are all
>> "burst" tests with burst-ports=1 and burst-length=2. The testing
>> topology is:
>>
>>                    AP ----> STA
>>                    AP )) (( STA
>>  [veth]--[br]--[wlan] )) (( [wlan]
>>
>> You can notice that in some tests plot data gets cut-off. There are 2
>> problems I've identified:
>>  - excess drops (not a problem with the patchset and can be seen when
>> there's no codel-in-mac or scheduling isn't used)
>>  - UDP_RR hangs (apparently QCA99X0 I have hangs for a few hundred ms
>> sometimes at times and doesn't Rx frames causing UDP_RR to stop
>> mid-way; confirmed with logs and sniffer; I haven't figured out *why*
>> exactly, could be some hw/fw quirk)
>>
>> Let me know if you have questions or comments regarding my testing/results.
>>
>>
>> Michał
