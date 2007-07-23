Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:51041 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXGWGKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2007 02:10:45 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1ICr9S-0005tN-PV
	for linux-wireless@vger.kernel.org; Mon, 23 Jul 2007 02:12:14 -0400
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
From: Pavel Roskin <proski@gnu.org>
To: David Gibson <hermes@gibson.dropbear.id.au>
Cc: Faidon Liambotis <paravoid@debian.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070723014210.GB3272@localhost.localdomain>
References: <20070722131751.GA3009@void.cube.gr>
	 <20070723014210.GB3272@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 02:10:40 -0400
Message-Id: <1185171040.2108.46.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-07-23 at 11:42 +1000, David Gibson wrote:
> > Create an option to disable support for Prism devices in orinoco driver which
> > disabled the IDs for the PCMCIA module and creates a Kconfig dependency for
> > the Prism PCI modules.
> 
> I very much dislike this being a compile time only CONFIG option.  A
> module parameter which enables or disables the device IDs would be
> much nicer, if possible.  It can default to off (orinoco will not
> claim Prism cards).

I'm afraid it's not possible.  There is only one device map in the
driver, and it's read by depmod to generate module map tables.

If the run-time device table is different from the compile-time table,
this would be really confusing.  Either the module would be loaded to
support the device but would refuse to do so, or the module would need
to be loaded manually for some devices, even if no other module is
available to support the device.

Besides, orinoco_pci would become useless by default.

Please see my message.  For TMD bridges, we don't know the firmware
flavor before we know the firmware version.  For PLX bridges, we can
read the CIS first and match the PCMCIA table, but it would need to be
done manually, without the PCMCIA code.

I don't see any clear solution without some kind of the device handover
from Orinoco to hostap or vice versa.

I would probably start with cutting Agere and Symbol devices from
hostap, which is a much more clear-cut case than cutting working Prism
support from Orinoco.

-- 
Regards,
Pavel Roskin

