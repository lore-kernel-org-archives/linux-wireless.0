Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:36885 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZCSTAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:00:48 -0400
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-Id: <2CE6D71C-6DB5-41F2-8FFD-C013DC2B9AF6@ing.unibs.it> (sfid-20090319_200050_510691_C6E776D4)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200903191927.21868.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 20:00:45 +0100
References: <200903191927.21868.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 19, 2009, at 7:27 PM, Michael Buesch wrote:

> This masks the PHY TX error interrupt, if debugging is disabled.
>
> Currently we have a bug somewhere which triggers this interrupt once
> in a while. (Depends on the network noise/quality). While this is  
> nonfatal,
Michael,

some time ago I begin seeing several of these errors, never seen  
before on one of my host, with both proprietary and open firmwares. As  
I never noticed those errors before, I wondered if they could be due  
to some strange frame received by air, something like a frame encoded  
in CCK but with a broken field that caused the firmware to ack back a  
frame whose first byte (encoding) didn't match the following inside  
the plcp. That was obviously not the case, indeed those errors were  
not even happening on tx tries and surprisingly they were happening  
also on devices configured in monitor mode.

I finally remembered that the day before starting observing errors, I  
changed the minipci to pci adapter inside that host, maintaining the  
same cable and antenna set. Removing the broken adapter stopped PHY  
errors.

After this debug session I have some notes
- PHY error IRQs are not triggered by the firmware (both open and  
proprietary) by writing to the IRQ registers
- these strange PHY errors are not due to tx tries, they happen also  
with devices were the tx code has been cut away
- PHY errors are triggered by the hardware when the number of bytes  
requested for transmission do not match the tx information stored in  
the first four bytes of the plcp, this happens for both frames sent by  
b43 through dma and frames composed by the firmware. If everything is  
consistent I never see errors on platforms not affected by noise (as  
my old VIA or the broken minipci to pci adapter).

I would say this noise directly affects the irq line, or it triggers  
the serializer to send out a packet with completely wrong radio/plcp/ 
mac configuration that causes a PHY tx error.

Cheers,
-FG
>
> it scares the hell out of users and we frequently receive bugreports
> that incorrectly identify this error message as the reason.
>
> There's another problem with this. The PHY TX error interrupt is  
> protected
> with a watchdog that will restart the device if it keeps triggering  
> very often.
> This is used to fix interrupt storms from completely broken devices.
>
> However, this watchdog might trigger in completely normal operation.
> If the TX capacity of the card is saturated, the likeliness of the  
> watchdog
> triggering increases, as more TX errors occur. The current threshold
> for the watchdog is 1000 errors in 15 seconds.
>
> This patch adds a workaround for the issue by just enabling the  
> interrupt
> if debugging is disabled (by Kconfig or by modparam).
>
> This has the downside that real fatal PHY TX errors are not caught  
> anymore.
> But this is nonfatal due to the following reasons:
> * If the card is not able to transmit anymore, MLME will notice  
> anyway.
> * I did _never_ see a real fatal PHY TX error in a mainline b43  
> driver.
> * It does _not_ result in interrupt storms or something like that.
>  It will simply result in a stalled card. It can be debugged by  
> enabling
>  the debugging module parameter.
>
> Signed-off-by: Michael Buesch <mb@bu3sch>
>
> ---
>
> I wonder how much placebo "PHY TX error was fixed and my card  
> performs great again"
> we will get. :D
>
> !!! DISTRIBUTIONS !!!
> Disable CONFIG_B43_DEBUG!
> There is absolutely _no_ reason to enable it on a release kernel.
> There were valid reasons in the past, but there are none left anymore.
> So please _disable_ this option now, if you didn't do this already,
> because with CONFIG_B43_DEBUG enabled the PHY TX errors will still  
> show.
>
>
>
> John, please merge this for the next feature release.
>
>
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-03-19  
> 17:27:39.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2009-03-19  
> 18:53:16.000000000 +0100
> @@ -3990,12 +3990,14 @@ static void setup_struct_wldev_for_init(
> 	setup_struct_phy_for_init(dev, &dev->phy);
>
> 	/* IRQ related flags */
> 	dev->irq_reason = 0;
> 	memset(dev->dma_reason, 0, sizeof(dev->dma_reason));
> 	dev->irq_savedstate = B43_IRQ_MASKTEMPLATE;
> +	if (b43_modparam_verbose < B43_VERBOSITY_DEBUG)
> +		dev->irq_savedstate &= ~B43_IRQ_PHY_TXERR;
>
> 	dev->mac_suspended = 1;
>
> 	/* Noise calculation context */
> 	memset(&dev->noisecalc, 0, sizeof(dev->noisecalc));
> }
>
> -- 
> Greetings, Michael.
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli




