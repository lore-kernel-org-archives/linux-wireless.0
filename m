Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48590 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3CZR2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:28:00 -0400
Message-ID: <5151DA98.7030903@candelatech.com> (sfid-20130326_182806_936522_45746D92)
Date: Tue, 26 Mar 2013 10:27:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Robert Shade <robert.shade@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: [ath9k-devel] Auth Packet TX Delay
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com> <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com> <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com> <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com> <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com> <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com> <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com> <5151D752.3080303@candelatech.com> <CAJ-VmontjZ2+RWCK50gf5RADkMeCbCc=HfstVAffkCHCtTmNew@mail.gmail.com>
In-Reply-To: <CAJ-VmontjZ2+RWCK50gf5RADkMeCbCc=HfstVAffkCHCtTmNew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2013 10:16 AM, Adrian Chadd wrote:
> ... and the odd thing here is that during scanning, it should be
> flushing the queues entirely so any new frame being transmitted
> _SHOULD_ result in:
>
> * TxDP for that queue being written (either FIFO or otherwise);
> * TxE for that queue being set.
>
> So unless the queue is "full" already and isn't being drained, I'm
> kinda curious as to why TX isn't starting.

At least for the problems I saw, it was fairly easy to spot the
problem once you looked at the xmit debugfs file.  There would
be 127 pending-frames, axq-depth and ampdu-depth were zero,
queue is stopped, and it stays like that for many seconds or minutes.

Just resetting the NIC didn't help...I had to also tell the reset to
not retry any packets and to set the pending-frames to zero.  After
that, packets started transmitting again, and often after several
seconds I'd see at least most of the old stuck packets be processed
to one degree or another (pending frames would go negative since I
had forced it to zero earlier).

I still do not know the root cause of this, nor have I had time to look
at it in any more detail..the work-around is good enough for me for now
and I have higher priority issues currently...

I only saw the problem in the data queue (BE), but maybe it can happen
in other queues as well.

Or of course it could be completely un-related to the problem in
this email thread....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

