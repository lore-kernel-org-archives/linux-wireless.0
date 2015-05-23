Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34808 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbbEWRYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 13:24:19 -0400
Received: by laat2 with SMTP id t2so29860462laa.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 May 2015 10:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ=9CzYr2rFxZprM0Ap+x+Vu3LDXJUtxqtHqH-YER-ABscRb0w@mail.gmail.com>
References: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
	<CAJ=9Czay5pbi6p+n8SxXaJsWG4JR2p_vteKYbLxvoxLVtPQPaQ@mail.gmail.com>
	<555CB8C1.1040007@lwfinger.net>
	<CAJ=9CzYr2rFxZprM0Ap+x+Vu3LDXJUtxqtHqH-YER-ABscRb0w@mail.gmail.com>
Date: Sat, 23 May 2015 20:24:17 +0300
Message-ID: <CAJ=9CzbohiYSj1J4M17iK4Rqh0bopEF8zhN=Sqrh7GO6eBP-=w@mail.gmail.com> (sfid-20150523_192424_892569_064702B0)
Subject: Re: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 22:20, Haggai Eran <haggai.eran@gmail.com> wrote:
> On 20 May 2015 at 19:39, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 05/20/2015 01:17 AM, Haggai Eran wrote:
>>>
>>> On May 19, 2015 08:47, "Haggai Eran" <haggai.eran@gmail.com
>>> <mailto:haggai.eran@gmail.com>> wrote:
>>>  >
>>>  > With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
>>>  > packet are set, but the packet length is too large. Truncate the packet
>>>  > to prevent memory corruption.
>>>  >
>>>  > Signed-off-by: Haggai Eran <haggai.eran@gmail.com
>>> <mailto:haggai.eran@gmail.com>>
>>>  > ---
>>>  >
>>>  > Hi,
>>>  >
>>>  > I think this solves the issue for me. I'll test it more thoroughly
>>> later. I
>>>  > still don't know why a fragmented packet has such a large pkt_len value
>>> though.
>>>  >
>>>  > Thanks,
>>>  > Haggai
>>>  >
>>>
>>> I guess I was too quick with this patch. It prevents the kernel page
>>> faults, but
>>> with it I still see sometimes the connectivity disappear for a minute or
>>> two.
>>
>>
>> Is anything logged when that happens?
> No. I get once in a while the other corrupted entries I told you
> about, but nothing special to these freezes
>
>> I'm still trying to see where that magic number of 1658 comes from, and how
>> that affects the RX buffer size.
>
> I tried to look at the new driver (rtl8192su), but it doesn't seem to
> handle this more-fragment bit at all.
>
>> When I unconditionally set alloc_sz to tmp_len as in the attached patch (I
>> remembered to refresh it this time), nothing bad has happened here yet. What
>> happens on your box?
>
> The same freezes still occur.

I think the freezes I saw weren't related to the same issue. I was
running a debugging kernel, and I saw the same freezes also with a
different wifi adaptor. After switching to a non-debugging kernel, and
using your patch, the freezes stopped.

Thanks,
Haggai
