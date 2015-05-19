Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:32776 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbESRXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 13:23:24 -0400
Received: by lagr1 with SMTP id r1so34901291lag.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 10:23:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555B5C18.5000906@lwfinger.net>
References: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
	<555B5C18.5000906@lwfinger.net>
Date: Tue, 19 May 2015 20:23:22 +0300
Message-ID: <CAJ=9Czaqc5tVB50QBBhTG8xCQ4g93EspqvwnoMFjt3Wszvg+0g@mail.gmail.com> (sfid-20150519_192328_031150_93043EE2)
Subject: Re: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2015 at 18:51, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/19/2015 12:47 AM, Haggai Eran wrote:
>>
>> With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
>> packet are set, but the packet length is too large. Truncate the packet
>> to prevent memory corruption.
>>
>> Signed-off-by: Haggai Eran <haggai.eran@gmail.com>
>> ---
>>
>> Hi,
>>
>> I think this solves the issue for me. I'll test it more thoroughly later.
>> I
>> still don't know why a fragmented packet has such a large pkt_len value
>> though.
>>
>> Thanks,
>> Haggai
>>
>>   drivers/staging/rtl8712/rtl8712_recv.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>
>
> I added a printout to your patch to log the values for tmp_len and alloc_sz
> when tmp_len > alloc_sz. In about 15 minutes of running, that print has not
> triggered. The condition only seems to happen on your system.
>
> Please replace your patch with my modified version and report the printed
> values.

I think you attached the original version, and not the one with the
prints. In any case, here are some example values I've seen:

[41727.150644] truncating packet: tmp_len = 3478, alloc_sz = 1658,
pkt_len = 3454, drvinfo_sz = 0
[41732.746346] truncating packet: tmp_len = 13484, alloc_sz = 1658,
pkt_len = 13460, drvinfo_sz = 0
[42044.508326] truncating packet: tmp_len = 9998, alloc_sz = 1658,
pkt_len = 9974, drvinfo_sz = 0
[42044.600013] truncating packet: tmp_len = 1982, alloc_sz = 1658,
pkt_len = 1958, drvinfo_sz = 0
[42044.677548] truncating packet: tmp_len = 11920, alloc_sz = 1658,
pkt_len = 11896, drvinfo_sz = 0

I think this issue may have started when I changed my home router /
access point from a LevelOne WDR-6001 to a TP-Link TL-WR1043ND. Could
these packets be trigerred somehow by a different interaction between
the access point and the wifi adapter?

In addition to these fragmented packets, by the way, I'm still seeing
by the way many packets that are dropped for other reasons, such as:
 - invalid ver field
 - seq_ctrl doesn't match in recv_decache
 - sta2sta_data_frame failing for some reason
 - packets with frame type 12.

Thanks,
Haggai
