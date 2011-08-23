Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50858 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1HWW2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 18:28:13 -0400
Date: Tue, 23 Aug 2011 15:26:14 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: driverdevel <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] staging: brcmsmac, fix build for SMP disabled
Message-ID: <20110823222614.GA20158@kroah.com> (sfid-20110824_002829_727270_2CC7215C)
References: <20110823145659.a22e1860.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110823145659.a22e1860.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 02:56:59PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build when CONFIG_SMP is not enabled.
> Fixes many build errors (subset listed here):
> 
> drivers/staging/brcm80211/brcmsmac/ampdu.c: In function 'brcms_c_ampdu_dotxstatus':
> drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readb'
> drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readw'
> drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readl'
> drivers/staging/brcm80211/brcmsmac/main.c: In function 'brcms_c_init':
> drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writeb'
> drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writew'
> drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writel'
> drivers/staging/brcm80211/brcmsmac/main.c:529: error: implicit declaration of function 'readb'
> drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c: In function 'wlc_radioreg_exit':
> drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c:208: error: implicit declaration of function 'readb'
> drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c:208: error: implicit declaration of function 'readw'
> drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c: In function 'wlc_lcnphy_idle_tssi_est':
> drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c:2080: error: implicit declaration of function 'readb'
> drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c: In function 'wlc_lcnphy_samp_cap':
> drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c:3837: error: implicit declaration of function 'writeb'
> vers/staging/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_init_nphy':
> drivers/staging/brcm80211/brcmsmac/phy/phy_n.c:14561: error: implicit declaration of function 'readb'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

No longer applies as I took a different patch that resolves this a few
hours ago :(

greg k-h
