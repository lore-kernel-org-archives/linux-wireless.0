Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59022 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZLWM2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:28:11 -0500
Received: by ewy19 with SMTP id 19so6258401ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 04:28:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261061645.10356.114.camel@johannes.local>
References: <e92712b70912170610y74eb6ae8ifd8db347cc608808@mail.gmail.com>
	 <1261061645.10356.114.camel@johannes.local>
Date: Wed, 23 Dec 2009 14:28:10 +0200
Message-ID: <e92712b70912230428s7caee5eag6943a8eb6a8b7a78@mail.gmail.com>
Subject: Re: Backoff algorithm
From: Andrey Lukyanenko <laser.ru@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot for your help.

I have found OpenFWWF project, which has open source firmware for Broadcom
chipsets. Unfortunately it does not support CTS/RTS, AP.
What do you mean by " influencing the value you give the hw"?
Are you talking about direct access to registers? How can I influence.
I have heard about tos-mac (TinyOS) which uses directly registers but it
is for sensors. Do you mean something similar?

In our group we have five ar5213 chips, I hope I can try to use it.

On Thu, Dec 17, 2009 at 4:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-12-17 at 16:10 +0200, Andrey Lukyanenko wrote:
>> Hello Everyone,
>>
>> I wanted to find implementation of backoff protocols for different platforms.
>> I tried to find it in various open-source drivers in linux-sources, madwifi and
>> stlc45xx. Everywhere I could only find some initialization of CWmax, CWmin, ...
>> but not the actual algorithm (something like, cw = min(cw<<1 + 1, cwmax) ),
>> except ath_rate sample/mistrel where the operation is used for "best
>> rate measurement"
>> as I understood.
>> Am I correct to assume that the protocol is implemented in firmwhere and there
>> is no open source driver which I could use to "play" directly with it?
>
> Yes, basically. It's not something you can really implement in any
> driver anyway as it's very timing sensitive.
>
> ar9170 even has this in hardware, afaik, although you can of course play
> with it in b43 firmware and/or ar9170 by influencing the value you give
> the hw.
>
> johannes
>



-- 
Best regards,
Andrey Lukyanenko.
