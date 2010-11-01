Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50466 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0KAQoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 12:44:37 -0400
Received: by iwn10 with SMTP id 10so7222842iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 09:44:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin1oXb8mkyxZgn5jEy7FJF9BPpiuJ1Q7j9XCDYz@mail.gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
 <8762whrqvm.fsf@gmail.com> <AANLkTin1oXb8mkyxZgn5jEy7FJF9BPpiuJ1Q7j9XCDYz@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Nov 2010 09:44:15 -0700
Message-ID: <AANLkTimBf6PRdTNUpx1HLu6Q70onHi3YhqKOYQ2Rk-yF@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
To: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: Ben Gamari <bgamari@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/1 Björn Smedman <bjorn.smedman@venatech.se>:
> On Mon, Nov 1, 2010 at 4:43 PM, Ben Gamari <bgamari@gmail.com> wrote:
>> On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
>>> Hi all,
>>>
>>> I have an application that creates and destroys a lot of ap vifs and
>>> does a lot of monitor frame injection. The recent ath9k rx locking
>>> fixes have helped with stability in this use-case but there still
>>> seems to be some tx/beacon related race condition(s). These manifests
>>> themselves as follows on an AR913x based router running
>>> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
>>>
>>> 1. TX DMA hangs under simultaneous high RX and TX load
>>> 2. TX is completely hung but chip is never reset
>>
>> I have also observed both of these behaviors with just a standard
>> hostapd single VIF configuration. Quite annoying. It seems to be better
>> with recent wireless-testing trees.
>>
>> - Ben
>
> The next thing that looks racy to me is ath_beacon_alloc() vs
> ath_beacon_tasklet() in beacon.c. Beacon queue TX DMA is always
> stopped in main.c before calling ath_beacon_alloc() but
> ath_beacon_tasklet() is scheduled when we get an SWBA interrupt. My
> guess is that these keep coming even if we stop TX DMA on the beacon
> queue, no?

My TX PCU patches for ath9k are not merged yet, try those or wait
until John merges them.

  Luis
