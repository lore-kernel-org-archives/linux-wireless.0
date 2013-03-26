Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:59621 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3CZMWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 08:22:17 -0400
Received: by mail-ia0-f170.google.com with SMTP id h8so6412373iaa.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 05:22:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
 <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
 <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 26 Mar 2013 08:21:56 -0400
Message-ID: <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com> (sfid-20130326_132219_818328_910810F6)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll get a bug together, but I wanted to report that even with the
patch above (fastcc disabled/cold reset always), it still eventually
was unable to change the channel.  As soon as that failed, it's back
into the state where it never seems to xmit anything in the data
queues and can't associate.

On Mon, Mar 25, 2013 at 12:45 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> One for each please.
>
>
>
>
> Adrian
>
>
> On 25 March 2013 09:12, Christian Lamparter <chunkeey@googlemail.com> wrote:
>> On Monday, March 25, 2013 03:23:53 AM Adrian Chadd wrote:
>>> Also, would you please make sure you file a bugzilla.kernel.org ticket
>>> so this gets tracked?
>>>
>>> It's good to know that some combination of fast channel change and
>>> warm versus cold reset is making things better/worse.
>>>
>>> And although a cold reset is likely a good thing to _fix_ the problem,
>>> it still leaves the underlying DMA/PHY hangs unresolved.
>>>
>>> But yes, please file a bugzilla ticket so this gets tracked right!
>> Um, do you want a bugreport for ath9k or carl9170 or for both?
>>
>> Regards,
>>         Christian
