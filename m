Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34090 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbcCaGjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 02:39:45 -0400
Received: by mail-wm0-f44.google.com with SMTP id p65so210880905wmp.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 23:39:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FBF0A4.5090508@candelatech.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
	<CAA93jw7BEsEOP8O2BQFXUibkGzkzBZuyWxBxs5XDCZmOt6D+Qg@mail.gmail.com>
	<CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
	<56FAA518.2000805@candelatech.com>
	<CA+BoTQnBadqR4F2OSwLhiqXebzRRdLOWabHmeVQVGnSSm9vVfQ@mail.gmail.com>
	<56FBF0A4.5090508@candelatech.com>
Date: Thu, 31 Mar 2016 08:39:38 +0200
Message-ID: <CA+BoTQ=dcqR60U0EgdtjBx=-TRfZOdNgu_ZYP26Y0zD6rtRjQg@mail.gmail.com> (sfid-20160331_083950_438363_DF06B334)
Subject: Re: [RFC] ath10k: implement dql for htt tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Dave Taht <dave.taht@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2016 at 17:28, Ben Greear <greearb@candelatech.com> wrote:
> On 03/30/2016 02:22 AM, Michal Kazior wrote:
>>
>> On 29 March 2016 at 17:54, Ben Greear <greearb@candelatech.com> wrote:
>>>
>>> On 03/29/2016 12:49 AM, Michal Kazior wrote:
>>>
>>>>> if you are getting a pure codel result of 160ms, that means the
>>>>> implementation is broken. But I think (after having read your
>>>>> description twice), the baseline result today of 160ms of queuing was
>>>>> with a fq_codel *qdisc* doing the work on top of huge buffers,
>>>>
>>>>
>>>>
>>>> Yes. The 160ms is with fq_codel qdisc with ath10k doing DQL at 6mbps.
>>>> Without DQL ath10k would clog up all tx slots (1424 of them) with
>>>> frames. At 6mbps you typically want/need a handful (5-10) of frames to
>>>> be queued.
>>>
>>>
>>>
>>> Have you actually verified you can use all tx slots?
>>
>>
>> It works in most cases. I guess you're suspecting some of your
>> tx(flushing?) problems might be induced by overcommiting?
>>
>>> The way the
>>> firmware uses it's tx buffers I think you may not be able to actually
>>> do that...and in practice, you will get a lot fewer usable tx-buffers
>>> than configured....
>>
>>
>> Could be, e.g. I'm aware management frames are kind of a special case
>> in recent firmware revisions.
>>
>> What would/do you expect firmware would/will do when we overcommit?
>> The driver does advertise number of HTT tx slots so I would expect it
>> to work fine if it didn't crash during boot.
>
>
> The firmware will return something like tx-dropped immediately.  The reason
> is that the firmware keeps more than one internal priority queue, and in
> general, reserves
> some of the tx-descriptors for high priority.
>
> So, you never see tx-queues completely full in the driver, so tx queues are
> not stopped farther up the stack.
>
> Possibly I am confused about some of this, so I'm quite curious if you ever
> see
> tx-queues determined to be full in the ath10k driver.

I haven't analyzed it this much. Nevertheless it's good to know we
might be overcommiting on the HTT Tx. One more reason to use DQL
and/or schedule tx in a smarter way.


Michał
