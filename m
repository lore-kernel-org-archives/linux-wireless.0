Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36690 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab2AaHuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 02:50:07 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/12] wl12xx: update fw api
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	<87fwexco94.fsf@purkki.adurom.net>
	<CAB3XZEfaQAD0p2VJ28znznaB3P_3z3NvEiROJTbyCW+su2gLzg@mail.gmail.com>
Date: Tue, 31 Jan 2012 09:50:05 +0200
In-Reply-To: <CAB3XZEfaQAD0p2VJ28znznaB3P_3z3NvEiROJTbyCW+su2gLzg@mail.gmail.com>
	(Eliad Peller's message of "Mon, 30 Jan 2012 15:52:06 +0200")
Message-ID: <87bopkcnv6.fsf@purkki.adurom.net> (sfid-20120131_085011_829082_3A02C243)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> On Mon, Jan 30, 2012 at 3:29 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> Eliad Peller <eliad@wizery.com> writes:
>>
>>> The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
>>> and 7.3.5.0.95 for wl128x).
>>>
>>> Along with some small adjustments, the main changes
>>> inroduced by this patheset are configuring the
>>> templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
>>> mode.
>>
>> I didn't look so carefully, but doesn't this break bisect? I mean if you
>> change the firmware api in small patches wl12xx can't work properly
>> until all patches are applied, right?
>>
>> I would say that a huge patch doing all the necessary changes in one go
>> is better, even it's ugly.
>>
> yes. it will break bisect (although it shouldn't break compilations).
> i guess it's a matter of taste, but i think keeping the patches
> manageable is more important than being able to bisect.

Yeah, it's just matter of taste. It's easy to skip commits during bisect
but someone not familiar with wl12xx does not know what commits to
skip and that will cause problems.

But I don't care how you do it, I just wanted to point out this aspect :)

-- 
Kalle Valo
