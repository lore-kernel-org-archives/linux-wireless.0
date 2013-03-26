Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52218 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3CZROR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:14:17 -0400
Message-ID: <5151D752.3080303@candelatech.com> (sfid-20130326_181422_048325_E3CBC3C5)
Date: Tue, 26 Mar 2013 10:13:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Robert Shade <robert.shade@gmail.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: [ath9k-devel] Auth Packet TX Delay
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com> <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com> <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com> <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com> <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com> <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com> <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
In-Reply-To: <CAMgrJ3Zy1EKBcdcVouK9=r6=ErU8R72-=aC149VPT1Cg9=wiTg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2013 09:29 AM, Robert Shade wrote:
> On Tue, Mar 26, 2013 at 12:28 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>> On 26 March 2013 05:21, Robert Shade <robert.shade@gmail.com> wrote:
>>> I'll get a bug together, but I wanted to report that even with the
>>> patch above (fastcc disabled/cold reset always), it still eventually
>>> was unable to change the channel.  As soon as that failed, it's back
>>> into the state where it never seems to xmit anything in the data
>>> queues and can't associate.
>>
>> Even after a cold reset?
>
> Yes, which is why I'm curious about the start/stop queues calls. It
> looks to my (untrained) eye that it's simply not processing the data
> queue.

Can you cat out the /debug/ieee80211/wiphy0/ath9k/xmit
file when it gets in this hung state?  I saw issues where
the xmit queues got hung in our AR9380 NIC systems and
ended up adding an ugly bit of cleanup/reset logic to
get them working again...

Here's the related email thread.

https://patchwork.kernel.org/patch/2174221/

My work-around was too ugly for upstream, but if you decide you
want to try it out, I'm curious to know if it fixes your
problems.

You can find my tree here:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

