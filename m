Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:39344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZBDTcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:32:25 -0500
Received: by ug-out-1314.google.com with SMTP id 39so112770ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 11:32:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com>
	 <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com>
	 <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
Date: Wed, 4 Feb 2009 19:32:23 +0000
Message-ID: <a4c529250902041132t6e9bcb79jfd412320fc088ff4@mail.gmail.com> (sfid-20090204_203230_538823_348F9463)
Subject: Re: zd1211rw NEW RF Type
From: Ismael Ojeda Perez <iojedaperez@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/4 Hin-Tak Leung <hintak.leung@gmail.com>:
> On Wed, Feb 4, 2009 at 10:43 AM, Ismael Ojeda Perez
> <iojedaperez@gmail.com> wrote:
>> Hi, huston we have a problem
>> I have purchased a tp-link usb wireless device
>> model : tl-wn422g
>> i cant work with it because it says there is a new RF type
>> here its what dmesg shows
>
>> [  526.984508] zd1211rw 7-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
>
> You probably don't hang out in the right place... two people on the
> sourceforge zd1211 mailing list recently reported that
> MAXIM_NEW_RF=0x08 is just the same as    UW2453_RF=0x09 ; and one of
> them has a wn422g and the other wn322g
> (I just went back the mailing list archive and checked), so it is
> likely the same change would work for you:
>
> in drivers/net/wireless/zd1211rw/zd_rf.c, line 89, you see:
>
> --------------------
>        case UW2453_RF:
>                r = zd_rf_init_uw2453(rf);
>                break;
> ---------------------
> Just put an extra line
>
>         case MAXIM_NEW_RF:
> either immediately before or immediately after the case UW2453_RF: line.
>
> If it reports success for you, maybe we'll consider putting this in
> properly... I am not the maintainer for that part, so it is likely
> we'll need advice/approval from somebody else for this change to go
> into the kernel.
>

Thanks for your kind help as you say it was as easy as modifying the
line and the device is now working perfectly.
i added just below line 89 the following code
case MAXIM_NEW_RF:
		r = zd_rf_init_uw2453(rf);
		break;
Thanks ;) to you all and to the open comunity.
