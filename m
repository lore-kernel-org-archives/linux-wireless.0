Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:23240 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaFUQ5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 12:57:01 -0400
Message-ID: <53A5B95B.2040705@broadcom.com> (sfid-20140621_185717_308400_5C805B5F)
Date: Sat, 21 Jun 2014 18:56:59 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 2/8] brcmfmac: Add USB device 43566 to supported devices.
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>	<1403345479-13467-3-git-send-email-arend@broadcom.com> <CACna6rz81wbFET4GJH8xQ8aTqGfGccPGmD5vwfmmw9KWsZRPWg@mail.gmail.com>
In-Reply-To: <CACna6rz81wbFET4GJH8xQ8aTqGfGccPGmD5vwfmmw9KWsZRPWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/14 17:55, Rafał Miłecki wrote:
> On 21 June 2014 12:11, Arend van Spriel<arend@broadcom.com>  wrote:
>> From: Hante Meuleman<meuleman@broadcom.com>
>>
>> Add the USB 43566 device to the supported devices list. The 43566
>> is a WiFi-only variant of the 43569. It uses the same FW as 43569.
>
> What about USB ID of this device? You didn't add any. Is it shared
> with some different one? A 0a5c:bd27 maybe?

The 43566 has exactly the same USB ID as the 43569. The bootloader in 
the device will tell brcmfmac what it is during probe. These devices are 
exactly the same for the WiFi part, but 43569 additionally has BT logic 
inside being a composite USB device. Patch 4 probably is needed to make 
that work. That probably would have been clear when mentioned in the 
43569 patch.

Regards,
Arend
