Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:41467
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZIYLzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 07:55:11 -0400
Date: Fri, 25 Sep 2009 20:55:12 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>
Subject: Re: [PATCH] [RFT] sony-laptop: re-read the rfkill state when
 resuming from suspend
Message-ID: <20090925115512.GA27795@kamineko.org>
References: <4ABC8ADD.3090803@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ABC8ADD.3090803@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 10:18:21AM +0100, Alan Jenkins wrote:
> Without this, the hard-blocked state will be reported incorrectly if
> the hardware switch is changed while the laptop is suspended.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Thanks Alan.

Acked-by: Mattia Dongili <malattia@linux.it>

> --
> 
> Again, this is from code inspection only.  Since suspend/resume can
> be tricky, please test that this change works (and is necessary).
> 
> 
> diff a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1044,6 +1044,9 @@ static int sony_nc_resume(struct acpi_device *device)
>  			sony_backlight_update_status(sony_backlight_device) < 0)
>  		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
>  
> +	/* re-read rfkill state */
> +	sony_nc_rfkill_update();
> +
>  	return 0;
>  }
>  
> 
> 
-- 
mattia
:wq!
