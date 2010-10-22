Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41343 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab0JVMpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 08:45:24 -0400
Received: by gwj21 with SMTP id 21so1015868gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 05:45:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikVug2RFWFkv7_dJn_jn+NZAyTR2wMoeDzC2-WG@mail.gmail.com>
References: <AANLkTin5xkWBGqkNiZR3Uiys52g4t9UpRaX1LrjxrG99@mail.gmail.com>
	<AANLkTikVug2RFWFkv7_dJn_jn+NZAyTR2wMoeDzC2-WG@mail.gmail.com>
Date: Fri, 22 Oct 2010 14:45:23 +0200
Message-ID: <AANLkTinwXMcP3F=Py4S2sjJVpiRsXpVndXP-W55EAsBT@mail.gmail.com>
Subject: Re: b43/SSB: SPROM revision problem
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 października 2010 14:41 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> W dniu 22 października 2010 13:23 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
>> I've problem with initializing N radio (2055) on my Broadcom card.
>>
>> In case of my card simple workaround [1] for radio initialization is
>> needed. If I do not use workaround radio simply does not start. I
>> dumped MMIO operations of "wl" and it uses workaround for my card as
>> well.
>>
>> The problem is that workaround condition is SPROM-based. It looks like this:
>> if (sprom->revision < 4)
>>        workaround = (some_specific_card);
>> else
>>        workaround = ((sprom->boardflags_hi & B43_BFH_NOPA) == 0);
>>
>> So now goes the tricky part. My SSB has following SPROM:
>> [ 6208.080097] ssb: SPROM offset is 0x1000
>> [ 6208.089815] ssb: SPROM revision 5 detected.
>>
>> However in drivers/ssb/pci.c there are some translations, including
>> one for my card. My SPROM revision gets translated to 4. The result
>> is:
>> sprom->revision: 4
>> sprom->boardflags_hi: 0x1
>>
>> With that revision and boardflags workaround is not used and my radio
>> does not init. There are two possibilities:
>> 1) Specs are wrong
>> 2) We do SPROM translation incorrectly
>>
>> Any hints about that?
>>
>>
>> [1] http://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init#Post_Init
>
> Ahhh, I should check for boardflags2! Expect patches soon ;)

Larry: could you check this and fix specs if I am right?

The way I understand this is following:
1) Workaround registers are:
a) 0x77: Core 1 RX Baseband Regulator
b) 0xa6: Core 2 RX Baseband Regulator
that really looks like regulatory-related
2) 0x00010000 BFL_NOPA has no PA
doesn't look like regulatory related
3) 0x00000001 BFL2_RXBB_INT_REG_DI external RX BB regulator present
looks like sth-related, so I guess we need to check for boardflags2

-- 
Rafał
