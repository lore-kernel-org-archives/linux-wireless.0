Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37702 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1EJESo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 00:18:44 -0400
Received: by vws1 with SMTP id 1so258725vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 21:18:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304951590-2411-10-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com> <1304951590-2411-10-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 10 May 2011 14:18:22 +1000
Message-ID: <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com> (sfid-20110510_061859_736247_80524590)
Subject: Re: [PATCH 9/9] staging: brcm80211: move utility functions into new module
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, Henry Ptasinski <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend, Henry,

One problem I noticed with your patch:

On Tue, May 10, 2011 at 00:33, Arend van Spriel <arend@broadcom.com> wrote:
> From: Henry Ptasinski <henryp@broadcom.com>
>
> Move utility functions shared by the brcmsmac and brcmfmac drivers into a new
> module, brcmutil.ko.  This eliminates the need to compile and link the shared
> functions into both drivers.  Prefix all exported symbols with "bcm_".
>
> Cc: devel@linuxdriverproject.org
> Cc: linux-wireless@vger.kernel.org
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/Makefile                |    1 +
>
> diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
> index c064cdf..287ad0e 100644
> --- a/drivers/staging/brcm80211/Makefile
> +++ b/drivers/staging/brcm80211/Makefile
> @@ -19,5 +19,6 @@
>  subdir-ccflags-y                                       := -DBCMDMA32
>  subdir-ccflags-$(CONFIG_BRCMDBG)       += -DBCMDBG -DBCMDBG_ASSERT
>
> +obj-m                  += util/
>  obj-$(CONFIG_BRCMFMAC) += brcmfmac/
>  obj-$(CONFIG_BRCMSMAC) += brcmsmac/

You should not use obj-m directly - the way this is set up, if module
support is disabled, then the driver will fail as the brcmutil module
will not be built. This might also happen if the drivers are built
into the kernel ('y' rather than 'm')

You should create a new Kconfig variable (say BRCMWLUTIL) and use some
Kconfig trickery to ensure that it's built properly for the drivers
that need it, then replace this line with something like

obj-$(CONFIG_BRCMWLUTIL)

The LIB80211 symbol used by the Intel 2x00 (old non-mac80211) wireless
drivers uses similar trickery to ensure that everything is built
properly.

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
