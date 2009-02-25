Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gundega.hpl.hp.com ([192.6.19.190]:55553 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBYRYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 12:24:40 -0500
Date: Wed, 25 Feb 2009 09:24:02 -0800
From: Jean Tourrilhes <jt@hpl.hp.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] wireless, wavelan: spin off by 1
Message-ID: <20090225172402.GA21301@bougret.hpl.hp.com> (sfid-20090225_182444_134057_4F3103E9)
Reply-To: jt@hpl.hp.com
References: <49A53B16.8010605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49A53B16.8010605@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2009 at 01:35:34PM +0100, Roel Kluin wrote:
> spin can reach -1 after the loop, so 0 is still success.
> 

	You are probably technically right, but it does not matter in
practice. The chip should answer way faster than this timeout, and we
would loose only 0.1% of the overall timeout value. If the chip answer
was that close to the timeout, because of variation, we would fail
half the time and would need a bigger timeout anyway.
	A better way would be to not test spin, but to test the status
register itself. That way, it's less ambiguous.
	Anyway, such low level code is tricky, and I personally would
not want any change without thourough testing with the hardware. We
know the curent code work, and I don't have time to test, so I would
vote to not change the code.

	Regards,

	Jean


> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
> index de717f8..1565a0a 100644
> --- a/drivers/net/wireless/wavelan_cs.c
> +++ b/drivers/net/wireless/wavelan_cs.c
> @@ -838,9 +838,8 @@ wv_82593_cmd(struct net_device *	dev,
>      }
>    while(((status & SR3_EXEC_STATE_MASK) != SR3_EXEC_IDLE) && (spin-- > 0));
>  
> -  /* If the interrupt hasn't be posted */
> -  if(spin <= 0)
> -    {
> +  /* If the interrupt hasn't been posted */
> +  if (spin < 0) {
>  #ifdef DEBUG_INTERRUPT_ERROR
>        printk(KERN_INFO "wv_82593_cmd: %s timeout (previous command), status 0x%02x\n",
>  	     str, status);
