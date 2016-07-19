Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36276 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbcGSQmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 12:42:14 -0400
Received: by mail-pf0-f195.google.com with SMTP id y134so1683657pfg.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 09:42:14 -0700 (PDT)
Subject: Re: [PATCH 3/4] brcmsmac: Fix invalid memcpy() size in
 brcms_c_d11hdrs_mac80211
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <1468884277-18606-4-git-send-email-f.fainelli@gmail.com>
 <685abc5d-2e3d-cdce-4849-f7e5beb3309d@broadcom.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <578E5864.3040309@gmail.com> (sfid-20160719_184218_083865_6877485A)
Date: Tue, 19 Jul 2016 09:42:12 -0700
MIME-Version: 1.0
In-Reply-To: <685abc5d-2e3d-cdce-4849-f7e5beb3309d@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2016 03:38 AM, Arend Van Spriel wrote:
> On 19-7-2016 1:24, Florian Fainelli wrote:
>> struct ieee80211_rts::ra is only ETH_ALEN wide, yet we attempt to copy 2
>> * ETH_ALEN, which will potentially overrun the destination buffer.
> 
> NACK - this is intentional. Have to admit it is a bit of trickery.

This seems fragile, if there is any kind of re-ordering of fields within
that structure your trick breaks apart.

> struct ieee80211_rts is mapped over struct d11txh which is sent to
> hardware. The struct is used for both RTS and CTS. Transmitting CTS will
> only fill 802.11 addr2 in struct ieee80211_rts::ra. Transmitting RTS
> fills 802.11 addr1 in ra and 802.11 addr2 in ta using single memcpy().
> Not very clear, but your change is not the way to go here.

Fair enough, as Kalle suggested, this deserves a comment explaining why,
I would not be surprised other people would trip over that.

> 
> Regards,
> Arend
> 
>> Reported-by: coverity (CID 145657)
>> Fixes: 5b435de0d7868 ("net: wireless: add brcm80211 drivers")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
>> index c2a938b59044..59813a3666eb 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
>> @@ -6671,7 +6671,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
>>  			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
>>  							 IEEE80211_STYPE_RTS);
>>  
>> -			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
>> +			memcpy(&rts->ra, &h->addr1, ETH_ALEN);
>>  		}
>>  
>>  		/* mainrate
>>


-- 
Florian
