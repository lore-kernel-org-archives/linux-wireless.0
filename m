Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab1ENPqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 11:46:32 -0400
Date: Sat, 14 May 2011 08:46:36 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/32] staging: brcm80211: new Kconfig item to enable IO
 reordering fix
Message-ID: <20110514154636.GA25783@kroah.com> (sfid-20110514_174645_409913_84FB0F7A)
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
 <1305280792-9475-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305280792-9475-2-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 11:59:22AM +0200, Arend van Spriel wrote:
> From: Roland Vossen <rvossen@broadcom.com>
> 
> bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> transactions. As a fix, a read after write is performed on certain places
> in the code. Older chips and the newer 5357 family don't require this fix.
> 
> Cc: devel@linuxdriverproject.org
> Cc: linux-wireless@vger.kernel.org
> Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/Kconfig                  |    8 ++++++++
>  .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 ++--
>  drivers/staging/brcm80211/include/bcmutils.h       |   11 +++++++++++
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
> index f4cf9b2..a11ffc7 100644
> --- a/drivers/staging/brcm80211/Kconfig
> +++ b/drivers/staging/brcm80211/Kconfig
> @@ -36,3 +36,11 @@ config BRCMDBG
>  	depends on BRCMSMAC || BRCMFMAC
>  	---help---
>  	  Selecting this enables additional code for debug purposes.
> +
> +config BRCM_FIX_IO_ORDER
> +	bool "Broadcom I/O order fix"
> +	default n
> +	depends on BRCMSMAC
> +	---help---
> +	  Select this for for platforms running on bcm4706, 4716, 4717 or 4718.
> +	  It resolves an I/O issue with the PCIe core used in these chips.

No, don't make a new kconfig option for something that everyone has to
enable as they don't know what they have on their system (think
universal kernels built by distros.)

Do this check dynamically, depending on the chip the driver is running
on, don't rely on a user to know what to do here.

So I'm not going to accept this patch, sorry.

greg k-h
