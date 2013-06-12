Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60296 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3FLNqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 09:46:46 -0400
Message-ID: <51B87BBD.9050905@hauke-m.de> (sfid-20130612_154649_574123_6C057AE4)
Date: Wed, 12 Jun 2013 15:46:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 03/15] brcmsmac: remove brcms_bss_cfg->BSS
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de> <1364085963-25940-4-git-send-email-hauke@hauke-m.de> <51B07B23.1090205@broadcom.com>
In-Reply-To: <51B07B23.1090205@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2013 02:05 PM, Arend van Spriel wrote:
> On 03/24/2013 01:45 AM, Hauke Mehrtens wrote:
>> This was a read only member. The checks using BSS are replaced by
>> better fitting checks of the new type member.
>>
>> The change in brcms_c_tbtt() was based on code from b43, in
>> brcms_c_ps_allowed() the same happens with BSS being true or false,
>> beaconing and probe responses are just needed in ap mode.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>   drivers/net/wireless/brcm80211/brcmsmac/main.c |   23
>> +++++++++--------------
>>   drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
>>   2 files changed, 9 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> index 4e420ea..90e6c0d 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> @@ -1069,7 +1069,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw,
>> bool bound, bool *fatal)
>>
>>   static void brcms_c_tbtt(struct brcms_c_info *wlc)
>>   {
>> -    if (!wlc->bsscfg->BSS)
>> +    if (wlc->bsscfg->type == BRCMS_TYPE_ADHOC)
>>           /*
>>            * DirFrmQ is now valid...defer setting until end
>>            * of ATIM window
> 
> Hi Hauke,
> 
> Sorry for such a late comment. It seem that the above change is
> incosistent with the changes below. You probably need to change it.

Yes there is something wrong. I got confused with b43 which sets
wlc->qvalid |= MCMD_DIRFRMQVAL; only in adhoc mode and not in ap mode.

I will create a patch and test this.

>> @@ -7386,7 +7379,8 @@ void brcms_c_update_beacon(struct brcms_c_info
>> *wlc)
>>   {
>>       struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
>>
>> -    if (bsscfg->up && !bsscfg->BSS)
>> +    if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
>> +               bsscfg->type == BRCMS_TYPE_ADHOC))
>>           /* Clear the soft intmask */
>>           wlc->defmacintmask &= ~MI_BCNTPL;
>>   }
>> @@ -7461,7 +7455,8 @@ void brcms_c_update_probe_resp(struct
>> brcms_c_info *wlc, bool suspend)
>>       struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
>>
>>       /* update AP or IBSS probe responses */
>> -    if (bsscfg->up && !bsscfg->BSS)
>> +    if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
>> +               bsscfg->type == BRCMS_TYPE_ADHOC))
>>           brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
>>   }
>>
> 
> 

