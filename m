Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:48185 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYKTWH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 17:07:57 -0500
Received: by ug-out-1314.google.com with SMTP id 39so419145ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 14:07:55 -0800 (PST)
Message-ID: <7fe9ff8d0811201407x51da0bcfwf1306c859e28c308@mail.gmail.com> (sfid-20081120_230800_958284_E0B286CC)
Date: Thu, 20 Nov 2008 23:07:54 +0100
From: "Kamil Dzida" <kamil.dzida@gmail.com>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: Symbol orinoco firmware under BSD, no extracting tools needed
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200811202053.52132.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7fe9ff8d0811200345o5c2a219dk256483a55c3b9e6a@mail.gmail.com>
	 <200811202053.52132.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 6:53 PM, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> On Thursday 20 November 2008, Kamil Dzida wrote:
>> Hello, for some time I have been interested in situation of firmware
>> for Linux drivers. I found something interesting.
>>
>> Some time ago I found that Agree firmware for orinoco driver was
>> submitted to linux-firmware tree. From driver documentation
>> (http://www.linuxwireless.org/en/users/Drivers/orinoco) I found that
>> orinoco driver also works with Symbol "Spectrum24" chipset. The
>> documentation states that firmware for that chipset is only available
>> by cutting it from Windows or Apple drivers (like Broadcom microcode).
>> Fortunately I found that it is not true. The firmware binary blobs for
>> Spectrum24 can be found on NetBSD and OpenBSD servers under BSD
>> license. Both have build in this firmware in their operating systems.
>>
>
> Does it support WPA and/or WPA2? Have you tested this firmware with
> orinoco driver?
>
> Thank you!
>
>
>>
>> This statement can be found in OpenBSD CVS:
>>
>> from netbsd:
>> Generated from the firmware binaries for T3 series CF adapter.
>> Obtained from Tim Gardner <timg@tpi.com> who developed the Linux driver.
>> And approved by Brad Lefore <blefore@sj.symbol.com> to redistribute it
>> with BSD license.
>>
>> (http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/esecsym?sortby=rev)
>>
>> This means that the only difference between firmware that Linux uses
>> and the *BSD firmware is that BSD people successfully negotiated
>> license change to BSD. Theoretically by simple drag and dropping the
>> files from OpenBSD/NetBSD to linux-firmware tree and renaming the
>> files will allow Linux users out of the box support of Symbol cards
>> without any firmware extraction tools. Just in case, contacting Mr.
>> Lefore of Symbol first would be also recommended.
>>
>> I hope this information will be helpful for orinoco driver development.
>>
>>
>> OpenBSD resources:
>> http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/?sortby=rev#dirlist
>>
>> and licence:
>>
>> http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/symbol-license?rev=1.4;content-type=text%2Fplain;sortby=rev
>>
>> NetBSD resources:
>> http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/dev/microcode/wi/?only_with_tag=MAIN
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
>
Unfortunately I haven't got Symbol card to test the firmware. OpeBSD
driver seems to be more advanced still their online manual doesn't
mention WPA/WPA2 only WEP 104-bit. Actually I did not know that
extracted firmware that Linux uses include WPA support. Why not try
the NetBSD trick? Extract the firmware with WPA support and ask Symbol
to re-licence it under BSD/ISC. On the other hand as far as I know
OpenBSD got WPA support in their system in summer this year (no
kidding!), so perhaps the firmware can do WPA, but software part is
not ready to handle it yet. Summarizing someone with Spectrum based
card is needed here.
