Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:11585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYIHIzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:55:42 -0400
Received: by ug-out-1314.google.com with SMTP id s2so224220uge.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 01:55:39 -0700 (PDT)
Message-ID: <1ba2fa240809080155m48910922sae4f45ab0d7b3888@mail.gmail.com> (sfid-20080908_105545_678087_FFDE0E87)
Date: Mon, 8 Sep 2008 11:55:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220862200.31304.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220862200.31304.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 11:23 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
>
>> @@ -1104,16 +1133,12 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
>>
>>       rcu_read_unlock();
>>
>> -     if (disassoc && sta)
>> -             sta_info_destroy(sta);
>> -
>> -     if (disassoc) {
>> -             ifsta->state = IEEE80211_STA_MLME_DISABLED;
>> -             ieee80211_set_associated(sdata, ifsta, 0);
>> -     } else {
>> +     if (disassoc)
>> +             ieee80211_set_disassoc(sdata, ifsta, 1, 1,
>> +                                     WLAN_REASON_PREV_AUTH_NOT_VALID);
>> +     else
>>               mod_timer(&ifsta->timer, jiffies +
>>                                     IEEE80211_MONITORING_INTERVAL);
>> -     }
>>  }
>>
>>
>
> This hunk has another bug, or rather, we need to add this hunk:
>
> @@ -1084,7 +1114,6 @@ static void ieee80211_associated(struct
>                                       "range\n",
>                                       sdata->dev->name, print_mac(mac, ifsta->bssid));
>                                disassoc = 1;
> -                               sta_info_unlink(&sta);
>                        } else
>                                ieee80211_send_probe_req(sdata, ifsta->bssid,
>                                                         local->scan_ssid,
>
Yep
This is rebasing bug. This line is newer than the original patch.
I will added this hunk.
Thanks
