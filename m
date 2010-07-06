Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:46818 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0GFBpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 21:45:14 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 05 Jul 2010 21:45:12 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Ohad Ben-Cohen <ohadb@ti.com>
Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
In-reply-to: <1278376666-3509-6-git-send-email-ohad@wizery.com>
Message-id: <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-6-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Jul 2010, Ohad Ben-Cohen wrote:

> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Add support for software emulation of card detect
> events.
> 
> This is required for specific controllers
> that are hard wired with embedded SDIO devices
> (such as TI's wl1271 WLAN device).

Why?

Many instances of hardwired SDIO based WLAN devices do exist already, 
and they don't need extra card detect events to be generated.  The core 
MMC code already triggers a probe for cards whenever a new host 
controller is registered.

> Board-specific configuration is required to
> enable this software card detect control.

Could you elaborate please?


Nicolas
