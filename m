Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64196 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaLJKaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 05:30:24 -0500
Message-ID: <548820B8.8020407@broadcom.com> (sfid-20141210_113031_408810_484E30A7)
Date: Wed, 10 Dec 2014 11:30:16 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: don't leak kernel memory via printk()
References: <1418204358-8357-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1418204358-8357-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-12-14 10:39, Brian Norris wrote:
> Debug code prints the fifo name via custom dev_warn() wrappers. The
> fifo_names array is only non-zero when debugging is manually enabled,
> which is all well and good. However, it's *not* good that this array
> uses zero-length arrays in the non-debug case, and so it doesn't
> actually have any memory allocated to it. This means that as far as we
> know, fifo_names[i] actually points to garbage memory.
> 
> I've seen this in my log:
> 
> [ 4601.205511] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211: �GeL txop exceeded phylen 137/256 dur 1602/1504
> 
> So let's give this array space enough to fill it with a NULL byte.
> 

+ Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Brett Rudley <brudley@broadcom.com>
- Cc: Arend van Spriel <arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list@broadcom.com
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 1b474828d5b8..aed0c948dce8 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -316,7 +316,7 @@ static const u16 xmtfifo_sz[][NFIFO] = {
>  static const char * const fifo_names[] = {
>  	"AC_BK", "AC_BE", "AC_VI", "AC_VO", "BCMC", "ATIM" };
>  #else
> -static const char fifo_names[6][0];
> +static const char fifo_names[6][1];
>  #endif
>  
>  #ifdef DEBUG
> 

