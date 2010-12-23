Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62050 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0LWHva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 02:51:30 -0500
Received: by gwj20 with SMTP id 20so3442102gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 23:51:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293052778.14423.43.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-6-git-send-email-arik@wizery.com> <1293052778.14423.43.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Dec 2010 09:51:14 +0200
Message-ID: <AANLkTi=32V_O+vDgUq2Z_UhLZArFxAnqzFe3oq8AoJgj@mail.gmail.com>
Subject: Re: [PATCH v2 05/18] wl1271: AP mode - workaround for FW bug on
 station remove
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 23:19, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Sometimes an event indicating station removal is not sent up by
>> firmware. We work around this by always indicating success in when
>> a wait for the event timeouts.
>>
>> Temporary workaround until a FW fix is introduced.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> @@ -1108,9 +1122,11 @@ int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
>>               goto out_free;
>>       }
>>
>> -     ret = wl1271_cmd_wait_for_event(wl, STA_REMOVE_COMPLETE_EVENT_ID);
>> -     if (ret < 0)
>> -             wl1271_error("cmd remove sta event completion error");
>> +     /*
>> +      * We are ok with a timeout here. The event is sometimes not sent
>> +      * due to a firmware bug.
>> +      */
>> +     wl1271_cmd_wait_for_event_or_timeout(wl, STA_REMOVE_COMPLETE_EVENT_ID);
>
> Why wait for the event at all then?
>

Well the bug is pretty rare (something like 1 in 100). Most of the
time we get the event immediately. This way a station can reconnect
very quickly in most cases.

Regards,
Arik
