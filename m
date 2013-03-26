Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:56344 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CZRdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:33:49 -0400
Received: by mail-we0-f182.google.com with SMTP id k14so3747103wer.27
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 10:33:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5151DA98.7030903@candelatech.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
	<CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
	<CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
	<CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
	<CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
	<5151D752.3080303@candelatech.com>
	<CAJ-VmontjZ2+RWCK50gf5RADkMeCbCc=HfstVAffkCHCtTmNew@mail.gmail.com>
	<5151DA98.7030903@candelatech.com>
Date: Tue, 26 Mar 2013 10:33:47 -0700
Message-ID: <CAJ-Vmom67dWGVASc-dm03NfG2bWFQ+v6b1UMW7nh1t4Q+j0RJw@mail.gmail.com> (sfid-20130326_183353_794835_DA2621CD)
Subject: Re: [ath9k-devel] Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Robert Shade <robert.shade@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right. Well, when you reset the FIFO chances are you should walk said
FIFO queue in the TXQ (not the pending frames, the "hw" frames) and
requeue each to the hardware.

What I am doing in my EDMA restart routine in FreeBSD:

* (assume TX is stopped, chip is reset, the completed frames are
already removed from the FIFO queue in the TXQ);

* save the old FIFO count
* blank the FIFO count
* walk the FIFO list (NOT the pending list), pushing head pointers
back into the FIFO - and this will bump the FIFO counter by one each
time;
* when I've finished that, compare the FIFO count to the old FIFO
count - they should match.

I've not looked at the ath9k code in too much depth lately as I've
been more interested in getting FreeBSD's EDMA code finished (and I
think it is, woo!); so if you give me an hour or two I'll go do
another code review and see what pops up.


Adrian
