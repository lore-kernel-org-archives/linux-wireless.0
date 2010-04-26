Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48334 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0DZRaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 13:30:13 -0400
Date: Mon, 26 Apr 2010 13:15:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ssb: Avoid system hang when SPROM read fails
Message-ID: <20100426171505.GC2387@tuxdriver.com>
References: <4bd4c284.WBohOsmgdwRzw5JC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4bd4c284.WBohOsmgdwRzw5JC%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 25, 2010 at 05:30:28PM -0500, Larry Finger wrote:
> In kernel Bugzilla #15825, the OP reports a case of intermittent reading
> of the SPROM. If such reads fail, the box hangs. Thanks to careful testing
> by bugzillakernelorg@lez.ath.cx has shown that the first read of the
> SPROM returns 0xFFFF with the hang happening on the next read.
> 
> The source of the read failure is still under investigation; however,
> this patch does avoid the system hang.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> Does this patch avoid the system hang on your box?
> 
> Larry
> ---
> 
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/pci.c
> +++ wireless-testing/drivers/ssb/pci.c
> @@ -253,6 +253,11 @@ static int sprom_do_read(struct ssb_bus
>  {
>  	int i;
>  
> +	/* Check if SPROM can be read */
> +	if (ioread16(bus->mmio + SSB_SPROM_BASE) == 0xFFFF) {
> +		ssb_printk(KERN_ERR PFX "Unable to read SPROM\n");
> +		return -ENODEV;
> +	}
>  	for (i = 0; i < bus->sprom_size; i++)
>  		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
>  

Well, the "good" news is that I hit the "Unable to read SPROM" case.
The bad news is that the box still hangs after the -ENODEV.  I have
not yet tracked-down the exact location of the current hang.

John

P.S.  Sorry about the 'radio silence' -- I've been distracted with
some other things.  Also, the box in question originally belonged
to someone else who had configured it in a way that was less than
friendly to kernel development.  I finally reinstalled it...
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
