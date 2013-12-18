Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56734 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3LRASM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 19:18:12 -0500
Received: by mail-ve0-f181.google.com with SMTP id oy12so4892266veb.12
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 16:18:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHmEv86kWih+nub8BkxOZ3gJ8X5rfy7B2_BwRJH39MPJtJ+7ug@mail.gmail.com>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
 <1387142056-21850-2-git-send-email-twpedersen@gmail.com> <CAHNKnsTAJJBNT0nj8z-4mSAC_Gh1F6M7pdu3CGAMQ70+aALx4w@mail.gmail.com>
 <CAHmEv85q4c0FmvS+_kwQG9SfZgrokfYPNUvJmteKjdzxqnDvHw@mail.gmail.com>
 <CAHNKnsS-mT=fqwFEU82PQxeyAGaDLkEw8PpLm+83CfAbnSGy8w@mail.gmail.com> <CAHmEv86kWih+nub8BkxOZ3gJ8X5rfy7B2_BwRJH39MPJtJ+7ug@mail.gmail.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Wed, 18 Dec 2013 04:17:51 +0400
Message-ID: <CAHNKnsSbaCPBkdfu_xXxUWAQjJS5a=as2hwCvwT5aiScn54_5A@mail.gmail.com> (sfid-20131218_011815_871203_F9EB4D16)
Subject: Re: [PATCH 2/3] mac80211: reset TSF to 0 when joining a mesh
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/12/17 Thomas Pedersen <twpedersen@gmail.com>:
> On Mon, Dec 16, 2013 at 1:55 PM, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> 2013/12/16 Thomas Pedersen <twpedersen@gmail.com>:
>>> On Mon, Dec 16, 2013 at 4:33 AM, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>>> Hello Thomas,
>>>>
>>>> 2013/12/16 Thomas Pedersen <twpedersen@gmail.com>:
>>>>> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
>>>>> index 330d1f7..1174157 100644
>>>>> --- a/net/mac80211/mesh.c
>>>>> +++ b/net/mac80211/mesh.c
>>>>> @@ -802,6 +802,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>>>>>                 return -ENOMEM;
>>>>>         }
>>>>>
>>>>> +       /* next beacon will be DTIM-1, so TSF=0 was DTIM=0 */
>>>>> +       drv_set_tsf(local, sdata, 0);
>>>>>         ieee80211_bss_info_change_notify(sdata, changed);
>>>>>
>>>>>         netif_carrier_on(sdata->dev);
>>>>
>>>> What happen with AP interface on the same radio if we configure mesh
>>>> portal? Clients could be confused by such TSF jump.
>>>
>>> Like Johannes said; either the driver supports per-vif TSF, or well,
>>> it doesn't. Anyway wouldn't clients reset their own TSF when the new
>>> beacon is received?
>>>
>> Yeah, IEEE 802.11 says that stations must blindly use AP time, but it
>> says nothing about the situation when time is accidentally reset to
>> zero. I can't predict reaction of each chip/firmware/driver to such
>> situation.
>>
>> Another one unclear situation is the reaction of peers of mesh STA,
>> which share the same radio (and same TSF). If we silently reset its
>> time, what happens to the time synchronization with neighbors?
>
> Peer mesh STAs will notice an overly large TSF difference since last
> measurement, and reset Toffset to this new value.
>
Hm, I missed that. Thanks.

>> Why could not we calculate DTIM counter value on basis of known TSF
>> and Beacon/DTIM interval, instead of primitive time reset?
>
> Yeah this sounds like  a nicer solution. So drv_get_tsf() on mesh
> join, then calculate the right dtim_count? I'll give this a try.
>
I must confess that my question was inspired by Felix patch for ath9k
[1], which removes the TSF reset at each reconfiguration. Maybe we
could add the necessary functions to mac80211 or cfg80211 and all
drivers could benefit from that?

1. http://www.spinics.net/lists/linux-wireless/msg116087.html

-- 
BR,
Sergey
