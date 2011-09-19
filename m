Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1ISHHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 03:07:46 -0400
Received: by iaqq3 with SMTP id q3so5007998iaq.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 00:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316409710.2157.18.camel@cumari>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
	<1316347759-22030-2-git-send-email-eliad@wizery.com>
	<1316409710.2157.18.camel@cumari>
Date: Mon, 19 Sep 2011 10:07:46 +0300
Message-ID: <CAB3XZEcKsFZfpJWEV5k3Q5HY68Zr9f4uVDLs5tvFJLOKxeoC1g@mail.gmail.com> (sfid-20110919_090748_857342_49A9B0A3)
Subject: Re: [PATCH 2/2] wl12xx: handle CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 8:21 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-09-18 at 15:09 +0300, Eliad Peller wrote:
>> The fw sends the CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID event
>> when it wants the driver to increase the dynamic ps (auto-mode)
>> timeout (or restore the original timeout).
>>
>> unmask CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID, and increase/restore
>> the dynamic ps default timeout upon getting this event.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Okay, now I see you're doing it automatically here (I should read all
> the series before commenting :P).  Anyway, do we really need the debugfs
> stuff? It's okay to make it readable, but I still don't see why we need
> to write.
>
i used the debugfs entry for debugging.
i don't mind dropping it.

>
>> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
>> index c73fe4c..79ff3bb 100644
>> --- a/drivers/net/wireless/wl12xx/event.c
>> +++ b/drivers/net/wireless/wl12xx/event.c
>> @@ -258,6 +258,14 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
>>               wl12xx_event_soft_gemini_sense(wl,
>>                                              mbox->soft_gemini_sense_info);
>>
>> +     if (vector & CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID &&
>> +         wl->bss_type == BSS_TYPE_STA_BSS) {
>> +             int timeout = -1;
>> +             if (mbox->change_auto_mode_timeout)
>> +                     timeout = 500;
>> +             ieee80211_set_dyn_ps_timeout(wl->vif, timeout);
>> +     }
>> +
>>       /*
>>        * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
>>        * filtering) is enabled. Without PSM, the stack will receive all
>
> Any more details on why you chose 500? Should this be part of conf or a
> macro to avoid magic numbers?
>
500 was the magic number i got from the coex guys :)
i'll add it to the conf.

thanks for the review,
Eliad.
