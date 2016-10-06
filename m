Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36611 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932652AbcJFSvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 14:51:21 -0400
Received: by mail-it0-f66.google.com with SMTP id o19so2250637ito.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2016 11:51:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWCxLUz0=EUgtNQ5pLo2wCEpsMeNQHYCpKfh12irp6NDg@mail.gmail.com>
References: <20161005115013.GA22099@symbol-HP-ZBook-15> <CAGRGNgWCxLUz0=EUgtNQ5pLo2wCEpsMeNQHYCpKfh12irp6NDg@mail.gmail.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Fri, 7 Oct 2016 00:21:13 +0530
Message-ID: <CAFqt6zYpMJKrX51--eHXKSEcgb+KVJ7ULjoL==DNKyOeOB5_4Q@mail.gmail.com> (sfid-20161006_205128_870516_199937DA)
Subject: Re: [PATCH] [wl18xx] Fix memory leakage if kzalloc fails
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Rameshwar Sahu <sahu.rameshwar73@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,


On Thu, Oct 6, 2016 at 3:05 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi,
>
> On Wed, Oct 5, 2016 at 10:50 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> This patch is added to properly handle memory leak if kzalloc fails
>> in wl18xx_scan_send() and wl18xx_scan_sched_scan_config()
>
> What memory leak?

My Apologies here. I was addressing here about freeing the invalid memories.
But I put wrong description. I will resend this patch with proper
descriptions and addressing your comments.
>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> Signed-off-by: Rameshwar Sahu <sahu.rameshwar73@gmail.com>
>
> Why two signed-off-bys?

We both were involved in addressing this.
>
>> ---
>>  drivers/net/wireless/ti/wl18xx/scan.c | 20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
>> index 4e522154..aed22e1 100644
>> --- a/drivers/net/wireless/ti/wl18xx/scan.c
>> +++ b/drivers/net/wireless/ti/wl18xx/scan.c
>> @@ -41,14 +41,13 @@ static void wl18xx_adjust_channels(struct wl18xx_cmd_scan_params *cmd,
>>  static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>                             struct cfg80211_scan_request *req)
>>  {
>> -       struct wl18xx_cmd_scan_params *cmd;
>> +       struct wl18xx_cmd_scan_params *cmd = NULL;
>>         struct wlcore_scan_channels *cmd_channels = NULL;
>>         int ret;
>>
>>         cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>>         if (!cmd) {
>> -               ret = -ENOMEM;
>> -               goto out;
>> +               return -ENOMEM;
>>         }
>>
>>         /* scan on the dev role if the regular one is not started */
>> @@ -59,7 +58,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>
>>         if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
>>                 ret = -EINVAL;
>> -               goto out;
>> +               goto err_cmd_free;
>>         }
>>
>>         cmd->scan_type = SCAN_TYPE_SEARCH;
>> @@ -84,7 +83,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>         cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
>>         if (!cmd_channels) {
>>                 ret = -ENOMEM;
>> -               goto out;
>> +               goto err_cmd_free;
>>         }
>>
>>         wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
>> @@ -153,6 +152,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>
>>  out:
>>         kfree(cmd_channels);
>> +err_cmd_free:
>
> kfree(NULL) is valid,

I agree with you. As *cmd not initialized with NULL, so it can hold a
garbage address.
In case of memory allocation failure, kernel may enter in abnormal
behavior while freeing this memory.

 so therefore the out: and err_cmd_free: labels
> are equivalent from a memory freeing perspective, so where exactly are
> we leaking memory in this function?

I want to avoid kfree(cmd_channels) calls when we have not allocated the memory.

>
>>         kfree(cmd);
>>         return ret;
>>  }
>> @@ -171,7 +171,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
>>                                   struct cfg80211_sched_scan_request *req,
>>                                   struct ieee80211_scan_ies *ies)
>>  {
>> -       struct wl18xx_cmd_scan_params *cmd;
>> +       struct wl18xx_cmd_scan_params *cmd = NULL;
>>         struct wlcore_scan_channels *cmd_channels = NULL;
>>         struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
>>         int ret;
>> @@ -185,15 +185,14 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
>>
>>         cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>>         if (!cmd) {
>> -               ret = -ENOMEM;
>> -               goto out;
>> +               return -ENOMEM;
>>         }
>>
>>         cmd->role_id = wlvif->role_id;
>>
>>         if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
>>                 ret = -EINVAL;
>> -               goto out;
>> +               goto err_cmd_free;
>>         }
>>
>>         cmd->scan_type = SCAN_TYPE_PERIODIC;
>> @@ -218,7 +217,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
>>         cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
>>         if (!cmd_channels) {
>>                 ret = -ENOMEM;
>> -               goto out;
>> +               goto err_cmd_free;
>>         }
>>
>>         /* configure channels */
>> @@ -296,6 +295,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
>>
>>  out:
>>         kfree(cmd_channels);
>> +err_cmd_free:
>
> Same question here.

Please refer above comment for the same.
>
>>         kfree(cmd);
>>         return ret;
>>  }
>> --
>> 1.9.1
>>
>
>
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
