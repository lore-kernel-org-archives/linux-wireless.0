Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46707 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZKLTSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:18:31 -0500
Received: by fxm21 with SMTP id 21so2610074fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:18:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 20:18:15 +0100
Message-ID: <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 4:49 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Nov 12, 2009 at 7:44 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Thu, Nov 12, 2009 at 06:18:46AM -0800, Matteo Croce wrote:
>>> On Thu, Nov 12, 2009 at 12:31 PM, Lorenzo Bianconi
>>> <lorenzo.bianconi83@gmail.com> wrote:
>>> > Hi all
>>> >
>>> > I am playing with ath9k/mac80211 in monitor mode and I suspect there
>>> > is a memory leak.
>>> > The leak happens when injecting in monitor mode when the destination
>>> > MAC address is unicast.
>>> > In fact there is no leak sending broadcast packet.
>>> > I wrote this minimal test case module which triggers the leak.
>>>
>>> I can reproduce it with ath5k but not with madwifi, so the leak could
>>> be in mac80211
>>
>> Can you please resend the thread to linux-wireless for wider review, with
>> the code snippet and all?

I have compiled a 2.6.31 x86 kernel with kmemleak, and when injecting
the memory goes rapidly down:

# while sleep 10; do free |grep Mem; done
  Mem:       127112        41780        85332            0          224
  Mem:       127112        42580        84532            0          224
  Mem:       127112        43360        83752            0          224
  Mem:       127112        44160        82952            0          224
  Mem:       127112        44960        82152            0          224
  Mem:       127112        48140        78972            0          224

just to be sure that any program is stoling RAM:

# ps
  PID USER       VSZ STAT COMMAND
    1 root       932 S    init
    2 root         0 SW<  [kthreadd]
    3 root         0 SW<  [ksoftirqd/0]
    4 root         0 SW<  [watchdog/0]
    5 root         0 SW<  [events/0]
    6 root         0 SW<  [khelper]
    9 root         0 SW<  [async/mgr]
   61 root         0 SW<  [kblockd/0]
   66 root         0 SW<  [ata/0]
   67 root         0 SW<  [ata_aux]
  107 root         0 SW   [khungtaskd]
  108 root         0 SW   [pdflush]
  109 root         0 SW   [pdflush]
  110 root         0 SW<  [kswapd0]
  111 root         0 SW<  [aio/0]
  112 root         0 SW<  [crypto/0]
  194 root         0 SW<  [scsi_eh_0]
  197 root         0 SW<  [scsi_eh_1]
  213 root         0 SWN  [kmemleak]
  369 root       936 R    /bin/ash --login
  505 root         0 SW<  [phy0]
 4369 root       932 S    init
 4371 root       924 R    ps

This time I'm using ath5k with an AR5212 card instead of ath9k, so the
leak definitely is in mac80211
This is what kmemleak reports:

# echo scan >/sys/kernel/debug/kmemleak ; cat
/sys/kernel/debug/kmemleak
kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
unreferenced object 0xc5cfea80 (size 192):
  comm "softirq", pid 0, jiffies 14191
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1a400 (size 1024):
  comm "softirq", pid 0, jiffies 14191
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7ac9e40 (size 192):
  comm "softirq", pid 0, jiffies 14192
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a05000 (size 1024):
  comm "softirq", pid 0, jiffies 14192
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7ac9d80 (size 192):
  comm "softirq", pid 0, jiffies 14193
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a04800 (size 1024):
  comm "softirq", pid 0, jiffies 14193
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7ac9c00 (size 192):
  comm "softirq", pid 0, jiffies 14194
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc707b800 (size 1024):
  comm "softirq", pid 0, jiffies 14194
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7ac9f00 (size 192):
  comm "softirq", pid 0, jiffies 14195
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a05400 (size 1024):
  comm "softirq", pid 0, jiffies 14195
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df480 (size 192):
  comm "softirq", pid 0, jiffies 14196
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1c000 (size 1024):
  comm "softirq", pid 0, jiffies 14196
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df540 (size 192):
  comm "softirq", pid 0, jiffies 14197
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1c800 (size 1024):
  comm "softirq", pid 0, jiffies 14197
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df3c0 (size 192):
  comm "softirq", pid 0, jiffies 14198
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1cc00 (size 1024):
  comm "softirq", pid 0, jiffies 14198
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df300 (size 192):
  comm "softirq", pid 0, jiffies 14199
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1d000 (size 1024):
  comm "softirq", pid 0, jiffies 14199
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df600 (size 192):
  comm "softirq", pid 0, jiffies 14200
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1d400 (size 1024):
  comm "softirq", pid 0, jiffies 14200
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df180 (size 192):
  comm "softirq", pid 0, jiffies 14201
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1d800 (size 1024):
  comm "softirq", pid 0, jiffies 14201
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df6c0 (size 192):
  comm "softirq", pid 0, jiffies 14202
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1dc00 (size 1024):
  comm "softirq", pid 0, jiffies 14202
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df780 (size 192):
  comm "softirq", pid 0, jiffies 14203
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a04400 (size 1024):
  comm "softirq", pid 0, jiffies 14203
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df0c0 (size 192):
  comm "softirq", pid 0, jiffies 14204
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a05800 (size 1024):
  comm "softirq", pid 0, jiffies 14204
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df000 (size 192):
  comm "softirq", pid 0, jiffies 14205
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6cb7800 (size 1024):
  comm "softirq", pid 0, jiffies 14205
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc69df840 (size 192):
  comm "softirq", pid 0, jiffies 14206
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d1c400 (size 1024):
  comm "softirq", pid 0, jiffies 14206
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d000c0 (size 192):
  comm "softirq", pid 0, jiffies 14207
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6cb9800 (size 1024):
  comm "softirq", pid 0, jiffies 14256
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14780 (size 192):
  comm "softirq", pid 0, jiffies 14257
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d24000 (size 1024):
  comm "softirq", pid 0, jiffies 14257
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14840 (size 192):
  comm "softirq", pid 0, jiffies 14258
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d24800 (size 1024):
  comm "softirq", pid 0, jiffies 14258
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14900 (size 192):
  comm "softirq", pid 0, jiffies 14259
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d24c00 (size 1024):
  comm "softirq", pid 0, jiffies 14259
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d149c0 (size 192):
  comm "softirq", pid 0, jiffies 14260
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d25000 (size 1024):
  comm "softirq", pid 0, jiffies 14260
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14a80 (size 192):
  comm "softirq", pid 0, jiffies 14261
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d25400 (size 1024):
  comm "softirq", pid 0, jiffies 14261
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14b40 (size 192):
  comm "softirq", pid 0, jiffies 14262
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d25800 (size 1024):
  comm "softirq", pid 0, jiffies 14262
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14c00 (size 192):
  comm "softirq", pid 0, jiffies 14263
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d25c00 (size 1024):
  comm "softirq", pid 0, jiffies 14263
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14cc0 (size 192):
  comm "softirq", pid 0, jiffies 14264
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a0fc00 (size 1024):
  comm "softirq", pid 0, jiffies 14264
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14d80 (size 192):
  comm "softirq", pid 0, jiffies 14265
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6a0f400 (size 1024):
  comm "softirq", pid 0, jiffies 14265
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14e40 (size 192):
  comm "softirq", pid 0, jiffies 14266
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7273800 (size 1024):
  comm "softirq", pid 0, jiffies 14266
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d14f00 (size 192):
  comm "softirq", pid 0, jiffies 14267
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7273c00 (size 1024):
  comm "softirq", pid 0, jiffies 14267
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6ca56c0 (size 192):
  comm "softirq", pid 0, jiffies 14268
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d24400 (size 1024):
  comm "softirq", pid 0, jiffies 14268
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6ca5540 (size 192):
  comm "softirq", pid 0, jiffies 14269
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6cb8400 (size 1024):
  comm "softirq", pid 0, jiffies 14269
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6ca50c0 (size 192):
  comm "softirq", pid 0, jiffies 14271
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc7272c00 (size 1024):
  comm "softirq", pid 0, jiffies 14271
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6ca5480 (size 192):
  comm "softirq", pid 0, jiffies 14272
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d26000 (size 1024):
  comm "softirq", pid 0, jiffies 14272
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6ca5180 (size 192):
  comm "softirq", pid 0, jiffies 14273
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5d26800 (size 1024):
  comm "softirq", pid 0, jiffies 14273
  backtrace:
    [<ffffffff>] 0xffffffff

and again:

# echo scan >/sys/kernel/debug/kmemleak ; cat /sys/kernel/debug/km
emleak
kmemleak: 20 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
unreferenced object 0xc586b540 (size 192):
  comm "softirq", pid 0, jiffies 18612
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc70c0800 (size 1024):
  comm "softirq", pid 0, jiffies 18612
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586b600 (size 192):
  comm "softirq", pid 0, jiffies 18613
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6d81800 (size 1024):
  comm "softirq", pid 0, jiffies 18613
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586b6c0 (size 192):
  comm "softirq", pid 0, jiffies 18614
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6b96800 (size 1024):
  comm "softirq", pid 0, jiffies 18614
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586b840 (size 192):
  comm "softirq", pid 0, jiffies 18615
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6b96000 (size 1024):
  comm "softirq", pid 0, jiffies 18615
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586b900 (size 192):
  comm "softirq", pid 0, jiffies 18616
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6b96c00 (size 1024):
  comm "softirq", pid 0, jiffies 18616
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586b9c0 (size 192):
  comm "softirq", pid 0, jiffies 18617
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc5886400 (size 1024):
  comm "softirq", pid 0, jiffies 18617
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586ba80 (size 192):
  comm "softirq", pid 0, jiffies 18618
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6b97400 (size 1024):
  comm "softirq", pid 0, jiffies 18618
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc586bb40 (size 192):
  comm "softirq", pid 0, jiffies 18619
  backtrace:
    [<ffffffff>] 0xffffffff
unreferenced object 0xc6baa400 (size 1024):
  comm "softirq", pid 0, jiffies 18619
  backtrace:
    [<ffffffff>] 0xffffffff
