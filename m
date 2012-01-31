Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46935 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2AaJnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:43:05 -0500
Received: by iacb35 with SMTP id b35so619340iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:43:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bopkcnv6.fsf@purkki.adurom.net>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	<87fwexco94.fsf@purkki.adurom.net>
	<CAB3XZEfaQAD0p2VJ28znznaB3P_3z3NvEiROJTbyCW+su2gLzg@mail.gmail.com>
	<87bopkcnv6.fsf@purkki.adurom.net>
Date: Tue, 31 Jan 2012 11:43:04 +0200
Message-ID: <CAB3XZEfHSRiH7x91-aUi0wHvBmAjj5mgj7=_8NE3+DOdZbRdGg@mail.gmail.com> (sfid-20120131_104311_389644_2620039D)
Subject: Re: [PATCH 00/12] wl12xx: update fw api
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 9:50 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Eliad Peller <eliad@wizery.com> writes:
>
>> On Mon, Jan 30, 2012 at 3:29 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> Eliad Peller <eliad@wizery.com> writes:
>>>
>>>> The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
>>>> and 7.3.5.0.95 for wl128x).
>>>>
>>>> Along with some small adjustments, the main changes
>>>> inroduced by this patheset are configuring the
>>>> templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
>>>> mode.
>>>
>>> I didn't look so carefully, but doesn't this break bisect? I mean if you
>>> change the firmware api in small patches wl12xx can't work properly
>>> until all patches are applied, right?
>>>
>>> I would say that a huge patch doing all the necessary changes in one go
>>> is better, even it's ugly.
>>>
>> yes. it will break bisect (although it shouldn't break compilations).
>> i guess it's a matter of taste, but i think keeping the patches
>> manageable is more important than being able to bisect.
>
> Yeah, it's just matter of taste. It's easy to skip commits during bisect
> but someone not familiar with wl12xx does not know what commits to
> skip and that will cause problems.
>
> But I don't care how you do it, I just wanted to point out this aspect :)
>
ok, thanks :)

i took Luca's approach, and added an error message to the driver, and
prevented it from starting in the transitional commits. i'll send an
updated patchset soon.

Eliad.
