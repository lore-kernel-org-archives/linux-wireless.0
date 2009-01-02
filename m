Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from warsl404pip6.highway.telekom.at ([195.3.96.89]:16017 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758507AbZABTMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 14:12:18 -0500
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: status of at76-usb driver
Message-ID: <1230923532.495e670ca90b6@webmail.aon.at> (sfid-20090102_201221_174337_91635604)
Date: Fri, 02 Jan 2009 20:12:12 +0100 (CET)
From: Claudio <der.claudio@aon.at>
Cc: linux-wireless@vger.kernel.org
References: <11844363.2869.1230645164289.JavaMail.root@WARSBL214.highway.telekom.at> <87fxk1902j.fsf@litku.valot.fi>
In-Reply-To: <87fxk1902j.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> wrote:
> Claudio <der.claudio@aon.at> writes:
>
>> my at76 hardware: Netgear MA101 rev.B
>>
>> experiences:
>> - works with Ubuntu 7.10 with stand-alone at76-usb-0.17 package
>> - AFAIR didn\'t work with Ubuntu 7.10 out-of-the-box
>> - didn\'t work with Ubuntu 8.10 (even didn\'t when I tried to install the
>>   old stand-alone version)

Last one is wrong. See below.

> I tried twice with latest Ubuntu 8.10 (updated yesterday) and kernel
> oopsed both time for me:

So it did for me.

But the at76_usb that comes with Ubuntu 8.10 is actually a (very old)
0.14beta1 version. Try $ strings /lib/modules/`uname \\
-r`/kernel/ubuntu/misc/wireless/at76/at76_usb.ko | egrep \'0.1[47]\'

Ad 1: It seems like Ubuntu ships an outdated version of the old
stand-alone driver.

Ad 2: I\'ve found a work-around (I\'ve tried this earlier but it did not
work for any reason): adapting and compiling the 0.17 version of the old
stand-alone driver (http://developer.berlios.de/projects/at76c503a/) ->
It works again.

Since this is not the perfect solution I would like to find out how to
enable the at76 driver from the staging tree and then vote for doing the
same in the Ubuntu kernel package. Well, how do I enable this driver
anyway?

Or what do you think we should do?

Claudio
