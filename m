Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:39358 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZG1LDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 07:03:18 -0400
Received: by bwz21 with SMTP id 21so818151bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 04:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248726744.32365.4.camel@johannes.local>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <200907272035.41193.chris2553@googlemail.com>
	 <1248725279.7440.8.camel@mj>
	 <200907272122.11290.chris2553@googlemail.com>
	 <1248726744.32365.4.camel@johannes.local>
Date: Tue, 28 Jul 2009 12:03:17 +0100
Message-ID: <c6b1100b0907280403x697d8816mfb5206e1fb93243a@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

2009/7/27 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2009-07-27 at 21:22 +0100, Chris Clayton wrote:
>
>> Yes, I remove the card once the laptop has frozen, because doing so "thaws" it again. The laptop is
>> then usable until 2-5 minutes after I insert the card again, when it will freeze again. I can
>> repeat this cycle over and over.
>

Inspired by the fact that Pavel doesn't get the freeze, I've just
cloned and tested the latest and greatest wireless-testing tree and,
unfortunately, the freeze still occurs. In fact it seems to happen
even more quickly now!

> That really points to a hw (or hw programming) bug that causes the card
> to lock up the bus. Had that many times in early b43 days.

If it's a programming problem, might it be fixable in the firmware
(rt2561s.bin)?

If not and given this is a Belkin card (model F5D7010), I guess there
could be thousands of them out there, so some note on the Devices
section of linuxwireless.org might help other users. In fact two
versions of this this model are currently shown as supported by the
b43 driver, but this, which has worked fine until now, isn't mentioned
at all. T

>> > It looks like a problem specific to the hardware, not anything in the
>> > common wireless code.  I suggest that you post your question to
>> > users@rt2x00.serialmonkey.com.  That's the mailing list for rt61pci and
>> > other Ralink devices.
>>
>> I think I'll just configure MAC80211 power saving off or use the ath5k card that I also own.
>
> You could also ask Ivo to disable power saving for rt61pci.
>

Rather than simply disabling power saving, could it be done though a
module parameter, so that those with more robust cards are not
disadvantaged?

Chris

-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
