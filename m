Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41140 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3CZROv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:14:51 -0400
Received: by mail-wi0-f174.google.com with SMTP id hj8so1253357wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 10:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
	<CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
	<CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
	<CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
	<CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
Date: Tue, 26 Mar 2013 10:14:49 -0700
Message-ID: <CAJ-VmomiVrvy-HLJeTdTr6rjgTODiQHJv2V_GapSUPuGrFQCLw@mail.gmail.com> (sfid-20130326_181454_388137_12723A97)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2013 09:29, Robert Shade <robert.shade@gmail.com> wrote:

>> Even after a cold reset?
>
> Yes, which is why I'm curious about the start/stop queues calls. It
> looks to my (untrained) eye that it's simply not processing the data
> queue.

Well if there's anything in the data queue once you've reset the chip
(ie, the whole "no loss" reset path for doing resets when you're doing
a scan or recovering from a hung chip) you need to re-program the
queue.

For the pre-AR9380 chips its easy - for each TXQ:

* update axq_link to the be the link field in the last descriptor in
the last frame;
* push the first descriptor in the first frame into the QCU TxDP address;
* set TxE for that queue.

For the AR9380 and later chips its a little more complicated because
of how the FIFO management works. Felix knows more about this in
ath9k; I'm doing something different in FreeBSD.
But the basics are the same - you need to walk the FIFO frame list and
push the head of each FIFO entry back into the FIFO, then start TX.


adrian
