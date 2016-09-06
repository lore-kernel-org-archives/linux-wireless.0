Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32961 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756178AbcIFN3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 09:29:35 -0400
Received: by mail-oi0-f41.google.com with SMTP id y2so71308689oie.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2016 06:29:35 -0700 (PDT)
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
To: Sven Eckelmann <sven@narfation.org>
References: <1586991.4QUcrJhXOm@prime>
 <d6f2b558-167b-cb48-e924-7bac815817b1@lwfinger.net>
 <2747159.ja51ucCDFk@bentobox> <2186338.AojtHidiB8@bentobox>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1d72a2ac-03e7-37d8-c367-68413595443e@lwfinger.net> (sfid-20160906_152944_201614_A82509E5)
Date: Tue, 6 Sep 2016 08:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <2186338.AojtHidiB8@bentobox>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2016 08:09 AM, Sven Eckelmann wrote:
> On Dienstag, 6. September 2016 09:40:41 CEST Sven Eckelmann wrote:
>> On Freitag, 2. September 2016 12:53:28 CEST Larry Finger wrote:
>> [...]
>>
>>> The patch I included in my previous E-mail, and attached here,  does get
>>> the firmware loaded correctly. There is still a problem that prevents
>>> authentication. I'm still looking for that issue.
>>
>> Thanks for the fast update. I am currently testing your patch. It looks like
>> the initial error is now gone. The hostapd also starts but beaconing
>> doesn't seem to work at all (no error from the kernel/hostapd but the
>> device is not sending anything). I am currently checking how beaconing is
>> supposed to work in your driver. Maybe I will spot something useful.
>
> Yes, found something similar in the checksumming algorithm. See the attached
> patch for details.

Just for the record, this is not "my" driver. It was provided by Realtek. My 
contribution has only been to clean it up.

Thanks for the patch. I too had found that checksum code, but I had not sent it 
as there are still problems on BE machines. These difficulties are running the 
NIC in STA mode. I have not tried AP mode. Scan data seem to be read OK, but it 
never authenticates. I do not know if there are further errors in setting up the 
transmit buffer, or if the problem is in the encryption/decryption code. I'm 
still looking.

Larry
