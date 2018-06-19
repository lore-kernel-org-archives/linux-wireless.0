Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:52791 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937215AbeFSKtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 06:49:20 -0400
Received: by mail-wm0-f51.google.com with SMTP id p126-v6so19156579wmb.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 03:49:19 -0700 (PDT)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
 <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com>
 <5B1E537F.2080502@broadcom.com>
 <CACna6rxa4+UEOs1FjQUGnHpFJn4n_TO6v=Vx3SqNA32QvzQEGQ@mail.gmail.com>
 <5B28B68F.8070505@broadcom.com>
 <a0eff73c-cccf-5226-992f-2a892cee5c57@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B28DFAC.90400@broadcom.com> (sfid-20180619_124924_908293_D15900F2)
Date: Tue, 19 Jun 2018 12:49:16 +0200
MIME-Version: 1.0
In-Reply-To: <a0eff73c-cccf-5226-992f-2a892cee5c57@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 10:32 AM, Rafał Miłecki wrote:
> On 19.06.2018 09:53, Arend van Spriel wrote:
>> On 6/19/2018 9:27 AM, Rafał Miłecki wrote:
>>> On Mon, 11 Jun 2018 at 12:48, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>> On 5/30/2018 1:52 PM, Rafał Miłecki wrote:
>>>>> I'm providing extra version info of tested firmware images as
>>>>> requested
>>>>> by Arend in another e-mail thread.
>>>>
>>>> Looking into our firmware repo it there are two flags, ie. WL_MONITOR
>>>> and WL_RADIOTAP. It seems both are set for firmware containing -stamon-
>>>> feature. Your list below confirms that. I still plan to add indication
>>>> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check could be
>>>> used for older firmwares.
>>>
>>> I just checked wl.mk (it's an open source file) and found following
>>> line:
>>> WLFILES_SRC_HI += src/wl/sys/wlc_stamon.c
>>> not guarded by any ifeq.
>>
>> wl.mk is used for NIC driver (softmac) so it is not used for fullmac
>> firmware.
>
> Weird. I see a few rte references in wl.mk which suggests it's used for
> both (softmac & fullmac firmware).

yeah. my mistake.

>>> It appears wlc_stamon.c is always being compiled in. Are you 100% sure
>>> that wlc_stamon.c depends & uses radiotap? Are you sure it's
>>> impossible to include stamon support without radiotap support?
>>>
>>> I'm asking because we're going to check "sta_monitor" iovar to find
>>> out if radiotap support is included. I'd like to be sure it's 100%
>>> reliable.
>>
>> I have already created a patch for this (see below). I will submit it
>> this week.
>
> Just to be clear could you also answer my above question, please?
>
> Did you check if it's impossible to build firmware *with* stamon.c (and
> sta_monitor iovar) and *without WL_RADIOTAP?

Yes. The functions in stamon.c, most importantly wlc_stamon_attach, are 
only invoked in firmware when WL_STA_MONITOR is defined.

>> diff --git
>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> index f70fec6..67d7fc7 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> @@ -207,6 +207,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>       struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
>>       struct brcmf_pno_macaddr_le pfn_mac;
>>       struct brcmf_gscan_config gscan_cfg;
>> +    struct brcmf_stamon_sta_config stamon_cfg;
>>       u32 wowl_cap;
>>       s32 err;
>>
>> @@ -217,6 +218,20 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>           brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
>>                         "pfn_gscan_cfg",
>>                         &gscan_cfg, sizeof(gscan_cfg));
>> +
>> +    if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR) ||
>> +        !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RADIOTAP)) {
>> +        ifp->fwil_fwerr = true;
>> +        memset(&stamon_cfg, 0, sizeof(stamon_cfg));
>> +        /* iovar requires IOVF_SET_UP so this fails either way */
>> +        err = brcmf_fil_iovar_data_set(ifp, "sta_monitor", &stamon_cfg,
>> +                           sizeof(stamon_cfg));
>
> I think it may be simpler (and maybe less invasive) to use
> brcmf_fil_iovar_data_get.

Thanks for the comment, but looking at the firmware I can not concur. In 
the get-path there is yet another compile flag that requires different 
query for different firmwares. For the set there is a prerequisite that 
the firmware stack is up and we know it is not upon executing 
brcmf_feat_attach() so it fails before entering the specific iovar 
handler in firmware.

Regards,
Arend
