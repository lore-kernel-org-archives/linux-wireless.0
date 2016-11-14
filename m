Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35752 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbcKNL1J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 06:27:09 -0500
Received: by mail-pg0-f47.google.com with SMTP id p66so53360483pga.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 03:27:08 -0800 (PST)
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
To: Gianfranco Costamagna <locutusofborg@debian.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
 <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
 <690669269.1124561.1477671348137@mail.yahoo.com>
 <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com> (sfid-20161114_122713_719142_2708F2F6)
Date: Mon, 14 Nov 2016 12:22:00 +0100
MIME-Version: 1.0
In-Reply-To: <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-10-2016 22:41, Arend Van Spriel wrote:
> On 28-10-2016 18:15, Gianfranco Costamagna wrote:
>> (resending from my debian.org mail address, to avoid spam filtering)
>>
>> Hi Broadcom developers and linux wireless list.
>>
>> We found a possible issue in the cfg80211 implementation of the regulatory domain rules:
>>
>>         .reg_rules = {
>>                 /* IEEE 802.11b/g, channels 1..11 */
>>                 REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
>>
>>
>> the referred channel 11 has/should have a frequency of 2462, not 2472 (corresponding to channel 13).
>> Is this a typo in the code or the above comment?
>>
>> (I'm not sure why the override of reg.c is in place for 2.4 Ghz frequencies)
>>
>> Can you please double check and in case apply the attached patch?
> 
> checking.... stay tuned.

Hi Gianfranco,

Finally response. As it turns out the range was explcitly changed
enabling channels 12 and 13 to be used where applicable. They forgot to
update the comment.

Regards,
Arend
