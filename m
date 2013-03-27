Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:50693 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3C0A4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 20:56:15 -0400
Received: by mail-ia0-f175.google.com with SMTP id y26so7006501iab.34
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 17:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5151D752.3080303@candelatech.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
 <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
 <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
 <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
 <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
 <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com> <5151D752.3080303@candelatech.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 26 Mar 2013 20:55:54 -0400
Message-ID: <CAMgrJ3b7yZru5P-bYpmmfjYCoSJqUhAMrTzfKnKLPN3CgdeJ4w@mail.gmail.com> (sfid-20130327_015620_108734_70B8F7B0)
Subject: Re: [ath9k-devel] Auth Packet TX Delay
To: Ben Greear <greearb@candelatech.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 26, 2013 at 1:13 PM, Ben Greear <greearb@candelatech.com> wrote:
> Can you cat out the /debug/ieee80211/wiphy0/ath9k/xmit
> file when it gets in this hung state?  I saw issues where
> the xmit queues got hung in our AR9380 NIC systems and
> ended up adding an ugly bit of cleanup/reset logic to
> get them working again...

Dumps are attached on to the bug.  I remember being hopeful when
reading your thread that we stumbled on the same issue, but the
symptoms don't look the same to me because pending-frames goes back to
0 in my case.
