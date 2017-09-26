Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:48575 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966725AbdIZLLI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 07:11:08 -0400
Received: by mail-wr0-f175.google.com with SMTP id 108so12822275wra.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2017 04:11:08 -0700 (PDT)
Subject: Re: [1/7] brcmfmac: handle FWHALT mailbox indication
To: James Hughes <james.hughes@raspberrypi.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1505208143-30166-2-git-send-email-arend.vanspriel@broadcom.com>
 <20170925081816.E31B560C6B@smtp.codeaurora.org>
 <CAE_XsMJu9k=j=YSCK3SF7bptHc4+eKVhJdYZaQtbhuYqbx_AZg@mail.gmail.com>
 <CAE_XsMLpow8AT+uYq3WfN6tWw1TPcAbEMouguCgk6wU5fNi5hw@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1381b572-184e-9cea-c83e-2c4f5d196a93@broadcom.com> (sfid-20170926_131247_751115_6860D402)
Date: Tue, 26 Sep 2017 13:11:04 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsMLpow8AT+uYq3WfN6tWw1TPcAbEMouguCgk6wU5fNi5hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-09-17 11:30, James Hughes wrote:
> On 25 September 2017 at 10:26, James Hughes
> <james.hughes@raspberrypi.org> wrote:
>> On 25 September 2017 at 09:18, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>
>>>> The firmware uses a mailbox to communicate to the host what is going
>>>> on. In the driver we validate the bit received. Various people seen
>>>> the following message:
>>>>
>>>>   brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
>>>>
>>>> Bit 4 is cause of this message, but this actually indicates the firmware
>>>> has halted. Handle this bit by giving a more meaningful error message.
>>>>
>>>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>>>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> Failed to compile:
>>>
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c: In function ‘brcmf_p2p_escan’:
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: error: ‘BRCMF_SCANTYPE_ACTIVE’ undeclared (first use in this function)
>>>    sparams->scan_type = BRCMF_SCANTYPE_ACTIVE;
>>>                         ^
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: note: each undeclared identifier is reported only once for each function it appears in
>>> make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.o] Error 1
>>> make[6]: *** Waiting for unfinished jobs....
>>> make[5]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac] Error 2
>>> make[4]: *** [drivers/net/wireless/broadcom/brcm80211] Error 2
>>> make[3]: *** [drivers/net/wireless/broadcom] Error 2
>>> make[2]: *** [drivers/net/wireless] Error 2
>>> make[1]: *** [drivers/net] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> 7 patches set to Changes Requested.
>>>
>>> 9948825 [1/7] brcmfmac: handle FWHALT mailbox indication
>>> 9948831 [2/7] brcmfmac: disable packet filtering in promiscuous mode
>>> 9948829 [3/7] brcmfmac: cleanup brcmf_cfg80211_escan() function
>>> 9948833 [4/7] brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
>>> 9948827 [5/7] brcmfmac: get rid of brcmf_cfg80211_escan() function
>>> 9948823 [6/7] brcmfmac: get rid of struct brcmf_cfg80211_info::active_scan field
>>> 9948835 [7/7] brcmfmac: move configuration of probe request IEs
>>>
>>> --
>>> https://patchwork.kernel.org/patch/9948825/
>>>
>>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>>>
>>
>> We (Raspberry Pi) currently have an issue open with Cypress to try and
>> determine the cause of the firmware lockup which results in this
>> mailbox error, we have some custom firmware that has better firmware
>> diagnostics which we have been reporting back to Cypress. Not had any
>> progress so far as far as I know. Does this kernel side fix help our
>> users in any way or is it simply a better error message?
>>
>> James
> 
> Sorry, should have read the patch first, simply a change to the error
> reporting. I'll try and determine how far Cypress have got with the
> firmware.

Hi James,

This was indeed only about getting rid of the "unknown mailbox" message. 
The times I have seen this also brcmf_sdio_checkdied() was printing a 
message that a firmware trap occurred. Does the forensics file in 
debugfs show anything for your issue or does the probe fail resulting in 
a detach.

Regards,
Arend
