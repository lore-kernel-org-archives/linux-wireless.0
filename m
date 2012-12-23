Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4409 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LWRbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 12:31:31 -0500
Message-ID: <50D73FE1.6080907@broadcom.com> (sfid-20121223_183142_198310_2875F81C)
Date: Sun, 23 Dec 2012 18:31:13 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
cc: "Piotr Haber" <phaber@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: initialize morepending in brcms_b_recv()
References: <1356210434-28435-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1356210434-28435-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2012 10:07 PM, Geert Uytterhoeven wrote:
> drivers/net/wireless/brcm80211/brcmsmac/main.c: In function ‘brcms_b_recv’:
> drivers/net/wireless/brcm80211/brcmsmac/main.c:7636: warning: ‘morepending’ may be used uninitialized in this function
> 

Reading the code this warning seems to be invalid except when RXBND is
defined as zero, which would make the whole function totally bogus.
Would be good to have a WARN_ON(!RXBND) in brcms_b_attach().

I don't like pleasing a compiler with unnecessary initializers but I am
also for builds with zero warnings. So...

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 17594de..5f0f444 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -7633,7 +7633,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
>  
>  	uint n = 0;
>  	uint bound_limit = bound ? RXBND : -1;
> -	bool morepending;
> +	bool morepending = false;
>  
>  	skb_queue_head_init(&recv_frames);
>  


