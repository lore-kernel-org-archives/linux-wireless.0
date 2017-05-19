Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35188 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdESHuL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 03:50:11 -0400
Received: by mail-qk0-f181.google.com with SMTP id a72so54812818qkj.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 00:50:05 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: remove setting IBSS mode when stopping AP
To: Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <wright.feng@cypress.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
References: <1495099339-7626-1-git-send-email-wright.feng@cypress.com>
 <87efvla1s9.fsf@codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2dd93d16-e793-9d71-b36d-ac2592b060ea@broadcom.com> (sfid-20170519_095041_692167_6C6FDB36)
Date: Fri, 19 May 2017 09:49:52 +0200
MIME-Version: 1.0
In-Reply-To: <87efvla1s9.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/19/2017 6:49 AM, Kalle Valo wrote:
> Wright Feng <wright.feng@cypress.com> writes:
> 
>> From: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
>>
>> Setting IBSS mode when stopping AP may affect functionality of INFRA
>> mode on another interface. For instance, if user creates and stops
>> hostap daemon on virtual interface, then association cannot work on
>> primary interface because default BSS has been set to IBSS mode in
>> firmware side. The IBSS mode should be set when cfg80211 changes the
>> interface.
>>
>> Reviewed-by: Wright Feng <wright.feng@cypress.com>
>> Signed-off-by: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 944b83c..ce2a5b6 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -4658,9 +4658,6 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
>>   		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
>>   		if (err < 0)
>>   			brcmf_err("setting AP mode failed %d\n", err);
>> -		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
>> -		if (err < 0)
>> -			brcmf_err("setting INFRA mode failed %d\n", err);
> 
> The title talks about setting IBSS mode but the code looks to be about
> setting INFRA mode. Is this correct?

Both are correct :-p Have to admit this is confusing. The command 
SET_INFRA with zero value means "disable INFRA; thus enable IBSS".

I would rephrase the commit message indeed explaining what the code 
currently does, ie.:

Upon stopping an AP interface the driver disable INFRA mode effectively 
setting the interface in IBSS mode. However, this may affect other 
interfaces running in INFRA mode. For instance, ....

Regards,
Arend
