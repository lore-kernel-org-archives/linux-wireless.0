Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54447 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZIYQvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 12:51:33 -0400
Received: by iwn8 with SMTP id 8so1690188iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 09:51:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909251132.18546.malte.gell@gmx.de>
References: <200909242155.19485.malte.gell@gmx.de> <4ABBE5DB.5070201@gmx.de>
	<200909251132.18546.malte.gell@gmx.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 09:51:17 -0700
Message-ID: <43e72e890909250951u15555d04t1e3bcb14c77788b4@mail.gmail.com>
Subject: Re: ar9170 makes machine hang when shut down
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 2:32 AM, Malte Gell <malte.gell@gmx.de> wrote:
>
> Joerg Albert <jal2@gmx.de> wrote
>
>> > Does it make sense to use "rmmod --force ar9170" to force removing that
>> > module before shutting down?
>>
>> Why are you sure that the hang is caused by the ar9170 driver?
>
> You are right.... I thought this way, because my machine never hung and after
> installing the USB stick it hang... But, I noticed when i disable ISDN
> subsystem, it did not hang, so maybe it is the ISDN subsystem, I will try
> further.
>
>> The vendor driver is called arusb_lnx, the new one ar9170usb
>
> Vendor driver? Does this mean, Atheros made a driver on its own? Are there
> several drivers for the same chip now?

Atheros wrote a vendor driver called otus for ar9170 devices, this was
prior to the change of focus on working upstream. Atheros then
released code and gave specs, etc to a community developer who wrote a
proper mac80211 driver for ar9170. The main focus for development
today is ar9170. I believe ar9170 does not yet have AMPDU aggregation
enabled by default so otus is still available including the stock
kernel under drivers/staging area until ar9170 matches all features
provided by otus, Read each drivers's wiki page, the section regarding
ar9170 and 11n support is very outdated, I know Chris has worked hard
on this area.

http://wireless.kernel.org/en/users/Drivers/otus
http://wireless.kernel.org/en/users/Drivers/ar9170

I have a feeling not enough people know about the wireless wiki...

  Luis
