Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60479 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab2EaKzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 06:55:40 -0400
Received: by lahd3 with SMTP id d3so597559lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 03:55:39 -0700 (PDT)
Message-ID: <4FC74E25.4060603@gmail.com> (sfid-20120531_125544_087373_7236040A)
Date: Thu, 31 May 2012 12:55:33 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Clear wowlan flag when drv_suspend returns
 failure
References: <1338460487-3277-1-git-send-email-pontus.fuchs@gmail.com> <CAD2nsn0xqnnY9yRKvvq=yOgy0G8FeJ9qn4CX7JK3GkzceZ93Ew@mail.gmail.com>
In-Reply-To: <CAD2nsn0xqnnY9yRKvvq=yOgy0G8FeJ9qn4CX7JK3GkzceZ93Ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> 1. Suspend is started but driver's drv_suspend returns error.
>> 2. Suspend is aborted. local->wowlan flag is left set.
>> 3. Interface is removed.
>
> got a doubt, in which path interface remove happens ?

Note that in between step 2 and 4 userspace is up and running again so I 
just use ifconfig to reproduce this.

>> 4. Suspend again. This time open_count is 0 so drv_suspend is
>>    not called and local->wowlan not cleared.
>> 5. On resume ieee80211_reconfig will call drv_resume since
>>    local->wowlan is set.

//Pontus
