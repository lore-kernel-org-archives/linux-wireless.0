Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39591 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752049AbYGIG6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 02:58:05 -0400
Message-ID: <48746177.8040903@gmx.de> (sfid-20080709_085808_780844_E9B2F883)
Date: Wed, 09 Jul 2008 08:57:59 +0200
From: Helge Deller <deller@gmx.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: convert LED code to use mac80211 triggers
References: <20080622181134.GA26571@hash.localnet> <20080626023528.GA16068@hash.localnet> <20080709024053.GA3715@hash.localnet>
In-Reply-To: <20080709024053.GA3715@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> I wrote:
>> I guess the conservative approach is to just use sc->led_on = 1 in the
>> VENDOR_ID_COMPAQ branch
> 
> ...here's the obvious patch for this, let me know if it works for you.

Thanks Bob!
Patch works OK.

Helge

> Subject: [PATCH] ath5k: use positive logic for HP laptop LEDs
> 
> Helge Deller reports that HP laptops (NC4010 and NC6000) use active-
> high signals to turn on the LEDs.  Previous code used active-low for
> all devices.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index a43e9b2..fb6fd14 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2551,8 +2551,6 @@ ath5k_init_leds(struct ath5k_softc *sc)
>  	struct pci_dev *pdev = sc->pdev;
>  	char name[ATH5K_LED_MAX_NAME_LEN + 1];
>  
> -	sc->led_on = 0;  /* active low */
> -
>  	/*
>  	 * Auto-enable soft led processing for IBM cards and for
>  	 * 5211 minipci cards.
> @@ -2561,11 +2559,13 @@ ath5k_init_leds(struct ath5k_softc *sc)
>  	    pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
>  		__set_bit(ATH_STAT_LEDSOFT, sc->status);
>  		sc->led_pin = 0;
> +		sc->led_on = 0;  /* active low */
>  	}
>  	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
>  	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
>  		__set_bit(ATH_STAT_LEDSOFT, sc->status);
>  		sc->led_pin = 1;
> +		sc->led_on = 1;  /* active high */
>  	}
>  	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>  		goto out;

