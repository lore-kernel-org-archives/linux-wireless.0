Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30584 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbcAAHFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 02:05:35 -0500
Message-ID: <5686253C.4060305@broadcom.com> (sfid-20160101_080610_556821_31782E61)
Date: Fri, 1 Jan 2016 08:05:32 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Mathy Vanhoef <vanhoefm@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] brcmfmac: obtain feature info using 'cap' firmware
 command
References: <1450100394-17414-1-git-send-email-arend@broadcom.com> <1450100394-17414-5-git-send-email-arend@broadcom.com> <CAFXAJYwpk+-U-9pN2tnOmK05gixJZWYGi9_w+r9uktH2PqvEUQ@mail.gmail.com>
In-Reply-To: <CAFXAJYwpk+-U-9pN2tnOmK05gixJZWYGi9_w+r9uktH2PqvEUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2015 09:58 PM, Mathy Vanhoef wrote:
> On Mon, Dec 14, 2015 at 2:39 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> Several features in the driver directly map to a firmware feature
>> listed in response of the 'cap' firmware command. For those features
>> this response will be examined instead of attempting individual
>> firmware commands.
>>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>

Hi Mathy,

Do you want credits, ie. have "Reviewed-by:" tag added?

Regards,
Arend

>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 51 +++++++++++++---------
>>   1 file changed, 30 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> index d9d1ca4..08b7200 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> @@ -40,6 +40,17 @@ static const char *brcmf_feat_names[] = {
>>   };
>>   #undef BRCMF_FEAT_DEF
>>
>> +struct brcmf_feat_fwcap {
>> +       enum brcmf_feat_id feature;
>> +       const char * const fwcap_id;
>> +};
>> +
>> +static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
>> +       { BRCMF_FEAT_MBSS, "mbss" },
>> +       { BRCMF_FEAT_MCHAN, "mchan" },
>> +       { BRCMF_FEAT_P2P, "p2p" },
>> +};
>> +
>>   #ifdef DEBUG
>>   /*
>>    * expand quirk list to array of quirk strings.
>> @@ -104,25 +115,22 @@ static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
>>          }
>>   }
>>
>> -/**
>> - * brcmf_feat_iovar_int_set() - determine feature through iovar set.
>> - *
>> - * @ifp: interface to query.
>> - * @id: feature id.
>> - * @name: iovar name.
>> - */
>> -static void brcmf_feat_iovar_int_set(struct brcmf_if *ifp,
>> -                                    enum brcmf_feat_id id, char *name, u32 val)
>> +static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
>>   {
>> -       int err;
>> -
>> -       err = brcmf_fil_iovar_int_set(ifp, name, val);
>> -       if (err == 0) {
>> -               brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
>> -               ifp->drvr->feat_flags |= BIT(id);
>> -       } else {
>> -               brcmf_dbg(TRACE, "%s feature check failed: %d\n",
>> -                         brcmf_feat_names[id], err);
>> +       char caps[256];
>> +       enum brcmf_feat_id id;
>> +       int i;
>> +
>> +       brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
>> +       brcmf_dbg(INFO, "[ %s]\n", caps);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(brcmf_fwcap_map); i++) {
>> +               if (strnstr(caps, brcmf_fwcap_map[i].fwcap_id, sizeof(caps))) {
>> +                       id = brcmf_fwcap_map[i].feature;
>> +                       brcmf_dbg(INFO, "enabling feature: %s\n",
>> +                                 brcmf_feat_names[id]);
>> +                       ifp->drvr->feat_flags |= BIT(id);
>> +               }
>>          }
>>   }
>>
>> @@ -130,13 +138,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>   {
>>          struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
>>
>> -       brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
>> +       brcmf_feat_firmware_capabilities(ifp);
>> +
>>          brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
>>          if (drvr->bus_if->wowl_supported)
>>                  brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
>> +       /* MBSS does not work for 43362 */
>>          if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
>> -               brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
>> -       brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
>> +               ifp->drvr->feat_flags &= BIT(BRCMF_FEAT_MBSS);
>
> Missing ~ before the BIT() declaration? If the if-test fails, all bits are
> cleared except BRCMF_FEAT_MBSS. I think the if-test also needs to be updated
> to an equals `==` instead of the old inequality. So one would get:
>
> /* clear MBSS feature for the 43362 (does not work) */
> if (drvr->bus_if->chip == BRCM_CC_43362_CHIP_ID)
>      ifp->drvr->feat_flags &= ~BIT(BRCMF_FEAT_MBSS);
>
> Also, happy holidays!
> Mathy
>
>>          brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
>>          brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_TDLS, "tdls_enable");
>>
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

