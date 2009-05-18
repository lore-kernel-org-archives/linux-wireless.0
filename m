Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:34142
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZERAOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 20:14:17 -0400
Message-ID: <4A10A5C0.7090107@erley.org>
Date: Sun, 17 May 2009 20:03:12 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Subject: Re: compile error compat-wireless
References: <4A0FF4FE.1030304@tls-tautenburg.de> <3ace41890905171600i3308f799n2a643e61fd954d4f@mail.gmail.com>
In-Reply-To: <3ace41890905171600i3308f799n2a643e61fd954d4f@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Sun, May 17, 2009 at 12:29 PM, Bringfried Stecklum
> <stecklum@tls-tautenburg.de> wrote:
>> When trying to compile the latest compat-wireless package on an Ubuntu 8.10
>> 64bit system running linux kernel 2.6.27-12 I get the following error
>>
>> stecklum@extragalactix:~/System/src/compat-wireless-2009-05-17$ make
>> ...
> 
> You have missed some important info here. - most likely you don't have
> the kernel header package installed.
> 
>>  CC [M]
>>  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/tx.o
>>  CC [M]
>>  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o
>> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c: In
>> function ‘ieee80211_key_alloc’:
>> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:326:
>> error: implicit declaration of function ‘get_unaligned_le32’
>> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:328:
>> error: implicit declaration of function ‘get_unaligned_le16’
>> make[3]: ***
>> [/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o]
>> Error 1
>> make[2]: ***
>> [/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211] Error 2
>> make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-05-17]
>> Error 2
>> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
>> make: *** [modules] Error 2
>>
>> Regards,
>>
>>        Bringfried
> 
> 
> Those two are defined in
> <kernel_source>/include/linux/unaligned/le_byteshift.h since about
> 2.6.26, I just checked.
> 
> make sure  /lib/modules/<kernel_ver>/source/ points to some kernel
> source tree (you probably need to install some package called
> kernel-dev or linux-dev).
> 


I got this as well, fixed it by adding #include <asm/unaligned.h> to key.c

I have been running compat-wireless for months, so it's not a missing package
thing, I suspect it's an outdated headers thing.  My system has 2.6.27 headers
right now.

Pat Erley
