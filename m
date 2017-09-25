Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:54266 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932817AbdIYJal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 05:30:41 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8P9SOLR012631
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 10:30:40 +0100
Received: from mail-wm0-f71.google.com (mail-wm0-f71.google.com [74.125.82.71])
        by mx08-00252a01.pphosted.com with ESMTP id 2d5c3f11qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 10:30:40 +0100
Received: by mail-wm0-f71.google.com with SMTP id u138so7952417wmu.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 02:30:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE_XsMJu9k=j=YSCK3SF7bptHc4+eKVhJdYZaQtbhuYqbx_AZg@mail.gmail.com>
References: <1505208143-30166-2-git-send-email-arend.vanspriel@broadcom.com>
 <20170925081816.E31B560C6B@smtp.codeaurora.org> <CAE_XsMJu9k=j=YSCK3SF7bptHc4+eKVhJdYZaQtbhuYqbx_AZg@mail.gmail.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 25 Sep 2017 10:30:38 +0100
Message-ID: <CAE_XsMLpow8AT+uYq3WfN6tWw1TPcAbEMouguCgk6wU5fNi5hw@mail.gmail.com> (sfid-20170925_113051_736826_6B4F1CAF)
Subject: Re: [1/7] brcmfmac: handle FWHALT mailbox indication
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2017 at 10:26, James Hughes
<james.hughes@raspberrypi.org> wrote:
> On 25 September 2017 at 09:18, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>
>>> The firmware uses a mailbox to communicate to the host what is going
>>> on. In the driver we validate the bit received. Various people seen
>>> the following message:
>>>
>>>  brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
>>>
>>> Bit 4 is cause of this message, but this actually indicates the firmwar=
e
>>> has halted. Handle this bit by giving a more meaningful error message.
>>>
>>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Failed to compile:
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c: In function =E2=
=80=98brcmf_p2p_escan=E2=80=99:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: error: =
=E2=80=98BRCMF_SCANTYPE_ACTIVE=E2=80=99 undeclared (first use in this funct=
ion)
>>   sparams->scan_type =3D BRCMF_SCANTYPE_ACTIVE;
>>                        ^
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: note: eac=
h undeclared identifier is reported only once for each function it appears =
in
>> make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.o] Er=
ror 1
>> make[6]: *** Waiting for unfinished jobs....
>> make[5]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac] Error 2
>> make[4]: *** [drivers/net/wireless/broadcom/brcm80211] Error 2
>> make[3]: *** [drivers/net/wireless/broadcom] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>>
>> 7 patches set to Changes Requested.
>>
>> 9948825 [1/7] brcmfmac: handle FWHALT mailbox indication
>> 9948831 [2/7] brcmfmac: disable packet filtering in promiscuous mode
>> 9948829 [3/7] brcmfmac: cleanup brcmf_cfg80211_escan() function
>> 9948833 [4/7] brcmfmac: use msecs_to_jiffies() instead of calculation us=
ing HZ
>> 9948827 [5/7] brcmfmac: get rid of brcmf_cfg80211_escan() function
>> 9948823 [6/7] brcmfmac: get rid of struct brcmf_cfg80211_info::active_sc=
an field
>> 9948835 [7/7] brcmfmac: move configuration of probe request IEs
>>
>> --
>> https://patchwork.kernel.org/patch/9948825/
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingp=
atches
>>
>
> We (Raspberry Pi) currently have an issue open with Cypress to try and
> determine the cause of the firmware lockup which results in this
> mailbox error, we have some custom firmware that has better firmware
> diagnostics which we have been reporting back to Cypress. Not had any
> progress so far as far as I know. Does this kernel side fix help our
> users in any way or is it simply a better error message?
>
> James

Sorry, should have read the patch first, simply a change to the error
reporting. I'll try and determine how far Cypress have got with the
firmware.
