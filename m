Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35878 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbcKCLKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 07:10:13 -0400
Received: by mail-oi0-f67.google.com with SMTP id 128so5977654oih.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 04:10:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <29865def-991d-9e0c-131b-430a9c0a694f@nbd.name>
References: <20161103095938.84054-1-nbd@nbd.name> <CANUX_P0xv4a1O7tqBYABsXbRvRQm_3Va888EopKDz433cwjXew@mail.gmail.com>
 <CANUX_P1vktccTAQZOFRdVS9ndg4XEZNw0Ec=0sFL+n7SL2g+dQ@mail.gmail.com> <29865def-991d-9e0c-131b-430a9c0a694f@nbd.name>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 3 Nov 2016 13:10:11 +0200
Message-ID: <CANUX_P2h8Na3u4KERyEcQ81YTSL5Eww1VTst39et5ABcK07OQQ@mail.gmail.com> (sfid-20161103_121016_999538_2D404D8A)
Subject: Re: [PATCH] mac80211: fix broken AP mode handling of powersave clients
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 3, 2016 at 1:08 PM, Felix Fietkau <nbd@nbd.name> wrote:
> On 2016-11-03 11:51, Emmanuel Grumbach wrote:
>> On Thu, Nov 3, 2016 at 12:51 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> On Thu, Nov 3, 2016 at 11:59 AM, Felix Fietkau <nbd@nbd.name> wrote:
>>>> Commit c68df2e7be0c ("mac80211: allow using AP_LINK_PS with
>>>> mac80211-generated TIM IE") introduced a logic error, where
>>>> __sta_info_recalc_tim turns into a no-op if local->ops->set_tim is not
>>>> set. This prevents the beacon TIM bit from being set for all drivers
>>>> that do not implement this op (almost all of them), thus thoroughly
>>>> essential AP mode powersave functionality.
>>>>
>>>> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>>> Fixes: c68df2e7be0c ("mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE")
>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>> ---
>>>>  net/mac80211/sta_info.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>>>> index 236d47e..621734e 100644
>>>> --- a/net/mac80211/sta_info.c
>>>> +++ b/net/mac80211/sta_info.c
>>>> @@ -688,7 +688,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
>>>>         }
>>>>
>>>>         /* No need to do anything if the driver does all */
>>>> -       if (!local->ops->set_tim)
>>>> +       if (local->ops->set_tim)
>>>>                 return;
>>>
>>> but ... then, you'll need call to drv_set_tim below...
>>
>> s/need/never/
>>
>>> Apparently, we can't rely on the ops pointer to enter or not enter this flow.
> Are you going to submit a fix, or should I just send a revert of your
> commit?
>

Go ahead and send a revert. I won't be fast enough :)
