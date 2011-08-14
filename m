Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from app1b.xlhost.de ([213.202.242.162]:58927 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1HNIXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 04:23:02 -0400
Message-ID: <4E4785E1.5060000@kpanic.de> (sfid-20110814_102316_302325_4A9300E1)
Date: Sun, 14 Aug 2011 10:22:57 +0200
From: Stefan Assmann <sassmann@kpanic.de>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Oops in rtl8192ce when unloading the module
References: <4E465F79.5060205@kpanic.de> <20110814060015.GA13600@internetdog.org>
In-Reply-To: <20110814060015.GA13600@internetdog.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14.08.2011 08:00, Ali Bahar wrote:
> Hi Stefan,
> 
> it is _Larry_ who knows this code, of course. But, having browsed thru
> this for the first time,
> 
> 
> On Sat, Aug 13, 2011 at 01:26:49PM +0200, Stefan Assmann wrote:
>> 01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8176] (rev 01)
>>
>> This happens with 3.1.0-rc1
>>
>> modprobe -r rtl8192ce
>> [  450.710489] BUG: unable to handle kernel NULL pointer dereference at 0000000000000620
>> [  450.710505] IP: [<ffffffffa0224972>] rtl92ce_get_desc+0x53/0x96 [rtl8192ce]

[...]

> 
> this seems like a concurrency issue. Right when it is deregistering
> the IRQ handler, a packet is received. If so, then 
> 
> 1. it should not be reproducible on a quiet network eg when there is no
> data traffic && there are no APs around. (Or if you've wrapped the
> adapter in layers of foil! :-)
> 
> 2. it should be only intermittently reproducible otherwise.

Hi Ali,

I haven't wrapped it in foil yet, but what I can say is that I tried to
unload the module 5-6 times and it oopsed every single time.

  Stefan
