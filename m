Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:60438 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbAYUYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 15:24:25 -0500
Received: by mail-oi0-f41.google.com with SMTP id z81so4628330oif.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 12:24:24 -0800 (PST)
Message-ID: <54C550F7.8080908@lwfinger.net> (sfid-20150125_212431_075216_74C8E1CF)
Date: Sun, 25 Jan 2015 14:24:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel crash while copying big files since kernel 3.18
References: <54AA3953.20603@gmail.com> <54AAC925.6050602@lwfinger.net> <54AADC22.9050105@gmail.com> <54AAE532.6050104@lwfinger.net> <54B28A3F.3000904@gmail.com> <54B2AC1B.8030107@lwfinger.net> <54C54642.7000108@gmail.com>
In-Reply-To: <54C54642.7000108@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2015 01:38 PM, François Valenduc wrote:
> Le 11/01/15 18:00, Larry Finger a écrit :
>> On 01/11/2015 08:35 AM, François Valenduc wrote:
>>> Do you still intend to remove the line about allocation failure in the
>>> log ? I made a backup of my root partition compressed with pixz and that
>>> line appeared 1350 times. So I removed the code which add this line. Is
>>> it really expected that it occurs so often ? pixz use multithreading to
>>> compress files and therefore at least 3 of the 4 CPU are used during
>>> around 20 minutes, but are you sure there is no other problems ?
>>
>> Yes, I do intend to remove that line; however, I want to keep it for a
>> while just in case there are other crashes. If this message never
>> appears in that case, then there is another bug.
>>
>> You are, of course, free to remove it from your system. BTW, how much
>> memory do you have?
>>
>> Larry
>>
>>
> Sorry for having forgotten to answer. I have 4 Gb of RAM. Taking a
> backup of a DVD with k9copy also produces so much messages (1479 with a
> patch using rate_limit).
> Is it really expected that skb allocation fails so often ? Could there
> be another problem ?

It is a matter of memory fragmentation. The driver uses a 9100-byte buffer, thus 
the allocation is of order 3. After a system has been running for a while, the 
number of memory blocks of that size may be small. I have not looked at the 
source of k9copy, but I suspect it also allocates large buffers. On a 4G system, 
both DMA and regular allocations come from the same pool of memory.

I have submitted a patch to remove the printout. You should drop it from your 
system.

I am considering a slightly different approach to skb allocation that would 
pre-allocate a number of buffers in a storage pool when the driver was started. 
When the interrupt routine needed one, it would extract it from the pool, which 
would be kept refilled by a work queue routine. If and when I prepare that 
patch, your workload would be a good test. When you used k9copy, was the DVD 
driver local and the destination remote, or were both local? If the latter, you 
are just suffering from memory starvation.

Larry


