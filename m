Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3GOMQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:16:04 -0400
Message-ID: <51E3E7F0.7050308@redhat.com> (sfid-20130715_141608_172902_EAE85E88)
Date: Mon, 15 Jul 2013 08:15:44 -0400
From: John Greene <jogreene@redhat.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linville@tuxdriver.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Further reduce log spam from tx phy messages
References: <1373640919-2685-1-git-send-email-jogreene@redhat.com> <1373652022.2614.13.camel@joe-AO722>
In-Reply-To: <1373652022.2614.13.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2013 02:00 PM, Joe Perches wrote:
> On Fri, 2013-07-12 at 10:55 -0400, John Greene wrote:
>> Relegate 2 phy messages to debug status as they create excessive
>> log spam, noted in multiple bugzillas for brcmsmac v3.8 and up.
>
> Hi John,
>
> Just trivia:
>
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> []
>> @@ -928,7 +928,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
> []
>> -			brcms_err(wlc->hw->d11core,
>> +			brcms_dbg_ht(wlc->hw->d11core,
>>   				  "%s: ampdu tx phy error (0x%x)\n",
>>   				  __func__, txs->phyerr);
>
> Please keep the indentation of the arguments of
> the same statement aligned to the open parenthesis.
>
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> []
>> @@ -882,7 +882,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
> []
>> -		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
>> +		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
>>   			  txs->phyerr, txh->MainRates);
>
> Here too.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks Joe. My oversight.  I wish the checkpatch flagged this stuff. 
I'll fix this and post v2.
-- 
John Greene

