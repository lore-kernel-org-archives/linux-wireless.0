Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43555 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKXWAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 17:00:11 -0500
Date: Mon, 24 Nov 2014 16:50:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] brcmsmac: extend hardware info shown in debugfs
Message-ID: <20141124215049.GA4484@tuxdriver.com> (sfid-20141124_230016_564495_CD7F5963)
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
 <1416518822-29585-4-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416518822-29585-4-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmmm...I'm not sure why, but this is causing problems for me...

ERROR: "brcmu_boardrev_str" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!

On Thu, Nov 20, 2014 at 10:27:01PM +0100, Arend van Spriel wrote:
> The hardware info now also include radio and phy information, which
> can be helpful in debugging issues.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/debug.c | 40 +++++++++++++++++--------
>  1 file changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> index 19740c1..c9a8b93 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> @@ -30,6 +30,7 @@
>  #include "main.h"
>  #include "debug.h"
>  #include "brcms_trace_events.h"
> +#include "phy/phy_int.h"
>  
>  static struct dentry *root_folder;
>  
> @@ -74,20 +75,33 @@ static
>  int brcms_debugfs_hardware_read(struct seq_file *s, void *data)
>  {
>  	struct brcms_pub *drvr = s->private;
> +	struct brcms_hardware *hw = drvr->wlc->hw;
> +	struct bcma_device *core = hw->d11core;
> +	struct bcma_bus *bus = core->bus;
> +	char boardrev[10];
>  
> -	seq_printf(s, "board vendor: %x\n"
> -		   "board type: %x\n"
> -		   "board revision: %x\n"
> -		   "board flags: %x\n"
> -		   "board flags2: %x\n"
> -		   "firmware revision: %x\n",
> -		   drvr->wlc->hw->d11core->bus->boardinfo.vendor,
> -		   drvr->wlc->hw->d11core->bus->boardinfo.type,
> -		   drvr->wlc->hw->boardrev,
> -		   drvr->wlc->hw->boardflags,
> -		   drvr->wlc->hw->boardflags2,
> -		   drvr->wlc->ucode_rev);
> -
> +	seq_printf(s, "chipnum 0x%x\n"
> +		   "chiprev 0x%x\n"
> +		   "chippackage 0x%x\n"
> +		   "corerev 0x%x\n"
> +		   "boardid 0x%x\n"
> +		   "boardvendor 0x%x\n"
> +		   "boardrev %s\n"
> +		   "boardflags 0x%x\n"
> +		   "boardflags2 0x%x\n"
> +		   "ucoderev 0x%x\n"
> +		   "radiorev 0x%x\n"
> +		   "phytype 0x%x\n"
> +		   "phyrev 0x%x\n"
> +		   "anarev 0x%x\n"
> +		   "nvramrev %d\n",
> +		   bus->chipinfo.id, bus->chipinfo.rev, bus->chipinfo.pkg,
> +		   core->id.rev, bus->boardinfo.type, bus->boardinfo.vendor,
> +		   brcmu_boardrev_str(hw->boardrev, boardrev),
> +		   drvr->wlc->hw->boardflags, drvr->wlc->hw->boardflags2,
> +		   drvr->wlc->ucode_rev, hw->band->radiorev,
> +		   hw->band->phytype, hw->band->phyrev, hw->band->pi->ana_rev,
> +		   hw->sromrev);
>  	return 0;
>  }
>  
> -- 
> 1.9.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
