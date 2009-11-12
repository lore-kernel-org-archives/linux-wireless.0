Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32827 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZKLWhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:37:52 -0500
Received: by bwz27 with SMTP id 27so2798364bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:37:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091112222831.GC17000@tux>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local> <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
	<40101cc30911121416o333f32c1h3e26b4cc988c243f@mail.gmail.com>
	<20091112222831.GC17000@tux>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 23:37:37 +0100
Message-ID: <40101cc30911121437m695bbb04n71300093c3a6721f@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 11:28 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Nov 12, 2009 at 02:16:09PM -0800, Matteo Croce wrote:
>> On Thu, Nov 12, 2009 at 8:35 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Thu, Nov 12, 2009 at 11:31 AM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> >> On Thu, 2009-11-12 at 20:18 +0100, Matteo Croce wrote:
>> >>
>> >>> # echo scan >/sys/kernel/debug/kmemleak ; cat
>> >>> /sys/kernel/debug/kmemleak
>> >>> kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>> >>> unreferenced object 0xc5cfea80 (size 192):
>> >>>   comm "softirq", pid 0, jiffies 14191
>> >>>   backtrace:
>> >>>     [<ffffffff>] 0xffffffff
>> >>
>> >> that's kinda useless, can you run
>> >
>> > But if you insist on using kmemleak, try clearing the list
>> >
>> > echo clear > kmemleak
>> >
>> > Then scan
>> >
>> > echo scan > kmemleak
>> >
>> > then run your frame injection tests and then re-run scan.
>> >
>> > echo scan > kmemleak
>> >
>> > Then paste the output here.
>> >
>> >  Luis
>> >
>>
>> root@alix:/sys/kernel/debug# rmmod inject
>> inject_exit Inject, exiting module
>> root@alix:/sys/kernel/debug# echo clear > kmemleak
>
> I forgot you're on 2.6.31, clear stuff was added to kmemleak for 2.6.32.
>
>> root@alix:/sys/kernel/debug# echo scan >kmemleak
>> kmemleak: 61037 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>> root@alix:/sys/kernel/debug# modprobe inject
>> inject_init Inject, inserting module
>> inject_init Inject, initializing the timer
>> root@alix:/sys/kernel/debug# echo scan >kmemleak
>> root@alix:/sys/kernel/debug# cat kmemleak
>> unreferenced object 0xccd48e70 (size 64):
>
> What's 0xccd48e70 and friends? Can you enable debugging on your kernel?
>
>  Luis
>

Debugging is enabled but i guess it's a kernel module

root@alix:/usr/src/wireless-testing# gdb vmlinux
GNU gdb (GDB) 7.0-debian
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /usr/src/wireless-testing/vmlinux...done.
(gdb) l *0xccd48e70
No source file for address 0xccd48e70.
(gdb)
