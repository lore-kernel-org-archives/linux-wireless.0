Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:42818 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729984AbeHMVbp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 17:31:45 -0400
Received: by mail-oi0-f68.google.com with SMTP id b16-v6so29046996oic.9
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 11:48:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87tvnycw2b.fsf@purkki.adurom.net>
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
 <20180813084123.GA18180@redhat.com> <87tvnycw2b.fsf@purkki.adurom.net>
From: =?UTF-8?Q?Grzegorz_Duszy=C5=84ski?= <gfduszynski@gmail.com>
Date: Mon, 13 Aug 2018 20:48:17 +0200
Message-ID: <CAD7cUuD8b_b3riHPTEXROW64HCF8S0F2_XHgikz1J_seq-QxXQ@mail.gmail.com> (sfid-20180813_204821_790483_49BD060A)
Subject: Re: Cpu stall caused by hostapd running two interfaces
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can I help you somehow with this ?

Is this the reason for cpu stall ?

Should the issue exist while using single nic?

2018-08-13 14:03 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>
>> (cc Haim and Johannes)
>>
>> On Sun, Aug 12, 2018 at 09:54:00PM +0200, Grzegorz Duszy=C5=84ski wrote:
>>> Hello,
>>>
>>> I'm running into problems while trying to start AP's on 2 interfaces.
>>> Devices are:
>>> - Compex WLE900VX (QCA9880)
>>> - Killer 1535 (QCA6174)
>>>
>>> The 1535 is a new addition to the system.
>>> Compex by itself runs fine, Killer also can run alone.
>>>
>>> But when running them together all hell breaks lose.
>>> System is unusable, cannot even reboot.
>>>
>>> I'm running Arch Linux.
>>> My system was updated before testing & posting.
>>>
>>> Attachments:
>>> dmesg - https://pastebin.com/wf3Fq8gh
>>>
>>> Please let me know if additional info is required.
>>
>> This is oops in ieee80211_regulatory_limit_wmm_params().
>> Looks like new regulatory code do not like ath10k.
>> I have another bug report with reg.c WARNING also on ath10k:
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1612537
>
> I think bug #1612537 is with ath9k, not ath10k. But anyway, both use
> ath.ko which has some custom regulatory code.
>
> --
> Kalle Valo
