Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52012 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1EMHog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 03:44:36 -0400
Received: by bwz15 with SMTP id 15so1916587bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 00:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305231858.12586.1050.camel@cumari>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	<1305104068-32240-8-git-send-email-eliad@wizery.com>
	<1305231858.12586.1050.camel@cumari>
Date: Fri, 13 May 2011 10:44:35 +0300
Message-ID: <BANLkTinEomxNa20MjCVG8DHeXjMgSMVYGA@mail.gmail.com> (sfid-20110513_094440_238886_E9FFCC1E)
Subject: Re: [PATCH 7/7] wl12xx: enter/exit psm on wowlan suspend/resume
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 11:24 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
>> When operating as station, enter psm before suspending
>> the device into wowlan state.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index 308855a..b4dd1d9 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -1332,6 +1332,79 @@ static struct notifier_block wl1271_dev_notifier = {
>>       .notifier_call = wl1271_dev_notify,
>>  };
>>
>> +static int wl1271_configure_suspend(struct wl1271 *wl)
>> +{
>> +     int ret;
>> +
>> +     if (wl->bss_type != BSS_TYPE_STA_BSS)
>> +             return 0;
>> +
>> +     mutex_lock(&wl->mutex);
>> +
>> +     ret = wl1271_ps_elp_wakeup(wl);
>> +     if (ret < 0)
>> +             goto out_unlock;
>> +
>> +     /* enter psm if needed*/
>> +     if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
>> +             DECLARE_COMPLETION_ONSTACK(compl);
>> +
>> +             wl->ps_compl = &compl;
>> +             ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
>> +                                wl->basic_rate, true);
>> +             if (ret < 0)
>> +                     goto out_sleep;
>> +
>> +             /* we must unlock here so we will be able to get events */
>> +             wl1271_ps_elp_sleep(wl);
>> +             mutex_unlock(&wl->mutex);
>> +
>> +             ret = wait_for_completion_timeout(
>> +                     &compl, msecs_to_jiffies(500));
>
> We have this for the ELP wakeup:
>
> #define WL1271_WAKEUP_TIMEOUT 500
>
> We should have a similar definition PS timeout.  And is this value just
> a guess or is there a real meaning to it? Can these timeouts be combined
> instead of having separate defines?
>
this number is arbitrary.
i don't think we should combine it with the elp timeout, as they
represent different arbitrary values :)
but i'll #define it.

thanks,
Eliad.
