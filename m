Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f181.google.com ([209.85.216.181]:61012 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0CJHxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 02:53:12 -0500
Received: by pxi11 with SMTP id 11so2064732pxi.15
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 23:53:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268199428.17677.9.camel@mj>
References: <201003040835.29387.malte.gell@gmx.de> <1267827995.3068.33.camel@mj>
	<201003060342.19623.malte.gell@gmx.de> <1268199428.17677.9.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Mar 2010 23:52:51 -0800
Message-ID: <43e72e891003092352w433c018t3ed05d3279abf67e@mail.gmail.com>
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
To: Pavel Roskin <proski@gnu.org>
Cc: Malte Gell <malte.gell@gmx.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 9, 2010 at 9:37 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Sat, 2010-03-06 at 03:42 +0100, Malte Gell wrote:
>> Pavel Roskin <proski@gnu.org> wrote
>>
>> > On Thu, 2010-03-04 at 08:35 +0100, Malte Gell wrote:
>> > > Hello,
>> > >
>> > > I just upgraded from Kernel 2.6.32 to 2.6.33 and the ar9170 driver
>> > > suddenly says "firmware file not found".
>>
>> Ok, this is what the kernel says:
>>
>>  <6>[   12.020028] usb 1-3: firmware: requesting ar9170.fw
>> <3>[   72.050094] usb 1-3: ar9170.fw firmware file not found, trying old
>> firmware...
>> <6>[   72.066421] usb 1-3: firmware: requesting ar9170-1.fw
>> <3>[  132.080085] usb 1-3: file with init values not found.
>> <4>[  132.096535] ar9170usb: probe of 1-3:1.0 failed with error -2
>> <6>[  132.113558] usbcore: registered new interface driver ar9170usb
>>
>> I have the same firmware in /lib/firmware I use with 2.6.32 and it is actually a
>> Fritz WLAN N stick...
>
> Oh, I see.  I misunderstood you.  When you mentioned that you get the
> message "firmware file not found", I thought you were getting that
> message without the firmware name.  Indeed, the driver can print it
> under some rare circumstances, but it's not the case here.
>
> I should have asked you for the exact kernel log output before delving
> into the sources and trying to guess what is happening.  That serves me
> a lesson.
>
> So you have a case of the firmware not loading at all.  I'm pretty sure
> the problem lies outside the driver, and likely outside the kernel.

To debug firmware loading you can run

udevadm monitor

And read all the stuff there when you try to load the driver.

  Luis
