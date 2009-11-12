Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:61925 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbZKLWlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:41:14 -0500
Message-ID: <4AFC8F0D.5020700@irobot.com>
Date: Thu, 12 Nov 2009 14:41:17 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com> <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz> <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com> <4AFC8E4F.5090307@irobot.com>
In-Reply-To: <4AFC8E4F.5090307@irobot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whoops, patch was slightly incorrect.  This is better:

*** compat-wireless-2009-11-09/net/mac80211/ibss.c    2009-11-08 
21:15:06.000000000 -0800
--- compat-wireless-2009-11-09b/net/mac80211/ibss.c    2009-11-12 
14:39:12.391545084 -0800
***************
*** 246,254 ****
      if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
          return;
 
      if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
-         supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
          rcu_read_lock();
 
--- 246,258 ----
      if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
          return;
 
+     supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+     /* make sure mandatory rates are always added */
+     supp_rates = supp_rates |= ieee80211_mandatory_rates(local, band);
+
      if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
 
          rcu_read_lock();
 
***************
*** 257,268 ****
              u32 prev_rates;
 
              prev_rates = sta->sta.supp_rates[band];
!             /* make sure mandatory rates are always added */
!             sta->sta.supp_rates[band] = supp_rates |
!                 ieee80211_mandatory_rates(local, band);
 
  #ifdef CONFIG_MAC80211_IBSS_DEBUG
-             if (sta->sta.supp_rates[band] != prev_rates)
                  printk(KERN_DEBUG "%s: updated supp_rates set "
                      "for %pM based on beacon info (0x%llx | "
                      "0x%llx -> 0x%llx)\n",
--- 261,270 ----
              u32 prev_rates;
 
              prev_rates = sta->sta.supp_rates[band];
!             sta->sta.supp_rates[band] = supp_rates;
 
+             if (sta->sta.supp_rates[band] != prev_rates) {
  #ifdef CONFIG_MAC80211_IBSS_DEBUG
                  printk(KERN_DEBUG "%s: updated supp_rates set "
                      "for %pM based on beacon info (0x%llx | "
                      "0x%llx -> 0x%llx)\n",
***************
*** 272,277 ****
--- 274,285 ----
                      (unsigned long long) supp_rates,
                      (unsigned long long) sta->sta.supp_rates[band]);
  #endif
+
+                 /* TODO: implement rate_update in minstrel/pid,
+                  * then change this to rate_control_rate_update.
+                  */
+                 rate_control_rate_init(sta);
+             }
          } else
              ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 
supp_rates);
 



Adam Wozniak wrote:
> I see what you're doing there.  That didn't quite work, but I'm fairly 
> confident this one will.  I'm running my long term test now.  Note the 
> added call to rate_control_init() when the rate is updated.  This 
> *should* be rate_control_rate_update, but it doesn't look to me like 
> that method is implemented in minstrel or the PID code.
>
> *** compat-wireless-2009-11-09/net/mac80211/ibss.c    2009-11-08 
> 21:15:06.000000000 -0800
> --- compat-wireless-2009-11-09b/net/mac80211/ibss.c    2009-11-12 
> 14:29:16.308550923 -0800
> ***************
> *** 246,254 ****
>      if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>          return;
>
>      if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
> -         supp_rates = ieee80211_sta_get_rates(local, elems, band);
>
>          rcu_read_lock();
>
> --- 246,258 ----
>      if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>          return;
>
> +     supp_rates = ieee80211_sta_get_rates(local, elems, band);
> +
> +     /* make sure mandatory rates are always added */
> +     supp_rates = supp_rates |= ieee80211_mandatory_rates(local, band);
> +
>      if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
>
>          rcu_read_lock();
>
> ***************
> *** 257,268 ****
>              u32 prev_rates;
>
>              prev_rates = sta->sta.supp_rates[band];
> !             /* make sure mandatory rates are always added */
> !             sta->sta.supp_rates[band] = supp_rates |
> !                 ieee80211_mandatory_rates(local, band);
>
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> !             if (sta->sta.supp_rates[band] != prev_rates)
>                  printk(KERN_DEBUG "%s: updated supp_rates set "
>                      "for %pM based on beacon info (0x%llx | "
>                      "0x%llx -> 0x%llx)\n",
> --- 261,270 ----
>              u32 prev_rates;
>
>              prev_rates = sta->sta.supp_rates[band];
> !             sta->sta.supp_rates[band] = supp_rates;
>
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> !             if (sta->sta.supp_rates[band] != prev_rates) {
>                  printk(KERN_DEBUG "%s: updated supp_rates set "
>                      "for %pM based on beacon info (0x%llx | "
>                      "0x%llx -> 0x%llx)\n",
> ***************
> *** 271,276 ****
> --- 273,284 ----
>                      (unsigned long long) prev_rates,
>                      (unsigned long long) supp_rates,
>                      (unsigned long long) sta->sta.supp_rates[band]);
> +
> +                 /* TODO: implement rate_update in minstrel/pid,
> +                  * then change this to rate_control_rate_update.
> +                  */
> +                 rate_control_rate_init(sta);
> +             }
>  #endif
>          } else
>              ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 
> supp_rates);
>
>
>
> Christian Lamparter wrote:
>> On Thursday 12 November 2009 20:43:22 Adam Wozniak wrote:
>>  
>>> I was hoping for more of an "ah-ha!" response. =)
>>>
>>> It worked well initially, but when I let it run overnight it fell 
>>> back into that same failure mode.
>>>
>>>     
>>
>> great... :\
>>
>> what about this patch?
>> ---
>> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> index fbffce9..bde89f7 100644
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -250,6 +250,9 @@ static void ieee80211_rx_bss_info(struct 
>> ieee80211_sub_if_data *sdata,
>>          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
>>          supp_rates = ieee80211_sta_get_rates(local, elems, band);
>>  
>> +        /* make sure mandatory rates are always added */
>> +        supp_rates |= ieee80211_mandatory_rates(local, band);
>> +
>>          rcu_read_lock();
>>  
>>          sta = sta_info_get(local, mgmt->sa);
>> @@ -257,9 +260,7 @@ static void ieee80211_rx_bss_info(struct 
>> ieee80211_sub_if_data *sdata,
>>              u32 prev_rates;
>>  
>>              prev_rates = sta->sta.supp_rates[band];
>> -            /* make sure mandatory rates are always added */
>> -            sta->sta.supp_rates[band] = supp_rates |
>> -                ieee80211_mandatory_rates(local, band);
>> +            sta->sta.supp_rates[band] = supp_rates;
>>  
>>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>>              if (sta->sta.supp_rates[band] != prev_rates)
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

