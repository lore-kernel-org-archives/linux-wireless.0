Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:34896 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3C0Qdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:33:40 -0400
Received: by mail-we0-f176.google.com with SMTP id s43so3183344wey.35
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 09:33:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3bENvfezMSge9_oOJiSsoMpMVFGk+QaSgsHSDASczgn0A@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
	<CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
	<CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
	<CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com>
	<CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
	<5151D752.3080303@candelatech.com>
	<CAMgrJ3b7yZru5P-bYpmmfjYCoSJqUhAMrTzfKnKLPN3CgdeJ4w@mail.gmail.com>
	<CAMgrJ3bENvfezMSge9_oOJiSsoMpMVFGk+QaSgsHSDASczgn0A@mail.gmail.com>
Date: Wed, 27 Mar 2013 09:33:38 -0700
Message-ID: <CAJ-Vmomp2gS34jwWuh7046Y+6mBGCpirG6nk-E37enE3mSh5GA@mail.gmail.com> (sfid-20130327_173353_667997_BB38B0AA)
Subject: Re: [ath9k-devel] Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good catch! Can you add that to the bugzilla bug please?



Adrian


On 26 March 2013 20:11, Robert Shade <robert.shade@gmail.com> wrote:
> Think I found it:  In ath_reset_internal, before we reset, we call
> ath_prepare_reset, which calls ath9k_hw_disable_interrupts.  If the
> channel change fails, we never call ath_complete_reset, which calls
> ath9k_hw_enable_interrupts.
>
> ath9k_hw_{enable|disable}_interrupts calls definitely needs to be
> balanced.  Looking at an old log, IER never gets re-enabled after the
> channel set failure.
>
> Any suggestions on the proper cleanup?  Could we just call
> ath_complete_reset anyway?  Some sort of special handling?
>
> On Tue, Mar 26, 2013 at 8:55 PM, Robert Shade <robert.shade@gmail.com> wrote:
>> On Tue, Mar 26, 2013 at 1:13 PM, Ben Greear <greearb@candelatech.com> wrote:
>>> Can you cat out the /debug/ieee80211/wiphy0/ath9k/xmit
>>> file when it gets in this hung state?  I saw issues where
>>> the xmit queues got hung in our AR9380 NIC systems and
>>> ended up adding an ugly bit of cleanup/reset logic to
>>> get them working again...
>>
>> Dumps are attached on to the bug.  I remember being hopeful when
>> reading your thread that we stumbled on the same issue, but the
>> symptoms don't look the same to me because pending-frames goes back to
>> 0 in my case.
