Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13812 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab0BNBgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:36:36 -0500
Subject: Re: [PATCH 2/3] rt2x00: Reorganize RT chipset setting for PCI/SOC
 devices.
From: Pavel Roskin <proski@gnu.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <201002140215.14535.IvDoorn@gmail.com>
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
	 <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
	 <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
	 <201002140215.14535.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Feb 2010 20:36:15 -0500
Message-Id: <1266111375.32423.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-02-14 at 02:15 +0100, Ivo van Doorn wrote:
> Hi,
> 
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -40,6 +40,9 @@
> >  #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
> >  #include "rt2x00usb.h"
> >  #endif
> > +#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
> > +#include "rt2x00pci.h"
> > +#endif
> 
> this is very ugly, but apparently it is unavoidable to make rt2800lib free from
> PCI and USB specific code... :(

I was about to write about a related issue.  My kernel configuration
only enables rt2800pci and rt73 drivers.  lsmod shows that rt2800lib
depends on rt2x00usb:

# lsmod 
Module                  Size  Used by
rt2800pci               9767  0 
rt2800lib              24194  1 rt2800pci
rt2x00usb               9474  1 rt2800lib
rt2x00pci               5993  1 rt2800pci
crc_ccitt               1445  1 rt2800pci
rt2x00lib              27776  4 rt2800pci,rt2800lib,rt2x00usb,rt2x00pci
mac80211              215322  3 rt2x00usb,rt2x00pci,rt2x00lib
cfg80211              144471  2 rt2x00lib,mac80211
eeprom_93cx6            1520  1 rt2800pci

To be clear, the above dependency was not introduced by the patch.  It
would be nice to straighten it eventually.  Maybe the rt2800lib code
should look whether rt2800 (not the generic rt2x00) has USB or PCI
enabled, both for function calls and for includes.

But I'm happy that rt2800pci is working at all!  It was my first chance
to test it.

-- 
Regards,
Pavel Roskin
