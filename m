Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38822 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2D3HzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 03:55:05 -0400
Received: by vbbff1 with SMTP id ff1so1868579vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 00:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0aozz7v9imbrTKZP0j69uDehqV2s-SwgjRZjc2TULQnw@mail.gmail.com>
References: <CANUX_P2r9ifuj6fVmkfgfX21PMa1Cf_NpYXXup1YVdRLX+bH6w@mail.gmail.com>
	<CAD2nsn0fHAJB++DfA5M1xW32rHDV2jAFuwqJ_bVdLqyEz=pRAQ@mail.gmail.com>
	<CANUX_P0aozz7v9imbrTKZP0j69uDehqV2s-SwgjRZjc2TULQnw@mail.gmail.com>
Date: Mon, 30 Apr 2012 13:25:03 +0530
Message-ID: <CAD2nsn3e5CpyXMendM1vR7iBo2DCtHQsk_iEFjXzc3v2ks871g@mail.gmail.com> (sfid-20120430_095511_219281_15D4F487)
Subject: Re: bss table corruption
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2012 at 1:07 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Apr 30, 2012 at 10:30, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>> Hi Emmanuel,
>>
>> On Mon, Apr 30, 2012 at 10:58 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> For quite a while now (not sure I can tell exactly for how long) we
>>> see issues in association and scan list.
>>> We send probe before authentication, get the probe response but never
>>> send the authentication.
>>> Moreover a lot of entries in the BSS list are duplicated.
>>>
>>> I began to look at it and ended up to understand that these 2 issues
>>> are related: we just can't find an existing BSS in the BSS table.
>>> Obviously this causes the second issue. The reason was it breaks the
>>> association is that ieee80211_probe_auth will never be able to find
>>> the IEs of the probe response since we couldn't fetch the BSS when we
>>> parsed the probe response. In short:
>>>
>>>        if (auth_data->bss->proberesp_ies) {
>>> always return false.... and we fall back to send yet another probe request.
>>>
>>> As you probably know, the BSS table is implemented with an Red Black
>>> Tree which requires its elements to be comparable. The compare
>>> function compares the BSSID which is not always unique (there can be
>>> several SSIDs on the same BSSID), so all the IEs are also compared.
>>> But is this a good idea ?
>>> It seems that since the IEs of an BSS may change from time to time
>>> this compare function is not consistent...
>>>
>>> Just for playing I always return a positive value in cmp_bss (to have
>>> all the nodes serialized and avoid the possibility to miss a existing
>>> node) and don't rebalance the tree after insertion... the bug
>>> disappeared.
>>>
>>> Thought ?
>>>
>>> Emmanuel Grumbach
>>> egrumbach@gmail.com
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> we are comparing the BSSID of the new entry with the old entry (ie) we
>> would return positive (with your latest fix)
>> if the BSSID of the new entry > BSSID of the old entry, should not we
>> do the same for comparing frequency, ie length and
>> ie content.
>> just got a doubt if this is by design we have things like this.
>>
>>
>
> Frankly I didn't think about this :-), but I think the current
> behavior is correct even if it is not intuitive. All we need a
> consistent comparison operator. But I don't mind folding you
> suggestion retest and resubmit.

when i submitted the RFC internally Jouni was commenting whether this
fixes something.
i could not find one. thanks for your comments!


>
>> net/wireless/scan.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
>> index 70faadf..fda4eef 100644
>> --- a/net/wireless/scan.c
>> +++ b/net/wireless/scan.c
>> @@ -271,7 +271,7 @@ static int cmp_ies(u8 num, u8 *ies1, size_t len1,
>> u8 *ies2, size_t len2)
>>
>>      /* sort by length first, then by contents */
>>      if (ie1[1] != ie2[1])
>> -        return ie2[1] - ie1[1];
>> +        return ie1[1] - ie2[1];
>>      return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
>>  }
>>
>> @@ -361,7 +361,7 @@ static int cmp_bss_core(struct cfg80211_bss *a,
>>      int r;
>>
>>      if (a->channel != b->channel)
>> -        return b->channel->center_freq - a->channel->center_freq;
>> +        return a->channel->center_freq - b->channel->center_freq;
>>
>>      if (is_mesh_bss(a)&&  is_mesh_bss(b)) {
>>          r = cmp_ies(WLAN_EID_MESH_ID,
>> @@ -433,7 +433,7 @@ static int cmp_hidden_bss(struct cfg80211_bss *a,
>>
>>      /* sort by length first, then by contents */
>>      if (ie1[1] != ie2[1])
>> -        return ie2[1] - ie1[1];
>> +        return ie1[1] - ie2[1];
>>
>>      /* zeroed SSID ie is another indication of a hidden bss */
>>      for (i = 0; i<  ie2[1]; i++)
>>
>>
>> --
>> thanks,
>> shafi



-- 
thanks,
shafi
