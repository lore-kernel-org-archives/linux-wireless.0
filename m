Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61742 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423574Ab2LGSRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 13:17:36 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so380049qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 10:17:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354882758.31150.7.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
 <1354095769-8724-14-git-send-email-arik@wizery.com> <1354882758.31150.7.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 7 Dec 2012 20:17:20 +0200
Message-ID: <CA+XVXffZLyVq+DuqAPj9GTJYAGi5VLW9OU0fSLbGmWUUuEQSDw@mail.gmail.com> (sfid-20121207_191742_347454_EF710B0C)
Subject: Re: [PATCH 13/20] wlcore: use link count for single-STA-PSM optimization
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 2:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
>> Only allow a PSM STA to congest FW memory when it is the single active
>> link. Being a single STA doesn't imply a single link - there might be
>> other links on other roles.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
>> index 1fbee0d..28a3027 100644
>> --- a/drivers/net/wireless/ti/wlcore/cmd.c
>> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
>> @@ -328,6 +328,8 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
>>                       wl->fw_status_2->counters.tx_lnk_free_pkts[link];
>>       wl->links[link].wlvif = wlvif;
>>       *hlid = link;
>> +
>> +     wl->active_link_count++;
>>       return 0;
>>  }
>>
>> @@ -357,6 +359,8 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
>>       wl->links[*hlid].wlvif = NULL;
>>
>>       *hlid = WL12XX_INVALID_LINK_ID;
>> +     wl->active_link_count--;
>> +     WARN_ON(wl->active_link_count < 0);
>
> This could be WARN_ON_ONCE().  If we hit this once, it's highly likely
> that we will keep hitting it later on, unless we have another bug that
> would cancel this one out. ;)
>
> I can convert this myself if you agree.

Sounds right. Thanks.
