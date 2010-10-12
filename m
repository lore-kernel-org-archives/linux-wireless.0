Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:34293 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0JMNCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:02:20 -0400
Subject: Re: [PATCH v2 2/4] wl1271: Fix TX starvation
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286873633-10080-3-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
	 <1286873633-10080-3-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:34:05 +0300
Message-ID: <1286883245.11177.496.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 10:53 +0200, ext Ido Yariv wrote:
> While wl1271_irq_work handles RX directly (by calling wl1271_rx), a different
> work is scheduled for transmitting packets. The IRQ work might handle more than
> one interrupt during a single call, including multiple TX completion
> interrupts. This might starve TX, since no packets are transmitted until all
> interrupts are handled.
> 
> Fix this by calling the TX work function directly, instead of deferring
> it.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h      |    1 +
>  drivers/net/wireless/wl12xx/wl1271_main.c |   19 +++++++++++++++----
>  drivers/net/wireless/wl12xx/wl1271_tx.c   |   14 ++++++++++----
>  drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
>  4 files changed, 27 insertions(+), 8 deletions(-)
> 

Thanks for reworking this. This looks good to me now.

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

