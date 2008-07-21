Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41594 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYGUVnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 17:43:11 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KL39t-0000rx-Gz
	for linux-wireless@vger.kernel.org; Mon, 21 Jul 2008 21:43:05 +0000
Received: from mnhm-590f7fe9.pool.einsundeins.de ([89.15.127.233])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 21:43:05 +0000
Received: from deller by mnhm-590f7fe9.pool.einsundeins.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 21:43:05 +0000
To: linux-wireless@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] ath5k: use positive logic for HP laptop LEDs
Date: Mon, 21 Jul 2008 23:42:58 +0200
Message-ID: <g62vt2$akl$1@ger.gmane.org> (sfid-20080721_234316_143940_4253C84E)
References: <20080715170716.GA5785@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob, I think your patch below somehow got truncated and you wanted to send
this patch ?
http://marc.info/?l=linux-wireless&m=121557127930799&w=2

Bob Copeland wrote:
> Helge Deller reports that HP laptops (NC4010 and NC6000) use active-
> high signals to turn on the LEDs.  Previous code used active-low for
> all devices.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> Other ath5k devs, any issues with this patch?  Thread here for
> reference:
> 
> http://marc.info/?l=linux-wireless&m=121555862316630&w=2
> 
>  drivers/net/wireless/ath5k/base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c index 217d506..3394b35 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2550,8 +2550,6 @@ ath5k_init_leds(struct ath5k_softc *sc)
>  struct pci_dev *pdev = sc->pdev;
>  char name[ATH5K_LED_MAX_NAME_LEN + 1];
>  
> -     sc->led_on = 0;  /* active low */


