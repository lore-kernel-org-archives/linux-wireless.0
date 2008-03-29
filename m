Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35115 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYC2Uty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 16:49:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Add PIO support for PCMCIA devices
Date: Sat, 29 Mar 2008 21:49:11 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200803292101.16696.mb@bu3sch.de>
In-Reply-To: <200803292101.16696.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803292149.11953.mb@bu3sch.de> (sfid-20080329_204957_764663_8B0CFE55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 March 2008, Michael Buesch wrote:
> +# Data transfers to the device via PIO
> +# This is only needed on PCMCIA devices. All others can do DMA properly.
> +config B43_PIO
> +	bool
> +	depends on B43 && (B43_PCMCIA || B43_FORCE_PIO)
> +	default y
> +
>  config B43_NPHY
>  	bool "Pre IEEE 802.11n support (BROKEN)"
>  	depends on B43 && EXPERIMENTAL

Oh, this generates a tiny fuzz here, as I locally removed the && BROKEN from B43_NPHY.
I guess that's trivial to fix for you and I don't need to rediff without
that local patch applied before. :)

>  	---help---
>  	  Support for the IEEE 802.11n draft.
>  
