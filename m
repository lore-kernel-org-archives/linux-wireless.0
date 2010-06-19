Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:39922 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0FSOhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jun 2010 10:37:55 -0400
Message-ID: <4C1CCDA3.40502@bu3sch.de>
Date: Sat, 19 Jun 2010 16:01:07 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Clarify logged message after fatal DMA error and
 switch to PIO mode
References: <4c1cc624.Whz955JR9XYzqjst%Larry.Finger@lwfinger.net> (sfid-20100619_152832_048688_17D51150)
In-Reply-To: <4c1cc624.Whz955JR9XYzqjst%Larry.Finger@lwfinger.net> (sfid-20100619_152832_048688_17D51150)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2010 03:29 PM, Larry Finger wrote:
> The message following fatal DMA errors fails to indicate properly that the
> driver has switched to PIO mode.
>
> Signed-off-by: Larry Finger<Larry.Finger@wfinger.net>
> ---
>
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -1804,7 +1804,7 @@ static void b43_do_interrupt_thread(stru
>   			       dma_reason[2], dma_reason[3],
>   			       dma_reason[4], dma_reason[5]);
>   			b43err(dev->wl, "This device does not support DMA "
> -			       "on your system. Please use PIO instead.\n");
> +			       "on your system. It will now be switched to PIO.\n");
>   			/* Fall back to PIO transfers if we get fatal DMA errors! */
>   			dev->use_pio = 1;
>   			b43_controller_restart(dev, "DMA error");
>

Ack.

But what's the current status of the debugging of the PCI-core code 
w.r.t DMA?

-- 
Greetings Michael.
