Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51488 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3CZRqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:46:04 -0400
Message-ID: <5151DED3.8090009@candelatech.com> (sfid-20130326_184623_719024_B1119A10)
Date: Tue, 26 Mar 2013 10:45:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Robert Shade <robert.shade@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: [ath9k-devel] Auth Packet TX Delay
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com> <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com> <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com> <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com> <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com> <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com> <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com> <5151D752.3080303@candelatech.com> <CAJ-VmontjZ2+RWCK50gf5RADkMeCbCc=HfstVAffkCHCtTmNew@mail.gmail.com> <5151DA98.7030903@candelatech.com> <CAJ-Vmom67dWGVASc-dm03NfG2bWFQ+v6b1UMW7nh1t4Q+j0RJw@mail.gmail.com>
In-Reply-To: <CAJ-Vmom67dWGVASc-dm03NfG2bWFQ+v6b1UMW7nh1t4Q+j0RJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2013 10:33 AM, Adrian Chadd wrote:
> Right. Well, when you reset the FIFO chances are you should walk said
> FIFO queue in the TXQ (not the pending frames, the "hw" frames) and
> requeue each to the hardware.
>
> What I am doing in my EDMA restart routine in FreeBSD:
>
> * (assume TX is stopped, chip is reset, the completed frames are
> already removed from the FIFO queue in the TXQ);
>
> * save the old FIFO count
> * blank the FIFO count
> * walk the FIFO list (NOT the pending list), pushing head pointers
> back into the FIFO - and this will bump the FIFO counter by one each
> time;
> * when I've finished that, compare the FIFO count to the old FIFO
> count - they should match.
>
> I've not looked at the ath9k code in too much depth lately as I've
> been more interested in getting FreeBSD's EDMA code finished (and I
> think it is, woo!); so if you give me an hour or two I'll go do
> another code review and see what pops up.

Ok, I'm happy to test patches.  Last we tried, we could reproduce
the problem very often using lots of stations (32, I think) sending
64kbps or so UDP traffic through an attenuator as we ramp up the
attenuation in 10db steps...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

