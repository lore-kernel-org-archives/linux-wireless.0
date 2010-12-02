Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:32949 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab0LBWQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 17:16:13 -0500
Subject: Re: [RFC/RFT] ssb: Attempt to recover from SPROM CRC error
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net> (sfid-20101202_173713_192185_FFFFFFFF949EBC0D)
References: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net>
	 (sfid-20101202_173713_192185_FFFFFFFF949EBC0D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 23:15:54 +0100
Message-ID: <1291328154.13801.0.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 10:36 -0600, Larry Finger wrote: 
> Current code defaults to SPROM revision 1 if there is a CRC error. In at
> least one known case, most of the corrupt contents are reasonable and
> it is possible to extract the correct MAC address and TX power settings
> from what is read. With this patch, an attempt is made to match the
> apparent revision number with certain SPROM signatures. For those revisions
> without such a feature, a reasonable guess is made. If the apparent
> revision is invalid, or if the signature does not match, the previous
> behavior is kept.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> Could you please test this patch with your card?
> 
> Thanks,
> 
> Larry
> ---
> 
> Index: linux-2.6/drivers/ssb/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/ssb/pci.c
> +++ linux-2.6/drivers/ssb/pci.c
> @@ -620,6 +620,7 @@ static int ssb_pci_sprom_get(struct ssb_
>  	const struct ssb_sprom *fallback;
>  	int err = -ENOMEM;
>  	u16 *buf;
> +	u16 revision;
>  
>  	if (!ssb_is_sprom_available(bus)) {
>  		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
> @@ -671,6 +672,50 @@ static int ssb_pci_sprom_get(struct ssb_
>  			}
>  			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
>  				   " SPROM CRC (corrupt SPROM)\n");
> +			/* At this point, we have a faulty SPROM image.
> +			 * In case only part of it is corrupt, try to
> +			 * determine what rev we might have */
> +			revision = buf[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF;

I think this could possibly overrun the buffer, or did I get something
wrong?

-- 
Greetings Michael.

