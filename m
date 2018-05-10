Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:48482 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeEJFfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 01:35:34 -0400
Subject: Re: [PATCH 15/30] staging: wilc1000: use kmemdup instead of kmalloc
 in add_network_to_shadow()
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-16-git-send-email-ajay.kathat@microchip.com>
 <e90398be-e387-1d5e-071f-b0863c249870@microchip.com>
 <20180510004731.64cd2d32@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <cc24355c-a3d9-cecc-923d-ace7d1aa4998@microchip.com> (sfid-20180510_073548_507505_60ADC93B)
Date: Thu, 10 May 2018 08:35:29 +0300
MIME-Version: 1.0
In-Reply-To: <20180510004731.64cd2d32@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09.05.2018 22:17, Ajay Singh wrote:
> On Wed, 9 May 2018 16:42:59 +0300
> Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> 
>> On 07.05.2018 11:43, Ajay Singh wrote:
>>> Use kmemdup instead of kmalloc & memcpy in add_network_to_shadow().
>>>
>>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
>>> ---
>>>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
>>> 0ae2065..ca221f1 100644 ---
>>> a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
>>> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -331,8
>>> +331,8 @@ static void add_network_to_shadow(struct network_info
>>> *nw_info, shadow_nw_info->tsf_hi = nw_info->tsf_hi; if (ap_found !=
>>> -1) kfree(shadow_nw_info->ies);
>>> -	shadow_nw_info->ies = kmalloc(nw_info->ies_len,
>>> GFP_KERNEL);
>>> -	memcpy(shadow_nw_info->ies, nw_info->ies,
>>> nw_info->ies_len);
>>> +	shadow_nw_info->ies = kmemdup(nw_info->ies,
>>> nw_info->ies_len,
>>> +				      GFP_KERNEL);  
>>
>> Maybe, in case of NULL, you will want to set ies_len = 0 ?
> 
> 
> I couldn't find code where 'ies_len' is check to validity of data.
> Mostly we use NULL check for "ies" pointer for data
> validity.So in my opinion setting it to zero would be
> irrelevant.

I'm seeing this in refresh_scan():
                network_info = &last_scanned_shadow[i];                         
                                                                                
                if (!memcmp("DIRECT-", network_info->ssid, 7) && !direct_scan)  
                        continue;                                               
                                                                                
                freq = ieee80211_channel_to_frequency((s32)network_info->ch,    
                                                      NL80211_BAND_2GHZ);       
                channel = ieee80211_get_channel(wiphy, freq);                   
                rssi = get_rssi_avg(network_info);                              
                bss = cfg80211_inform_bss(wiphy,                                
                                          channel,                              
                                          CFG80211_BSS_FTYPE_UNKNOWN,           
                                          network_info->bssid,                  
                                          network_info->tsf_hi,                 
                                          network_info->cap_info,               
                                          network_info->beacon_period,          
                                          (const u8 *)network_info->ies,        
                                          (size_t)network_info->ies_len,        
                                          (s32)rssi * 100,                      
                                          GFP_KERNEL);                          

Looking further into cfg80211_inform_bss():
	-> cfg80211_inform_bss_data()
	-> cfg80211_get_bss_channel()
	-> cfg80211_find_ie()
	-> cfg80211_find_ie_match():
        while (len >= 2 && len >= ies[1] + 2) {                                 
                if ((ies[0] == eid) &&                                          
                    (ies[1] + 2 >= match_offset + match_len) &&                 
                    !memcmp(ies + match_offset, match, match_len))              
                        return ies;                                             
                                                                                
                len -= ies[1] + 2;                                              
                ies += ies[1] + 2;                                              
        }                                                                       


> 
> 
>>
>>>  	shadow_nw_info->time_scan = jiffies;
>>>  	shadow_nw_info->time_scan_cached = jiffies;
>>>  	shadow_nw_info->found = 1;
>>>   
> 
> 
> Regards,
> Ajay
> 
> 
