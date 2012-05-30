Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39286 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2E3DWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 23:22:34 -0400
Received: by wibhn6 with SMTP id hn6so3380039wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 20:22:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC5647F.4060601@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
	<4FC2437C.9090106@candelatech.com>
	<4FC51418.5000104@candelatech.com>
	<201205292107.42337.chunkeey@googlemail.com>
	<4FC5647F.4060601@candelatech.com>
Date: Wed, 30 May 2012 04:22:33 +0100
Message-ID: <CAA93jw6jTDCLh+_=hv6HcvfAuNah33uag7hHnZTMW8=92nvcqA@mail.gmail.com> (sfid-20120530_052239_393987_31D3AF08)
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
From: Dave Taht <dave.taht@gmail.com>
To: Ben Greear <greearb@candelatech.com>,
	cerowrt-devel@lists.bufferbloat.net
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 1:06 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/29/2012 12:07 PM, Christian Lamparter wrote:
>>
>> On Tuesday, May 29, 2012 08:23:20 PM Ben Greear wrote:
>>>
>>> On 05/27/2012 08:08 AM, Ben Greear wrote:
>>>>
>>>> On 05/26/2012 09:39 AM, Sujith Manoharan wrote:
>>>
>>> We started testing with two AR9380 NICs today (one AP, the other STA).
>>> I applied Felix's skb optimization patch, and the ath9k memleak fix patch
>>> on top of 3.3.7+.
>>>
>>> The system has 2GB RAM, but it is 32-bit kernel, so not all
>>> is available to the networking code...  That said, the OOM
>>> killer kills VNC and such.
>>>
>>> Anyway, I'll try some memleak debugging to see if
>>> I can find any leaks.  It seems to me that we should
>>> not actually OOM just by trying to transmit too fast
>>> on a station interface :P
>>
>> well, there's that:
>> http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/8233
>>
>> It might not fix the bug, but it can save you time to confirm
>> that is not related to this particular skb leak.
>
>
> I ported this to 3.3.7+ and applied it to my kernel
> trees.  It has tested out fine so far, though it did not
> actually fix the problem I was having.  That was not
> a real leak, just always-growing pending queue length,
> probably due to some issue with our version of pktgen.
>
> It is mostly a port-by-hand type of thing since
> there are lots of conflicts.  Let me know if you'd
> like me to post my version (and plz confirm your
> signed-off-by).

please! (and cc cerowrt-devel at lists.bufferbloat.net)

I'm hoping this string of patches will have some bearing on my own
bug: http://www.bufferbloat.net/issues/379

(while I'm trying to not write a line of code for a while, others on my
 list are struggling with this)

>
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://www.bufferbloat.net
