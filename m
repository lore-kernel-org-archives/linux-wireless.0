Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34108 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaIASzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 14:55:07 -0400
Received: by mail-ig0-f169.google.com with SMTP id r2so2590355igi.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 11:55:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5404BDCE.1050007@lwfinger.net>
References: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com>
	<5404BDCE.1050007@lwfinger.net>
Date: Tue, 2 Sep 2014 00:25:06 +0530
Message-ID: <CAG0uzYM77jdNNbQem_uVN-k5hk2Yh=PaHj=pBXbesocY_9ZHsA@mail.gmail.com> (sfid-20140901_205511_351732_62F01FFF)
Subject: Re: Help needed to interpret kernel warning and call trace
From: Amitav Mohanty <amitavmohanty01@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Larry

Thank you for the prompt reply. I am not a kernel dev. My intension
was to seek help and understand how this impacts my system. I looked
for removing the taint. However, it seems Nvidia driver is the one
that is tainting the kernel. Since this is the laptop I use for work,
I don't think I can remove NVidia driver. If I understand correctly,
using the Nouveau driver instead the proprietary one should remove the
taint. Is there any other way I can help ?

Regards,
Amitav

On Tue, Sep 2, 2014 at 12:11 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/01/2014 01:28 PM, Amitav Mohanty wrote:
>> Hey
>>
>> How do I interpret the following kernel warning?
>>
>> Sep 01 17:13:30 TSS-ARCH kernel: ------------[ cut here ]------------
>> Sep 01 17:13:30 TSS-ARCH kernel: WARNING: CPU: 0 PID: 4 at
>> net/wireless/reg.c:1806 reg_process_hint+0x2d1/0x460 [cfg80211]()
>
> That warning comes from
>
>         /*
>          * Two consecutive Country IE hints on the same wiphy.
>          * This should be picked up early by the driver/stack
>          */
>         if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
>                 return REG_REQ_OK;
>         return REG_REQ_ALREADY_SET;
>
> The problem appears to arise in iwldvm, but before anyone devotes very much
> effort to finding the cause, you will need to reproduce it without that "P"
> taint. From the module list, the offending module appears to be unloaded, but
> the taint remains.
>
> Larry
>
