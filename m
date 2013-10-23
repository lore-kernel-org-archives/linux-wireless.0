Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38266 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3JWHhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 03:37:04 -0400
Received: by mail-ie0-f178.google.com with SMTP id x13so702307ief.9
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 00:37:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382505837.21526.12.camel@porter.coelho.fi>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
	<1378718684-14430-11-git-send-email-eliad@wizery.com>
	<1382505837.21526.12.camel@porter.coelho.fi>
Date: Wed, 23 Oct 2013 09:37:03 +0200
Message-ID: <CAB3XZEdDhV8GBON3bVR9_mXU3ExAQ+EQpKac=ChoTtDhcztRjA@mail.gmail.com> (sfid-20131023_093709_289464_F06421C3)
Subject: Re: [PATCH 11/13] wlcore: memset wl->rx_filter_enabled to zero after recovery
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 23, 2013 at 8:23 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2013-09-09 at 12:24 +0300, Eliad Peller wrote:
>> From: Nadim Zubidat <nadimz@ti.com>
>>
>> zero rx_filter_enabled array after recovery to avoid
>> cases were the driver will keep trying to clear a
>> filter which is not configured in FW.
>>
>> Such case will cause consecutive recoveries due to
>> command execution failures.
>>
>> Signed-off-by: Nadim Zubidat <nadimz@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/main.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>> index 60b2113..acb3502 100644
>> --- a/drivers/net/wireless/ti/wlcore/main.c
>> +++ b/drivers/net/wireless/ti/wlcore/main.c
>> @@ -1915,6 +1915,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
>>       memset(wl->links_map, 0, sizeof(wl->links_map));
>>       memset(wl->roc_map, 0, sizeof(wl->roc_map));
>>       memset(wl->session_ids, 0, sizeof(wl->session_ids));
>> +     memset(wl->rx_filter_enabled, 0, sizeof(wl->rx_filter_enabled));
>>       wl->active_sta_count = 0;
>>       wl->active_link_count = 0;
>
> This causes a sparse warning:
>
> drivers/net/wireless/ti/wlcore/main.c:1918:42: error: cannot size expression
>
> Booleans cannot be sized. :(
>
err...
i'll fix it (probably simply replacing the bool with int) and add the
updated patch to the next patchset i'll send.

thanks,
Eliad.
