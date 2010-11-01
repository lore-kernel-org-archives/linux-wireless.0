Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39429 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0KAQju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 12:39:50 -0400
Received: by gyg4 with SMTP id 4so3292175gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 09:39:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8762whrqvm.fsf@gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
	<8762whrqvm.fsf@gmail.com>
Date: Mon, 1 Nov 2010 17:39:49 +0100
Message-ID: <AANLkTin1oXb8mkyxZgn5jEy7FJF9BPpiuJ1Q7j9XCDYz@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Gamari <bgamari@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 4:43 PM, Ben Gamari <bgamari@gmail.com> wrote:
> On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
>> Hi all,
>>
>> I have an application that creates and destroys a lot of ap vifs and
>> does a lot of monitor frame injection. The recent ath9k rx locking
>> fixes have helped with stability in this use-case but there still
>> seems to be some tx/beacon related race condition(s). These manifests
>> themselves as follows on an AR913x based router running
>> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
>>
>> 1. TX DMA hangs under simultaneous high RX and TX load
>> 2. TX is completely hung but chip is never reset
>
> I have also observed both of these behaviors with just a standard
> hostapd single VIF configuration. Quite annoying. It seems to be better
> with recent wireless-testing trees.
>
> - Ben

The next thing that looks racy to me is ath_beacon_alloc() vs
ath_beacon_tasklet() in beacon.c. Beacon queue TX DMA is always
stopped in main.c before calling ath_beacon_alloc() but
ath_beacon_tasklet() is scheduled when we get an SWBA interrupt. My
guess is that these keep coming even if we stop TX DMA on the beacon
queue, no?

/Björn
