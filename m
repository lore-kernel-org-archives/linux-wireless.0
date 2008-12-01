Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:49393 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYLAPIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:08:36 -0500
Received: by ik-out-1112.google.com with SMTP id c29so2050069ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 07:08:34 -0800 (PST)
Message-ID: <8e92b4100812010708r78aab0fdt9cb101df97fcc29@mail.gmail.com> (sfid-20081201_160840_488484_1DB8EC77)
Date: Mon, 1 Dec 2008 20:38:33 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Cc: "Vivek Natarajan" <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, "Kalle Valo" <kalle.valo@nokia.com>
In-Reply-To: <1228132431.3478.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 <1228132431.3478.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Johannes Berg <johannes@sipsolutions.net> wrote:

>> +     if (index < indexn1 || index > indexn2)
>> +             return false;
>> +
>> +     index -= indexn1;
>> +
>> +     if (tim->bitmap_ctrl & 0x01)
>> +             *is_mc = true;
>
> Shouldn't you update *is_mc before the above return false? And also set
> it to false in the other case, I think.

Yes, you are right.Thanks.

>> +     return (bool)(tim->virtual_map[index] & mask);
>
> I think
>        return !!(... & mask);
> would be more appropriate.

Thanks. I will modify it.

>> @@ -1734,6 +1759,15 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>>       ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
>>                                elems.wmm_param_len);
>>
>> +     directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
>> +
>> +     if (directed_tim || is_mc) {
>> +             if (local->hw.conf.flags && IEEE80211_CONF_PS) {
>> +                     local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>> +                     ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>> +                     ieee80211_send_nullfunc(local, sdata, 0);
>> +             }
>> +     }
>
> How will we get back into PS mode after

Once we send a null frame with pm bit off and CONF_PS changed,
the tx_idle timer kicks in and we once again move to sleep state
after the timeout. That piece of code is already there in Kalle's patch.

> One thing I forgot, do we need a special iwlwifi flag to turn this off?

Kalle added a flag 'IEEE80211_HW_NO_DYNAMIC_PS' in v3 RFC.
May be, it can be used for iwlwifi to use its own power save and
null frames as it does now instead of using from mac80211.
We can check this flag and then change CONF_PS wherever it is used.

Thanks,
Vivek.
