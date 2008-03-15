Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57249 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYCOSPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 14:15:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] [RFT] b43legacy: fix bcm4303 crash
Date: Sat, 15 Mar 2008 19:14:51 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20080315190121.70edbfcd@morte> <20080315190836.5020b884@morte>
In-Reply-To: <20080315190836.5020b884@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803151914.51620.mb@bu3sch.de> (sfid-20080315_181608_465429_3025FE5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 March 2008 19:08:36 Stefano Brivio wrote:
> On Sat, 15 Mar 2008 19:01:21 +0100
> Stefano Brivio <stefano.brivio@polimi.it> wrote:
> 
> > This should fix an hard crash which happened upon driver loading on bcm4303
> > rev. 2 devices. The bug was originally reported here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=384981.
> > Please test.
> 
> Ehr, sure. :/ Here it comes:
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
> +++ wireless-testing/drivers/net/wireless/b43legacy/main.c
> @@ -3047,7 +3047,6 @@ static void b43legacy_wireless_core_exit
>  	}
>  
>  	ssb_device_disable(dev->dev, 0);
> -	ssb_bus_may_powerdown(dev->dev->bus);
>  }
>  
>  static void prepare_phy_data_for_init(struct b43legacy_wldev *dev)
> @@ -3214,7 +3213,6 @@ err_kfree_tssitbl:
>  err_kfree_lo_control:
>  	kfree(phy->lo_control);
>  	phy->lo_control = NULL;
> -	ssb_bus_may_powerdown(bus);
>  	B43legacy_WARN_ON(b43legacy_status(dev) != B43legacy_STAT_UNINIT);
>  	return err;
>  }
> @@ -3534,7 +3532,7 @@ static int b43legacy_wireless_core_attac
>  
>  	err = b43legacy_phy_versioning(dev);
>  	if (err)
> -		goto err_powerdown;
> +		goto out;
>  	/* Check if this device supports multiband. */
>  	if (!pdev ||
>  	    (pdev->device != 0x4312 &&
> @@ -3560,10 +3558,10 @@ static int b43legacy_wireless_core_attac
>  
>  	err = b43legacy_validate_chipaccess(dev);
>  	if (err)
> -		goto err_powerdown;
> +		goto out;
>  	err = b43legacy_setup_modes(dev, have_bphy, have_gphy);
>  	if (err)
> -		goto err_powerdown;
> +		goto out;
>  
>  	/* Now set some default "current_dev" */
>  	if (!wl->current_dev)
> @@ -3573,14 +3571,9 @@ static int b43legacy_wireless_core_attac
>  	b43legacy_radio_turn_off(dev, 1);
>  	b43legacy_switch_analog(dev, 0);
>  	ssb_device_disable(dev->dev, 0);
> -	ssb_bus_may_powerdown(bus);
>  
>  out:
>  	return err;
> -
> -err_powerdown:
> -	ssb_bus_may_powerdown(bus);
> -	return err;
>  }
>  
>  static void b43legacy_one_core_detach(struct ssb_device *dev)
> Index: wireless-testing/drivers/ssb/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/main.c
> +++ wireless-testing/drivers/ssb/main.c
> @@ -1082,6 +1082,10 @@ int ssb_bus_may_powerdown(struct ssb_bus
>  		goto out;
>  
>  	cc = &bus->chipco;
> +
> +	if (cc->dev->id.revision < 5)
> +		goto out;
> +
>  	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
>  	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
>  	if (err)
> 

Note that this is not the final patch, yet. So please just test,
but not apply it to the tree.

-- 
Greetings Michael.
