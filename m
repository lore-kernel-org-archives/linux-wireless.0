Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48851 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1HKMaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 08:30:04 -0400
Received: by gwaa12 with SMTP id a12so1261532gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 05:30:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313063593.2407.850.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-38-git-send-email-eliad@wizery.com>
	<1313063593.2407.850.camel@cumari>
Date: Thu, 11 Aug 2011 15:30:03 +0300
Message-ID: <CAB3XZEfoAwocZodtGxRbWAax9BZBZkiU27jPBDAafHvEefNmYQ@mail.gmail.com> (sfid-20110811_143008_419614_7712CBF2)
Subject: Re: [PATCH 37/40] wl12xx: don't wait for disconnection event
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 2:53 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> Sometimes the fw doesn't send the DISCONNECT_EVENT_COMPLETE_ID
>> on station role stop, so don't wait for it.
>
> Why? A bug? Or any good reason for it?
>
i'm still waiting for a definite answer answer from the fw guys about
the expected behavior.

>
>> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
>> index 9ef8621..ad926d2 100644
>> --- a/drivers/net/wireless/wl12xx/cmd.c
>> +++ b/drivers/net/wireless/wl12xx/cmd.c
>> @@ -640,18 +640,12 @@ int wl1271_cmd_role_stop_sta(struct wl1271 *wl)
>>       ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
>>       if (ret < 0) {
>>               wl1271_error("failed to initiate cmd role stop");
>>               goto out_free;
>>       }
>>
>> -     ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
>> -     if (ret < 0) {
>> -             wl1271_error("cmd role stop sta event completion error");
>> -             goto out_free;
>> -     }
>> -
>
> Can't this cause possible race conditions in the firmware if, for
> instance, we stop and start the sta role quickly?
>
according to the fw guys, it should work.

Eliad.
