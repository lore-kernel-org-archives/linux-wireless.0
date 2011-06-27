Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1F0Urw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 16:47:52 -0400
Received: by iwn6 with SMTP id 6so4411962iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 13:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309178198.3911.11.camel@jlt3.sipsolutions.net>
References: <1309073538-24071-1-git-send-email-arik@wizery.com> <1309178198.3911.11.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 27 Jun 2011 23:47:36 +0300
Message-ID: <BANLkTi=jR7BC52OZH6N0cNZyHbcGrFaKEQ@mail.gmail.com> (sfid-20110627_225207_732294_DE2718A8)
Subject: Re: [PATCH v2 1/2] mac80211: propagate information about STA WME
 support down
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2011 at 15:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> I wonder, would it make sense to _move_ the flag instead of trying to
> keep it twice? Since the flag shouldn't ever change that could even
> remove some locking around it in some hotpaths...

I'm not sure, but I haven't seen any atomic operations on this flag in a tx/rx.

>
>> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> index 421eaa6..efa1d86 100644
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -310,11 +310,14 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>>                       } else
>>                               sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
>>                                               mgmt->sa, supp_rates,
>> +                                             elems->wmm_info != NULL,
>>                                               GFP_ATOMIC);
>>               }
>>
>> -             if (sta && elems->wmm_info)
>> +             if (sta && elems->wmm_info) {
>>                       set_sta_flags(sta, WLAN_STA_WME);
>> +                     sta->sta.wme = true;
>> +             }
>
> This seems duplicate now that you're passing it into ibss_add_sta().

Not really, the ibss_add_sta is not always called in the above code path.

>
> However, it's currently sort of necessary to keep it correct:
>
>> @@ -2652,7 +2652,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
>>                       else
>>                               rate_idx = status->rate_idx;
>>                       rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
>> -                                     hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
>> +                                     hdr->addr2, BIT(rate_idx), false,
>> +                                     GFP_ATOMIC);
>>               }
>>               break;
>>       case NL80211_IFTYPE_MESH_POINT:
>
> since you're not parsing anything here. Which also seems strange, at
> least you could check if it was a QoS frame?
>
> In any case, it seems to me that the driver needs to know the WME flag
> while adding the station, not only at some arbitrary point later, which
> doesn't happen here.

I admit it was a halfhearted attempt to introduce the flag. But
pre-parsing the packet here seemed ugly to me.

>
> Maybe you should make the flag be AP-mode only after all :-)
>

Yea I guess there's no use adding (fairly trivial) code that's not
really used by anyone.

Arik
