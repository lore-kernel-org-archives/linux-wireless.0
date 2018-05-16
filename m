Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbeEPJ1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 05:27:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc: Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] wlcore: Add support runtime PM
References: <20180515161315.1997-1-tony@atomide.com>
        <20180515161315.1997-3-tony@atomide.com>
        <CAOf5uwkT4Vg1kQn5k=_z9XjXOLWbA0vioqH6KSdikZbCwyaYbA@mail.gmail.com>
Date: Wed, 16 May 2018 12:27:46 +0300
In-Reply-To: <CAOf5uwkT4Vg1kQn5k=_z9XjXOLWbA0vioqH6KSdikZbCwyaYbA@mail.gmail.com>
        (Michael Nazzareno Trimarchi's message of "Tue, 15 May 2018 18:17:39
        +0200")
Message-ID: <87a7t0lzl9.fsf@kamboji.qca.qualcomm.com> (sfid-20180516_112758_726372_FDBD901C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Nazzareno Trimarchi <michael@amarulasolutions.com> writes:

>> @@ -315,15 +319,17 @@ static ssize_t dynamic_fw_traces_write(struct file *file,
>>         if (unlikely(wl->state != WLCORE_STATE_ON))
>>                 goto out;
>>
>> -       ret = wl1271_ps_elp_wakeup(wl);
>> -       if (ret < 0)
>> +       ret = pm_runtime_get_sync(wl->dev);
>> +       if (ret < 0) {
>> +               pm_runtime_put_noidle(wl->dev);
>>                 goto out;
>> +       }
>>
>
> Can you just change ps_elp_wakeup with
>        ret = pm_runtime_get_sync(wl->dev);
>        if (ret < 0) {
>                pm_runtime_put_noidle(wl->dev);
>                  goto out;
>        }
>
>>         ret = wl18xx_acx_dynamic_fw_traces(wl);
>>         if (ret < 0)
>>                 count = ret;
>>
>> -       wl1271_ps_elp_sleep(wl);
>> +       pm_runtime_put(wl->dev);
>
> and elp_sleep with this one
>
>>  out:
>>         mutex_unlock(&wl->mutex);
>>         return count;
>> @@ -374,9 +380,11 @@ static ssize_t radar_debug_mode_write(struct file *file,
>>         if (unlikely(wl->state != WLCORE_STATE_ON))
>>                 goto out;
>>
>> -       ret = wl1271_ps_elp_wakeup(wl);
>> -       if (ret < 0)
>> +       ret = pm_runtime_get_sync(wl->dev);
>> +       if (ret < 0) {
>> +               pm_runtime_put_noidle(wl->dev);
>>                 goto out;
>> +       }
>>
>>         wl12xx_for_each_wlvif_ap(wl, wlvif) {
>>                 wlcore_cmd_generic_cfg(wl, wlvif,
>> @@ -384,7 +392,7 @@ static ssize_t radar_debug_mode_write(struct file *file,
>>                                        wl->radar_debug_mode, 0);
>>         }
>>
>> -       wl1271_ps_elp_sleep(wl);
>> +       pm_runtime_put(wl->dev);
>
> Michael

<over 1600 lines of unnecessary quotation cut out>

PLEASE edit your quotes, your behaviour makes use of patchwork really
annoying:

https://patchwork.kernel.org/patch/10401591/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
