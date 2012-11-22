Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45526 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965190Ab2KVTzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:55:23 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so8334951oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:55:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353593475.27848.58.camel@cumari.coelho.fi>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
	<1353585928-28666-5-git-send-email-eliad@wizery.com>
	<1353593475.27848.58.camel@cumari.coelho.fi>
Date: Thu, 22 Nov 2012 16:22:01 +0200
Message-ID: <CAB3XZEdy6kTVxMYijut3n4gRQLccd6DetqDCJwrusFgqPYRCWA@mail.gmail.com> (sfid-20121122_205536_140800_072F4FA0)
Subject: Re: [PATCH 04/13] wlcore: split 18xx and 12xx scan mechanism
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2012 at 4:11 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Thu, 2012-11-22 at 14:05 +0200, Eliad Peller wrote:
>> The scan APIs of 12xx and 18xx are totally different.
>> Use some common functions as much as possible (e.g.
>> for setting scan channels), but split scan.c into
>> chip-specific scan.c files, each implementing its
>> own scan mechanism.
>>
>> (in other words - move most of the current wlcore's
>> scan.c into wl12xx, and implement a similar mechanism
>> in 18xx, according to the new api)
>>
>> New wlcore ops are introduced in order to call the
>> chip-specific scan functions.
>>
>> The template indices used for each scan (regular/scheduled)
>> are also different between the chips, so set the correct
>> indices used for each scan type after identifying the chip.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> +/* probe request rate */
>> +enum
>> +{
>> +     WLCORE_SCAN_RATE_1      = 0,
>> +     WLCORE_SCAN_RATE_5_5    = 1,
>> +     WLCORE_SCAN_RATE_6      = 2,
>> +};
>
> WL18XX_SCAN_RATE_* instead?
>
right.

>> +
>> +struct wl1271_cmd_scan_params {
>
> wl18xx_cmd_scan_params is better.
>
> [...]
>
>> +struct wl12xx_cmd_scan_stop {
>
> wl18xx_cmd_scan_stop instead?
>
sure (both).

> [...]
>
>> @@ -3820,10 +3817,8 @@ static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>                                               wlvif->band);
>>
>>       /* we only support sched_scan while not connected */
>> -     if (wl->sched_scanning) {
>> -             wl1271_scan_sched_scan_stop(wl, wlvif);
>> -             ieee80211_sched_scan_stopped(wl->hw);
>> -     }
>> +     if (wl->sched_scanning)
>> +             wl->ops->sched_scan_stop(wl, wlvif);
>
> What happened with the ieee80211_sched_scan_stopped()?
>
it was a bug - we call it when we get the SCAN_SCHED_COMPLETED event.
i fixed it while changing the api, but i guess a better place to do it
would be in patch [1/12], where i moved it from another place :)
or maybe it even deserves a separate patch?

Eliad.
