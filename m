Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45281 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3CZQaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 12:30:07 -0400
Received: by mail-ie0-f175.google.com with SMTP id c12so9186778ieb.34
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 09:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
 <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
 <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
 <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com> <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 26 Mar 2013 12:29:47 -0400
Message-ID: <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com> (sfid-20130326_173014_157809_A21B9814)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 26, 2013 at 12:28 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 26 March 2013 05:21, Robert Shade <robert.shade@gmail.com> wrote:
>> I'll get a bug together, but I wanted to report that even with the
>> patch above (fastcc disabled/cold reset always), it still eventually
>> was unable to change the channel.  As soon as that failed, it's back
>> into the state where it never seems to xmit anything in the data
>> queues and can't associate.
>
> Even after a cold reset?

Yes, which is why I'm curious about the start/stop queues calls. It
looks to my (untrained) eye that it's simply not processing the data
queue.
