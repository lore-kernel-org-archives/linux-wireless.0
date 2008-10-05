Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:28103 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbYJEBZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 21:25:14 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2217206wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 18:25:13 -0700 (PDT)
Message-ID: <40f31dec0810041825s49fad088x1efb9562bcc68cce@mail.gmail.com> (sfid-20081005_032520_133997_2536C0BB)
Date: Sun, 5 Oct 2008 04:25:13 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Fix SREV reporting after SREV updates
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
In-Reply-To: <20081005003710.GA3222@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080928222444.GD21335@makis>
	 <20081005003710.GA3222@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/5 Bob Copeland <me@bobcopeland.com>:
> On Mon, Sep 29, 2008 at 01:24:44AM +0300, Nick Kossifidis wrote:
>>  * Fix srev reporting during attach
>>
>>  Changes-Licensed-under: ISC
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> This now identifies my card as 5414, whereas ath5k used to call it 5424
> (mac srev 0xa3, phy 0x61).
>
> But, madwifi has:
>  #define AR5K_SREV_VER_AR5424     0xa3 /* PCI-E */
>
> It still works so not a major problem, but who's right?
>
>> @@ -396,7 +396,11 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>>       for (i = 0; i < ARRAY_SIZE(srev_names); i++) {
>>               if (srev_names[i].sr_type != type)
>>                       continue;
>> -             if ((val & 0xff) < srev_names[i + 1].sr_val) {
>> +
>> +             if ((val & 0xf0) == srev_names[i].sr_val)
>> +                     name = srev_names[i].sr_name;
>> +
>> +             if ((val & 0xff) == srev_names[i].sr_val) {
>>                       name = srev_names[i].sr_name;
>>                       break;
>>               }
>>
>

Well acording to legacy-hal (ar5212reg.h):

5424 (condor) version = 9
5414 (eagle) version = 10
Yours is 0xa0 -> 5414

5424 radio version = 0xa0
5414 radio version = 0x60
yours is 0x61 -> 5414

It's also weird to me, since 5414 is pci/mini-pci and 5424 is pci-e
and even if OEMs just made 5414s with pci-e support (eg. with a
pci2pci-e bridge) and branded them as 5424s or something like that,
then your chip shouldn't have problem when reseting pci core so i
guess there is a 5414 version that has pci-e HIU. They both belong to
AR5006 series btw so they have the known pci-id mess.

I got the srev values used before legacy-hal by doing a search on logs
on madwifi's trac so they seem to match user reports but i guess
legacy-hal is more accurate. For the driver 5424 is 5414 with some
pci-e extras (power saving etc).

Luis Is there a pci-e version of 5414 ? Is 5424 the pci-e version of
5414 or it's another chip ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
