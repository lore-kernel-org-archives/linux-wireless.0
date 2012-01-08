Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62555 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2AHVod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 16:44:33 -0500
Received: by werm1 with SMTP id m1so2214604wer.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 13:44:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F09C1E2.6020907@gmail.com>
References: <4F09AAE5.2080209@gmail.com>
	<4F09BEC0.7080702@lwfinger.net>
	<4F09C1E2.6020907@gmail.com>
Date: Sun, 8 Jan 2012 22:44:32 +0100
Message-ID: <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com> (sfid-20120108_224440_612149_A55B64C6)
Subject: Re: modprob b43 not work after hilibernate
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: lina <lina.lastname@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/8 lina <lina.lastname@gmail.com>:
> On Monday 09,January,2012 12:05 AM, Larry Finger wrote:
>>
>> On 01/08/2012 08:40 AM, lina wrote:
>>>
>>> Hi,
>>>
>>> after hibernation,
>>>
>>> I tried modprob b43 and /etc/initi.d/network-manager restart not work,
>>>
>>> is it reboot the only option. ( I googled it seems, not so sure)
>>
>>
>> Hibernation involves so many parts of the computer that it is hard to
>> tell what is happening. If unloading and reloading b43 using modprobe
>> does not help, then it is not solely a problem with b43.
>>
>> You need to provide a better description of what you are doing. Include
>> specific output from dmesg and the exact commands you are trying. You
>> should also include what distro you are running, your kernel version,
>> and what brand and model of computer you are using.
>
>
> It's fine with me to reboot.
>
> 3.2.0-1 SMP  x86_64 GNU/Linux
>
> Debian wheezy.
>
> I upload the dmesg output in the following link,
>
> https://docs.google.com/open?id=0B93SVRfpVVg3ZThiYmQ3NjctOWU2Ni00ODQ5LTgzMGMtMGMyMDgxMjVjYTFl
>
> It's absolutely not something urgent or very-necessary to me, so just take
> your time and interest, I was just asking. btw, if there is some problem in
> the dmesg, maybe not high relevant to this topic, please also feel free to
> let me know.
> any further info you need just let me know,

I'm not sure if I can see suspend&resume in your dmesg...

What does happen after resume? What after reloading b43? Have you
tried reloading both: b43 and bcma:
rmmod b43
rmmod bcma
modprobe b43
?
Does your kernel have
[PATCH] bcma: support for suspend and resume
applied?

-- 
Rafał
