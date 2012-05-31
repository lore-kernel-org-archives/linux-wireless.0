Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2EaLQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 07:16:00 -0400
Received: by obbtb18 with SMTP id tb18so1208446obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 04:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC74E25.4060603@gmail.com>
References: <1338460487-3277-1-git-send-email-pontus.fuchs@gmail.com>
	<CAD2nsn0xqnnY9yRKvvq=yOgy0G8FeJ9qn4CX7JK3GkzceZ93Ew@mail.gmail.com>
	<4FC74E25.4060603@gmail.com>
Date: Thu, 31 May 2012 16:46:00 +0530
Message-ID: <CAD2nsn02EvhWT74srLWqtVtrA_06NHVgG-08fQ-H1qPyg+rLJw@mail.gmail.com> (sfid-20120531_131605_366421_5A9C26B6)
Subject: Re: [PATCH] mac80211: Clear wowlan flag when drv_suspend returns failure
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 4:25 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> Hi,
>
>
>>> 1. Suspend is started but driver's drv_suspend returns error.
>>> 2. Suspend is aborted. local->wowlan flag is left set.
>>> 3. Interface is removed.
>>
>>
>> got a doubt, in which path interface remove happens ?
>
>
> Note that in between step 2 and 4 userspace is up and running again so I
> just use ifconfig to reproduce this.

thanks!

>
>
>>> 4. Suspend again. This time open_count is 0 so drv_suspend is
>>>   not called and local->wowlan not cleared.
>>> 5. On resume ieee80211_reconfig will call drv_resume since
>>>   local->wowlan is set.
>
>
> //Pontus



-- 
thanks,
shafi
