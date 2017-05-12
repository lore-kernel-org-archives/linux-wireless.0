Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36659 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757307AbdELIhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 04:37:13 -0400
Received: by mail-pf0-f182.google.com with SMTP id m17so26836542pfg.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 01:37:13 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: btcoex: replace init_timer with setup_timer
To: Kalle Valo <kvalo@codeaurora.org>,
        Xie Qirong <cheerx1994@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170512073555.12333-1-cheerx1994@gmail.com>
 <87tw4qqyh1.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c5e21126-23e6-8cef-d01b-dc225dab1982@broadcom.com> (sfid-20170512_103732_929620_4D43A672)
Date: Fri, 12 May 2017 10:36:56 +0200
MIME-Version: 1.0
In-Reply-To: <87tw4qqyh1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/12/2017 10:19 AM, Kalle Valo wrote:
> Xie Qirong <cheerx1994@gmail.com> writes:
> 
>> The combination of init_timer and setting up the data and function field
>> manually is equivalent to calling setup_timer(). This is an api
>> consolidation only and improves readability.
>>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Xie Qirong <cheerx1994@gmail.com>
>> ---
>>
>>   setup_timer.cocci suggested the following improvement:
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:383:1-11: Use
>>   setup_timer function for function on line 384.
>>
>>   Patch was compile checked with: x86_64_defconfig + CONFIG_BRCMFMAC=y +
>>   CONFIG_BRCMFMAC_USB=y + CONFIG_BRCMFMAC_PCIE=y + CONFIG_BRCM_TRACING=y +
>>   CONFIG_BRCMDBG=y
>>
>>   Kernel version: 4.11.0 (localversion-next is next-20170512)
> 
> How is this different from the first version?
> 
> https://patchwork.kernel.org/patch/9709467/

Hi Kalle,

This is actually the third version. You are referring to the 
not-specifically-named "v2" here, but how are you to know ;-) This third 
version is the same as v1 on which I commented to put the coccinelle 
output in the commit message. So I would still keep v2 if nothing else 
changed in v3 apart from my Acked-by: tag.

Regards,
Arend

> Always add patch version "[PATCH v2]" and a changelog. I added a section
> "Frequent problems" to the wiki to mention about these common problems:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing
> 
