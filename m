Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37636 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbcC3KE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 06:04:29 -0400
Received: by mail-wm0-f53.google.com with SMTP id p65so63892732wmp.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 03:04:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4ooS_oc___qTzwqmZ4BPbOSem0Z8V_qc0zq2hh5Qv2Rg@mail.gmail.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
	<CAA93jw7BEsEOP8O2BQFXUibkGzkzBZuyWxBxs5XDCZmOt6D+Qg@mail.gmail.com>
	<CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
	<CAA93jw4ooS_oc___qTzwqmZ4BPbOSem0Z8V_qc0zq2hh5Qv2Rg@mail.gmail.com>
Date: Wed, 30 Mar 2016 12:04:27 +0200
Message-ID: <CA+BoTQ=b+5xTraZ-D31k_9dQAYRBiWWF9_G3=VVb0SbS=Q3eFA@mail.gmail.com> (sfid-20160330_120433_577919_CA543C7D)
Subject: Re: [RFC] ath10k: implement dql for htt tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2016 at 02:57, Dave Taht <dave.taht@gmail.com> wrote:
> As a side note of wifi ideas complementary to codel, please see:
>
> http://blog.cerowrt.org/post/selective_unprotect/
>
> On Tue, Mar 29, 2016 at 12:49 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
[...]
>> On the other hand DQL will react also to host system interrupt service
>> time. On slow CPUs (typically found on routers and such) you might end
>> up grinding the CPU so much you need deeper tx queues to keep the hw
>> busy (and therefore keep performance maxed). DQL should automatically
>> adjust to that while "txop limit" might not.
>
> Mmmm.... current multi-core generation arm routers should be fast enough.

While this helps it doesn't mean you can magically un-serialize
interrupt/txrx completion work.


[...]
>>>> To sum things up:
>>>>  - DQL might be able to replace the explicit txop queue limiting
>>>> (which requires rate control info)
>>>
>>> I am pessimistic. Perhaps as a fallback?
>>
>> At first I was (too) considering DQL as a nice fallback but the more I
>> think about the more it makes sense to use it as the main source of
>> deriving time slices for tx scheduling.
>
> I don't really get how dql can be applied per station in it's current forrm.

I was thinking of the following scheme:
 - disable excessive retries in fw (apparently doable via WMI pdev parameter)
 - deficit-based round-robin over stations
 - maintain DQL structure per station
 - when station gets its turn to xmit push frames to fw
 - keep doing that (with regard to per station DQL limits) until either:
   - associated software queue becomes empty
   - 1 timeslice for given station has elapsed
     - i was thinking of extracting timeslices from DQL or maintaining
it separately
 - try next station
 - do not submit packets to multiple stations at once (MU will need
more work..), i.e. always drain tx completely before switching to next
station
 - each station may need a different timeslice (to squeeze out max
burst performance)


[...]
>>>> PS. I'm not feeling comfortable attaching 1MB attachment to a mailing
>>>> list. Is this okay or should I use something else next time?
>>>
>>> I/you can slam results into the github blogcerowrt repo and then pull
>>> out stuff selectively....
>>
>> Good idea, thanks!
>
> You got commit privs.

Yep, thanks!


Michał
