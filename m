Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36796 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYKvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 06:51:46 -0400
Date: Fri, 25 Sep 2009 12:51:45 +0200
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mattia Dongili <malattia@linux.it>
Subject: Re: [PATCH] [RFT] sony-laptop: re-read the rfkill state when
	resuming from suspend
Message-ID: <20090925105145.GA23268@gamma.logic.tuwien.ac.at>
References: <4ABC8ADD.3090803@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ABC8ADD.3090803@tuffmail.co.uk>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fr, 25 Sep 2009, Alan Jenkins wrote:
> Without this, the hard-blocked state will be reported incorrectly if
> the hardware switch is changed while the laptop is suspended.

I confirm that with the old module (without that patch) after:
- having rfkill de-activated (so devices working)
- suspend to ram
- while suspended turn on rfkill (disable all devices)
- resume
the rfkill event shows:
RFKILL event: idx 0 type 1 op 0 soft 0 hard 0
RFKILL event: idx 1 type 2 op 0 soft 0 hard 0
RFKILL event: idx 2 type 5 op 0 soft 0 hard 0
RFKILL event: idx 4 type 1 op 0 soft 0 hard 1

so it didn't work.

Adding the patch after resume I have
RFKILL event: idx 0 type 1 op 0 soft 0 hard 1
RFKILL event: idx 1 type 2 op 0 soft 0 hard 1
RFKILL event: idx 2 type 5 op 0 soft 0 hard 1
RFKILL event: idx 5 type 1 op 0 soft 0 hard 1

so that is fixed.

Tested-by: Norbert Preining <preining@logic.at>
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
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

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
HUTTOFT (n.)
The fibrous algae which grows in the dark, moist environment of
trouser turn-ups.
			--- Douglas Adams, The Meaning of Liff
