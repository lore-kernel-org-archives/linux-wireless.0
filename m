Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34420 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZDBFw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 01:52:28 -0400
Received: by fxm2 with SMTP id 2so342568fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 22:52:25 -0700 (PDT)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Always send a null data frame if TIM bit is  set.
References: <20090302145030.GA4660@myhost.users.atheros.com>
	<8e92b4100903312115l2f013083jf507b66f8449a63a@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 02 Apr 2009 08:52:22 +0300
In-Reply-To: <8e92b4100903312115l2f013083jf507b66f8449a63a@mail.gmail.com> (Vivek Natarajan's message of "Wed\, 1 Apr 2009 09\:45\:10 +0530")
Message-ID: <87ocvfiovd.fsf@litku.valot.fi> (sfid-20090402_075231_784877_7FBB0EC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> Although the above patch is a right approach, it opens up an issue
> with pspolling.
>
> In the above chunk of code, if the timeout is zero, instead of
> sending a null frame to correct the state in the AP, we may keep on
> sending ps poll frames ( And the ps state in the AP will never be
> corrected)
>
> I have not tested pspolling with ath9k. But this seems to be an issue.
> Thoughts?

Maybe it's better to have a separate test for the case that TIM bit is
set but we are not in power save and just send a nullfunc frame
without psm bit. And leave the original power save code as it was.

I really would like to have some frame ack callback to mac80211, even
not all drivers support that. Otherwise we cannot reliably go to power
save because the AP might not receive our nullfunc frame. I have to
think about this and I'll try to propose something later on.

-- 
Kalle Valo
