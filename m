Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:39257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbXGWBrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 21:47:51 -0400
Date: Mon, 23 Jul 2007 11:42:10 +1000
From: David Gibson <hermes@gibson.dropbear.id.au>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option for Prism2
Message-ID: <20070723014210.GB3272@localhost.localdomain>
References: <20070722131751.GA3009@void.cube.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070722131751.GA3009@void.cube.gr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 22, 2007 at 04:17:51PM +0300, Faidon Liambotis wrote:
> Since v2.6.14, Prism 2/2.5/3 devices are better supported using the HostAP
> driver, which was made to work with these exclusively.
> Having the same IDs supported by orinoco too confuses users who have both
> drivers compiled in or as modules who expect hostap to drive the device.
> 
> Telling users to echo to /sys/bus/pci/drivers/*/unbind and bind is not
> exactly user-friendly.
> 
> Create an option to disable support for Prism devices in orinoco driver which
> disabled the IDs for the PCMCIA module and creates a Kconfig dependency for
> the Prism PCI modules.

I very much dislike this being a compile time only CONFIG option.  A
module parameter which enables or disables the device IDs would be
much nicer, if possible.  It can default to off (orinoco will not
claim Prism cards).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
