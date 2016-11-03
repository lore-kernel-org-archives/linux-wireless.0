Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34053 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754383AbcKCKva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 06:51:30 -0400
Received: by mail-oi0-f65.google.com with SMTP id 62so5899920oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 03:51:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0xv4a1O7tqBYABsXbRvRQm_3Va888EopKDz433cwjXew@mail.gmail.com>
References: <20161103095938.84054-1-nbd@nbd.name> <CANUX_P0xv4a1O7tqBYABsXbRvRQm_3Va888EopKDz433cwjXew@mail.gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 3 Nov 2016 12:51:29 +0200
Message-ID: <CANUX_P1vktccTAQZOFRdVS9ndg4XEZNw0Ec=0sFL+n7SL2g+dQ@mail.gmail.com> (sfid-20161103_115134_679301_FD6B7DE6)
Subject: Re: [PATCH] mac80211: fix broken AP mode handling of powersave clients
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 3, 2016 at 12:51 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Thu, Nov 3, 2016 at 11:59 AM, Felix Fietkau <nbd@nbd.name> wrote:
>> Commit c68df2e7be0c ("mac80211: allow using AP_LINK_PS with
>> mac80211-generated TIM IE") introduced a logic error, where
>> __sta_info_recalc_tim turns into a no-op if local->ops->set_tim is not
>> set. This prevents the beacon TIM bit from being set for all drivers
>> that do not implement this op (almost all of them), thus thoroughly
>> essential AP mode powersave functionality.
>>
>> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Fixes: c68df2e7be0c ("mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE")
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  net/mac80211/sta_info.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>> index 236d47e..621734e 100644
>> --- a/net/mac80211/sta_info.c
>> +++ b/net/mac80211/sta_info.c
>> @@ -688,7 +688,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
>>         }
>>
>>         /* No need to do anything if the driver does all */
>> -       if (!local->ops->set_tim)
>> +       if (local->ops->set_tim)
>>                 return;
>
> but ... then, you'll need call to drv_set_tim below...

s/need/never/

> Apparently, we can't rely on the ops pointer to enter or not enter this flow.
