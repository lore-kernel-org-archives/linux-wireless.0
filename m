Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2857 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbYFKSdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 14:33:17 -0400
Date: Wed, 11 Jun 2008 14:10:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
Subject: Re: next-20080611 rt2x00: build failure
Message-ID: <20080611181000.GA32331@tuxdriver.com> (sfid-20080611_203323_451779_5E118B85)
References: <20080611100748.d35829f4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080611100748.d35829f4.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 10:07:48AM -0700, Randy Dunlap wrote:
> when CONFIG_INPUT=n and
> # CONFIG_NEW_LEDS is not set
> CONFIG_LEDS_CLASS=y
> 
> (full config attached)
> 
> vmlinux.o: In function `iwl_rfkill_unregister':
> (.text+0x174cdc): undefined reference to `input_unregister_device'
> vmlinux.o: In function `iwl_rfkill_init':
> (.text+0x174d9f): undefined reference to `input_allocate_device'
> vmlinux.o: In function `iwl_rfkill_init':
> (.text+0x174e2d): undefined reference to `input_register_device'
> vmlinux.o: In function `iwl_rfkill_init':
> (.text+0x174e53): undefined reference to `input_free_device'
> vmlinux.o: In function `rt2x00rfkill_allocate_polldev':
> rt2x00rfkill.c:(.text+0x176dc4): undefined reference to `input_allocate_polled_device'
> vmlinux.o: In function `rt2x00rfkill_poll':
> rt2x00rfkill.c:(.text+0x176e8b): undefined reference to `input_event'
> rt2x00rfkill.c:(.text+0x176e9f): undefined reference to `input_event'

<snip>

Ick, what a mess...

So what combination of depends and select of INPUT, INPUT_POLLDEV,
and RFKILL_INPUT do we need to resolve this?

-- 
John W. Linville
linville@tuxdriver.com
