Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58415 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZFGPaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:30:15 -0400
Subject: Re: pull request: wireless-next-2.6 2009-06-04
From: Marcel Holtmann <marcel@holtmann.org>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4A2BD8A5.4040302@hartkopp.net>
References: <20090604152011.GC2839@tuxdriver.com>
	 <20090607.033751.191866033.davem@davemloft.net>
	 <4A2BCC41.1060508@hartkopp.net> <20090607145830.GA2736@tuxdriver.com>
	 <4A2BD8A5.4040302@hartkopp.net>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 17:29:43 +0200
Message-Id: <1244388583.23850.87.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oliver,

> >>>> Hopefully this is (almost?) the last wireless pull request for
> >>>> non-bugfix patches intended for 2.6.31...
> >>>>
> >> (..)
> >>
> >>>> Please let me know if there are problems!
> >>> Pulled into net-next-2.6 and I'll push it back out to kernel.org
> >>> after some build testing.
> >> Hi John,
> >>
> >> after pulling the latest net-next-2.6 i got this warning which is probably
> >> caused by CONFIG_RFKILL=m in my config:
> >>
> >> hartko@vwagwolkf320:~/net-next-2.6$ make oldconfig
> >> scripts/kconfig/conf -o arch/x86/Kconfig
> >> .config:614:warning: symbol value 'm' invalid for RFKILL_INPUT
> > 
> > That functionality is no longer available as a module.  If you need
> > it, then select Y.
> 
> Just some additional nitpicking:
> 
> You should update net/rfkill/Kconfig as it still allows a tristate selection
> for RFKILL and the comment "To compile this driver as a module ..." should be
> removed also.

compiling RFKILL itself as a module is still working perfectly fine. It
is just the RFKILL_INPUT that can't be built as a module anymore. That
part was pointless anyway. And in the future RFKILL_INPUT will go away
and be replaced by a userspace implementation with proper support for
platform specific policies.

Regards

Marcel


