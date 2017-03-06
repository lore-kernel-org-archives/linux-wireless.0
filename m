Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34465 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752779AbdCFOuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 09:50:07 -0500
Received: by mail-ua0-f195.google.com with SMTP id 72so21899799uaf.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 06:50:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3626494c-8482-d003-1c83-e6171f6990a8@broadcom.com>
References: <CAMVG2stHA9qSUiRFBW=-4jhSMk-o7Frext+Qf9JK3Fo822XHhw@mail.gmail.com>
 <3626494c-8482-d003-1c83-e6171f6990a8@broadcom.com>
From: Daniel J Blueman <daniel@quora.org>
Date: Mon, 6 Mar 2017 22:50:05 +0800
Message-ID: <CAMVG2st=ZW-HhqQOMnDunjSJHj8Zw_K2+w2_8AVsHQePN3Ow9w@mail.gmail.com> (sfid-20170306_155024_062711_E0CD0C06)
Subject: Re: [PATCH] 4.9.13 brcmfmac: fix use-after-free on resume
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2017 at 21:00, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> + linux-wireless
>
> On 6-3-2017 8:14, Daniel J Blueman wrote:
>> KASAN reported 'struct wireless_dev wdev' was read after being freed.
>> Fix by freeing after the access.
>
> I would rather like to see the KASAN report, because something is off
> here. This function is called with wdev as a parameter so how can it be
> accessed after free here? brcmf_remove_interface() does not free the
> wdev nor the brcmf_cfg80211_vif instance which contains the wdev.
>
> Regards,
> Arend
>
>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> index de19c7c..aa0f470 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> @@ -2288,12 +2288,13 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy,
>> struct wireless_dev *wdev)
>>                 else
>>                         err = 0;
>>         }
>> -       brcmf_remove_interface(vif->ifp, true);
>>
>> -       brcmf_cfg80211_arm_vif_event(cfg, NULL);
>>         if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE)
>>                 p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
>>
>> +       brcmf_remove_interface(vif->ifp, true);
>> +       brcmf_cfg80211_arm_vif_event(cfg, NULL);
>> +
>>         return err;
>>  }

Sure, https://quora.org/kernel/brcmfmac/dmesg.txt

vmlinux, cfg80211.o, brcmfmac.o and config are in the same path; this
is against v4.9.13 stock.

Thanks,
  Daniel
-- 
Daniel J Blueman
