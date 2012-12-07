Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46984 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789Ab2LGJYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 04:24:07 -0500
Message-ID: <1354872204.6234.92.camel@cumari.coelho.fi> (sfid-20121207_102411_882893_81D09A6B)
Subject: Re: [PATCH 11/20] wlcore/wl18xx: change priority calculations for
 links
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 7 Dec 2012 11:23:24 +0200
In-Reply-To: <1354095769-8724-12-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-12-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> Update the 18xx FW status private part to include Tx related link
> priorities. Introduce new HW ops to determine link priority per chip
> family.
> 
> For 18xx the changes are:
> - Suspended links are at most low priority and Tx for them is stopped
>   beyond the suspend threshold.
> - Active links now get their thresholds directly from FW
> - There's a new "stop" threshold for active links, at which point a link
>   stops receiving new packets.
> 
> Update the min 18xx FW version required to make sure suspended links
> bitmap is advertised by the FW.

This doesn't apply anymore, I'll remove it.


> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Otherwise this patch looks good!

Just to understand better, why is the firmware deciding on the
thresholds? Does it make some internal magic itself to know the number
of links (including multi-channel) and adjust the thresholds
accordingly? Isn't this something we could (or should?) do in the kernel
side?

--
Luca

