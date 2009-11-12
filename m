Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:55432 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZKLWQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:16:30 -0500
Received: by fxm21 with SMTP id 21so2794094fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local> <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 23:16:09 +0100
Message-ID: <40101cc30911121416o333f32c1h3e26b4cc988c243f@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 8:35 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Nov 12, 2009 at 11:31 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2009-11-12 at 20:18 +0100, Matteo Croce wrote:
>>
>>> # echo scan >/sys/kernel/debug/kmemleak ; cat
>>> /sys/kernel/debug/kmemleak
>>> kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>>> unreferenced object 0xc5cfea80 (size 192):
>>>   comm "softirq", pid 0, jiffies 14191
>>>   backtrace:
>>>     [<ffffffff>] 0xffffffff
>>
>> that's kinda useless, can you run
>
> But if you insist on using kmemleak, try clearing the list
>
> echo clear > kmemleak
>
> Then scan
>
> echo scan > kmemleak
>
> then run your frame injection tests and then re-run scan.
>
> echo scan > kmemleak
>
> Then paste the output here.
>
>  Luis
>

root@alix:/sys/kernel/debug# rmmod inject
inject_exit Inject, exiting module
root@alix:/sys/kernel/debug# echo clear > kmemleak
root@alix:/sys/kernel/debug# echo scan >kmemleak
kmemleak: 61037 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
root@alix:/sys/kernel/debug# modprobe inject
inject_init Inject, inserting module
inject_init Inject, initializing the timer
root@alix:/sys/kernel/debug# echo scan >kmemleak
root@alix:/sys/kernel/debug# cat kmemleak
unreferenced object 0xccd48e70 (size 64):
  comm "softirq", pid 0, jiffies 3615
  hex dump (first 32 bytes):
    20 89 ed ce b9 83 d2 00 00 00 01 1b 00 80 00 04   ...............
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcd6f7930 (size 64):
  comm "softirq", pid 0, jiffies 11486
  hex dump (first 32 bytes):
    20 89 ed ce 6a a3 83 05 00 00 01 1b 00 80 00 04   ...j...........
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcbe57c40 (size 64):
  comm "softirq", pid 0, jiffies 28666
  hex dump (first 32 bytes):
    20 89 ed ce cc 52 c1 0f 00 00 01 1b 00 80 00 04   ....R..........
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcbe71850 (size 64):
  comm "softirq", pid 0, jiffies 28981
  hex dump (first 32 bytes):
    20 89 ed ce c9 64 f1 0f 00 00 01 1b 00 80 00 04   ....d..........
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcbe71f50 (size 64):
  comm "softirq", pid 0, jiffies 30041
  hex dump (first 32 bytes):
    20 89 ed ce 4a 26 93 10 00 00 01 1b 00 80 00 04   ...J&..........
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcb4b0230 (size 64):
  comm "softirq", pid 0, jiffies 35770
  hex dump (first 32 bytes):
    20 89 ed ce 79 66 fd 13 00 00 01 1b 00 80 00 04   ...yf..........
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xcb4b02a0 (size 64):
  comm "softirq", pid 0, jiffies 35771
  hex dump (first 32 bytes):
    20 89 ed ce b1 8d fd 13 00 00 01 1b 00 80 00 04   ...............
    00 00 00 80 80 80 80 80 80 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff>] 0xffffffff
