Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm10-vm1.bullet.mail.ird.yahoo.com ([77.238.189.93]:29196 "EHLO
	nm10-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab3JRPiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 11:38:24 -0400
Message-ID: <526155ED.1090007@yahoo.de> (sfid-20131018_173829_130028_C8338B84)
Date: Fri, 18 Oct 2013 17:38:21 +0200
From: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de>
In-Reply-To: <52614E9B.6040400@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 18.10.2013 17:07, schrieb Oleksij Rempel:
> Am 18.10.2013 16:49, schrieb Alan Stern:
>> Yannik, you should always use Reply-To-All so that your messages
>> get sent to the mailing list and not just to me.
>> 
>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>> 
>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>> Please post two usbmon traces, one showing the failure on
>>>> your current system and the other showing the adapter running
>>>> correctly under a 32-bit kernel.  Instructions for usbmon are
>>>> in the kernel source file Documentation/usb/usbmon.txt.
>>> I never got it to work under a 32-bit kernel, i was just able
>>> to utilize a windows32 driver using ndiswrapper.
>>> 
>>> Now i got it to "work". I randomly found out that the ar5523
>>> driver actually works when you load it after you unload
>>> ndiswrapper so the following steps make it work: 1. modprobe
>>> ndiswrapper 2. plug in device 3. connect to wlan using
>>> ndiswrapper and disconnect again (might be optional) 4.
>>> modprobe -r ndiswrapper 5. modprobe ar5523 6. connect to wlan 
>>> log for that is attatched as wlanthennative2.log
> 
> 
> It sounds like linux driver didn't recognised usb id and didn't
> uploaded firmware, or there was no firmware to upload.
there is firmware (/lib/firmware/ar5523.bin exists) but it does not
even get touched (i renamed the file and the error did not change at all)

> thas is probably other issue.  Let's start with thirst issue.
Ok, instructions?


- -- 
Yannik Völker
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSYVXtAAoJEDqk81AiCyXKm3AP/jBgoxUZVAftnT/wasdo3gTe
Tooh1P/Kg0F6pAxzEdZ4C2XAlBdZnU4IPBPdBSxYwSYP4tAN6PW9fkdxHYIVUYNr
G09dsjXOKW2+Ax5M9T2bGw+IV/mYMjXTlFG0uWw087q+LhvYH/SX9BGOJWGQf0e3
xQWilxQ5NwooAd5ofkOzZ3yplRZQXU5WmwKzjieH/iGj/JKPN2cvY5PJ029NSwXT
DNj4zuT5o1M6QGS0NH5A3Wsmw8iFDNSU1/ezVPbwLCoiAcVL77Wi5cHPn7NIPab7
qgXkySAiByehH+8KeHWRXqv/sp0RMLjbg4sbMYrz4t2GCsqkCR88y+Nexz4XavjG
LdBoILmXpTJoTvm3b2EQdjCPzwJJ3nUVB6rtqbUgCsGTVfTX1oz2EFSEFJtiJWW2
1qvF/vqb1/Cn5k9gxNaDdmmUaN6zY4mIPPyBspoCYnExU+fXOHreAhcHsN4xBdDw
jjZWFrWTWKvNbFUNgukHb2dCqjBCn5E8F5G3ROUVRygN5ewdThg1lI3xKH3aOLTy
ZghSbi+yipyHD5NOdd2Z+rayGd+wD2Vk9i2X2GXwR6QPLgOe3OxQUoJu8vx7/E9S
I//0D1RVdhrma3kUELEy6xcn9nLMQohE2LPn8yLjYkRAPzR/46xTR8LYFdC2SKyC
/T+2qtvM4oJfTrhiTThf
=y5hR
-----END PGP SIGNATURE-----
