Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55740 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbAZLgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 06:36:20 -0500
Received: by mail-wi0-f174.google.com with SMTP id n3so9259231wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 03:36:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C5FEB0.1000609@neratec.com>
References: <CAF4BKcCggD23NHD_1156bqLsqMjDWp+8ASJaxJdLXUXcXaaddQ@mail.gmail.com>
 <54C5FEB0.1000609@neratec.com>
From: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>
Date: Mon, 26 Jan 2015 05:35:39 -0600
Message-ID: <CAF4BKcAs9XTPFAu4h7PmtcW0Uhb+rbX8qmxG_hGoSotWeGdsfg@mail.gmail.com> (sfid-20150126_123624_424522_AFDE433F)
Subject: Re: Inquiry on sudo iw dev wlan1 set txpower fixed 14 -> command
 failed: Invalid argument (-22)
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias May, thanks for the quick response.

I was already aware that it's mBm, not dBm, and had previously tried
140, instead of 14 and lower before my initial e-mail.

However, 1400, 14000, and 140000 all produce the same error message.

Not to tangent off topic, but the way the article/man page reads, one
should be able to adjust the txpower from the maximum the chipset
could handle or maximum for the regulatory domain, whichever is lower,
all the way down to just above 0, if not 0 itself.

Christopher M. Penalver
E-Mail: christopher.m.penalver@gmail.com


On Mon, Jan 26, 2015 at 2:45 AM, Matthias May <matthias.may@neratec.com> wrote:
> On 26/01/15 03:00, Christopher M. Penalver wrote:
>>
>> Attempting to follow
>> http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
>> I get:
>> sudo iw dev wlan1 set txpower fixed 14
>> command failed: Invalid argument (-22)
>>
>>
>
> iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]
>
> This is set in mBm and not in dBm.
> Try sudo iw dev wlan1 set txpower fixed 1400.
