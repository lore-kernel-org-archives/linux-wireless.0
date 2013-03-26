Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40221 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3CZRQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:16:07 -0400
Received: by mail-wi0-f179.google.com with SMTP id hn17so1213724wib.6
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 10:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5151D752.3080303@candelatech.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
	<CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
	<CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
	<CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
	<CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
	<5151D752.3080303@candelatech.com>
Date: Tue, 26 Mar 2013 10:16:05 -0700
Message-ID: <CAJ-VmontjZ2+RWCK50gf5RADkMeCbCc=HfstVAffkCHCtTmNew@mail.gmail.com> (sfid-20130326_181612_617953_63D3A3BB)
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

... and the odd thing here is that during scanning, it should be
flushing the queues entirely so any new frame being transmitted
_SHOULD_ result in:

* TxDP for that queue being written (either FIFO or otherwise);
* TxE for that queue being set.

So unless the queue is "full" already and isn't being drained, I'm
kinda curious as to why TX isn't starting.



Adrian
