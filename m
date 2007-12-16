Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53077 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbXLPRTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 12:19:53 -0500
Message-ID: <47655E26.2040309@lwfinger.net> (sfid-20071216_171955_659879_D85B5EF0)
Date: Sun, 16 Dec 2007 09:19:34 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: b43 problem with led trigger registration
References: <1197822019.4138.2.camel@johannes.berg>
In-Reply-To: <1197822019.4138.2.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi,
> 
> Just booted into my shiny new #everything and got:
> 
> [   40.209739] BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> [   40.220119] in_atomic():1, irqs_disabled():0
> [   40.230514] Call Trace:
> [   40.240799] [eec2fc90] [c0009198] show_stack+0x4c/0x1ac (unreliable)
> [   40.251247] [eec2fcd0] [c0027a3c] __might_sleep+0xd0/0xf0
> [   40.261620] [eec2fce0] [c004c1d0] down_write+0x24/0x64
> [   40.271974] [eec2fcf0] [c026347c] led_trigger_register+0xbc/0x118
> [   40.282273] [eec2fd10] [f250246c] ieee80211_led_init+0x68/0x160 [mac80211]
> [   40.292837] [eec2fd30] [f24eceb0] ieee80211_register_hw+0x200/0x324 [mac80211]
> [   40.303295] [eec2fd40] [f2523234] b43_probe+0x9a8/0xa04 [b43]
> [   40.313766] [eec2fda0] [f20b06e8] ssb_device_probe+0x50/0xac [ssb]
> [   40.324152] [eec2fdb0] [c0214518] driver_probe_device+0xb8/0x1e8
> [   40.334541] [eec2fdd0] [c021487c] __driver_attach+0xf8/0x124
> [   40.344833] [eec2fdf0] [c0213674] bus_for_each_dev+0x58/0x94
> [   40.355100] [eec2fe20] [c0214328] driver_attach+0x24/0x34
> [   40.365321] [eec2fe30] [c0213af4] bus_add_driver+0x98/0x208
> [   40.375513] [eec2fe50] [c0214b44] driver_register+0x58/0xa0
> [   40.385771] [eec2fe60] [f20aff58] __ssb_driver_register+0x2c/0x3c [ssb]
> [   40.396017] [eec2fe70] [f103e034] b43_init+0x34/0xe8 [b43]
> [   40.406253] [eec2fe80] [c00587e4] sys_init_module+0x154/0x176c
> [   40.416498] [eec2ff40] [c0012054] ret_from_syscall+0x0/0x38
> 
> I haven't found yet where the atomic is entered...

Is your system "vanilla" wireless-2.6, or does it include the LED switch patch 
(http://marc.info/?l=linux-wireless&m=119763729709783&w=2)?

Larry
