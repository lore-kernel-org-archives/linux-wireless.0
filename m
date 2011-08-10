Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63269 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HJQm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:42:59 -0400
Received: by pzk37 with SMTP id 37so2118554pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 09:42:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110810184028.3cb9c532@milhouse>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
	<20110810184028.3cb9c532@milhouse>
Date: Wed, 10 Aug 2011 18:42:59 +0200
Message-ID: <CACna6rxBof9T+vaZ=wHZJcXY12XVrYvFbHEdXk1+=_LAwjmtig@mail.gmail.com> (sfid-20110810_184301_999229_CD8A8A8A)
Subject: Re: [PATCH 1/2] ssb: fix DMA translation for some specific boards
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 sierpnia 2011 18:40 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Wed, 10 Aug 2011 18:11:27 +0200
>> +/* Some chipsets need routing known for PCIe and 64-bit DMA */
>> +static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
>> +{
>> +     u16 chip_id = dev->bus->chip_id;
>> +
>> +     if (dev->id.coreid == SSB_DEV_80211)
>> +             return (chip_id == 0x4322 || chip_id == 43221 ||
>> +                     chip_id == 43231 || chip_id == 43222);
>> +     return 0;
>> +}
>
> ACK, apart from this coding style violation (missing curly braces).

>From kernel CodingStyle:
> Do not unnecessarily use braces where a single statement will do.
>
> if (condition)
> 	action();

I guess simple "return" (even when using line break) is still like
single statement...
Am I wrong?

-- 
Rafał
