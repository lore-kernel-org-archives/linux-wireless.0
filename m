Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:63749 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937808AbZAPWKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 17:10:31 -0500
Received: by ewy12 with SMTP id 12so664532ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 14:10:28 -0800 (PST)
Message-ID: <497105D1.5040906@gmail.com> (sfid-20090116_231039_492057_B5A3A364)
Date: Fri, 16 Jan 2009 23:10:25 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Artur Skawina <art.08.09@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <496FFC9F.1000907@lwfinger.net> <1232097187.3854.9.camel@johannes> <200901162138.51855.chunkeey@web.de>
In-Reply-To: <200901162138.51855.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Friday 16 January 2009 10:13:07 Johannes Berg wrote:
>> On Thu, 2009-01-15 at 21:18 -0600, Larry Finger wrote:
>>
>>>>>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ikkkkkkkkkkkkkkk
>>> I too have seen real single bit changes - in my case 6b went to 6a,
>>> and my memory is fine. I wouldn't necessarily blame your hardware.
>> 6b to 6a is often the result of a refcounting bug that happens to unref
>> a value _after_ it has been freed. But that doesn't explain 6b to 69,
>> unless you happen to have _two_ refcounting bugs. Not that I necessarily
>> think that memory is bad
> Well, this idiotic debug patch (kref-kernel-debug-patch) could shed some light into
> the problem who's using a freed skb. 

didn't trigger anything here, just the usual:

BUG kmalloc-4096: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xdc8161b0-0xdc8161b0. First byte 0x6a instead of 0x6b
INFO: Allocated in dev_alloc_skb+0x19/0x30 age=1762 cpu=0 pid=3530
INFO: Freed in __kfree_skb+0xf/0x90 age=613 cpu=0 pid=3527
INFO: Slab 0xc1390200 objects=7 used=5 fp=0xdc816120 flags=0x400020c2
INFO: Object 0xdc816120 @offset=24864 fp=0xdc8140c0

but no other warnings...

artur
