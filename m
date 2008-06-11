Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:39874 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbYFKSvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 14:51:45 -0400
Received: by yx-out-2324.google.com with SMTP id 31so372808yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 11:51:44 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] next-20080611 rt2x00: build failure
Date: Wed, 11 Jun 2008 21:03:58 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-next@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20080611100748.d35829f4.randy.dunlap@oracle.com> <20080611181000.GA32331@tuxdriver.com>
In-Reply-To: <20080611181000.GA32331@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806112103.58517.IvDoorn@gmail.com> (sfid-20080611_205222_686999_7601DAAA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 June 2008, John W. Linville wrote:
> On Wed, Jun 11, 2008 at 10:07:48AM -0700, Randy Dunlap wrote:
> > when CONFIG_INPUT=n and
> > # CONFIG_NEW_LEDS is not set
> > CONFIG_LEDS_CLASS=y
> > 
> > (full config attached)
> > 
> > vmlinux.o: In function `iwl_rfkill_unregister':
> > (.text+0x174cdc): undefined reference to `input_unregister_device'
> > vmlinux.o: In function `iwl_rfkill_init':
> > (.text+0x174d9f): undefined reference to `input_allocate_device'
> > vmlinux.o: In function `iwl_rfkill_init':
> > (.text+0x174e2d): undefined reference to `input_register_device'
> > vmlinux.o: In function `iwl_rfkill_init':
> > (.text+0x174e53): undefined reference to `input_free_device'
> > vmlinux.o: In function `rt2x00rfkill_allocate_polldev':
> > rt2x00rfkill.c:(.text+0x176dc4): undefined reference to `input_allocate_polled_device'
> > vmlinux.o: In function `rt2x00rfkill_poll':
> > rt2x00rfkill.c:(.text+0x176e8b): undefined reference to `input_event'
> > rt2x00rfkill.c:(.text+0x176e9f): undefined reference to `input_event'
> 
> <snip>
> 
> Ick, what a mess...
> 
> So what combination of depends and select of INPUT, INPUT_POLLDEV,
> and RFKILL_INPUT do we need to resolve this?

Well RFKILL_INPUT shouldn't be selected by a driver, in fact any driver that
selects or depends on RFKILL_INPUT is wrong. But selecting it only makes
matters worse since that will bypass the INPUT dependency.
When INPUT_POLLDEV is required I guess it is best to depend on INPUT and
select INPUT_POLLDEV.

iwlwifi is selecting RFKILL_INPUT and preferably they should drop the select
altogether (not replacing it with a depend), but since I am not sure about the
reason for the select

rt2x00 is selecting INPUT_POLLDEV but should depend on INPUT first (as done
in the patch in my previous mail).

b43 shouldn't really depend on RFKILL_INPUT but their Kconfig is correct and
shouldn't cause the above build failure.

Ivo
