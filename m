Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45569 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbZKJVkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 16:40:12 -0500
Received: by ewy3 with SMTP id 3so524628ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 13:40:16 -0800 (PST)
Message-ID: <4AF9DDBE.8000200@gmail.com>
Date: Tue, 10 Nov 2009 22:40:14 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Initialize rf302x RF values properly in rt2800pci.
References: <1257804017-5446-1-git-send-email-gwingerde@gmail.com> <200911101941.33825.bzolnier@gmail.com>
In-Reply-To: <200911101941.33825.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/09 19:41, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Gertjan,
> 
> On Monday 09 November 2009 23:00:17 Gertjan van Wingerde wrote:
>> Insert RF chipset values for the RF302x chipsets. Mirrored from the rt2800usb driver.
>> Also, ensure these RF chipsets are handled properly in rt2800lib for the rt3090 chipset.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>
>> This one clashes with the patch series sent by Bart. However, I believe that logically this patch
>> belongs before his patch series, as it makes the unification cleaner and clearer.
> 
> The change itself is correct and much welcomed but please take a look
> at the diffstat below:
> 
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
>>  drivers/net/wireless/rt2x00/rt2800pci.c |   31 +++++++++++++++++++++++++++----
>>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++----
>>  3 files changed, 34 insertions(+), 10 deletions(-)
> 
> I worry that applying this patch before unification will not make anything
> cleaner, especially since it duplicates code that unification patch will now
> have to also remove:
> 

I agree that the patch in itself won't make things cleaner. However, my argument was that applying this
patch before unification would make the unification patch cleaner and clearer (i.e. it would be more
obvious that there is a large degree of overlap).

However, since I am such a nice guy, I will respin my 2 of my patches (the RT3070 detection for rt2800usb
and this one) to apply on top of your patch series.

---
Gertjan.
