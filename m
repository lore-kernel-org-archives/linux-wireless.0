Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44433 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab1DSMKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:10:14 -0400
Subject: Re: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
	 <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 14:10:02 +0200
Message-ID: <1303215002.27432.5.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 09:13 +0200, Roland Vossen wrote: 
> Code cleanup. __mips__ was undefined for current builds.
> 
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> ---
>  .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   48 --------------------
>  drivers/staging/brcm80211/include/bcmdefs.h        |    4 --
>  drivers/staging/brcm80211/include/bcmutils.h       |   31 -------------
>  drivers/staging/brcm80211/util/bcmutils.c          |   28 -----------
>  drivers/staging/brcm80211/util/hnddma.c            |   23 ---------
>  5 files changed, 0 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
> index 40f0444..92133c7 100644
> --- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
> +++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
> @@ -246,15 +246,9 @@ u16 read_radio_reg(phy_info_t *pi, u16 addr)
>  	    (D11REV_IS(pi->sh->corerev, 22)
>  	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
>  		W_REG(&pi->regs->radioregaddr, addr);
> -#ifdef __mips__
> -		(void)R_REG(&pi->regs->radioregaddr);
> -#endif

Are you sure? __mips__ is automagically defined by GCC, if compiling
for MIPS. Maybe it should be converted to some CONFIG_... symbol.
But removal seems wrong.

-- 
Greetings Michael.

