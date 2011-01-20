Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:41027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1ATUSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:18:12 -0500
Date: Thu, 20 Jan 2011 12:17:53 -0800
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Message-ID: <20110120201753.GA18529@kroah.com>
References: <1294855167-3718-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294855167-3718-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 06:59:27PM +0100, Arend van Spriel wrote:
> PCI PM suspend callback took down the interface and resume brought
> it back up. In the mac80211 context this is done in subsequent calls.
> Rework implementation so that suspend only stores config, and sets
> PCI power state. The resume return to full power state (D0), restores
> the config, and brings hardware back up. Full bringup is done by
> subsequent mac80211 calls.
> 
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   28 ++++++++++++---------
>  drivers/staging/brcm80211/brcmsmac/wl_mac80211.h |    4 +--
>  2 files changed, 17 insertions(+), 15 deletions(-)

This patch doesn't apply to Linus's tree, which is where it needs to go
right now.  Can you please redo it so that I can apply it?

thanks,

greg k-h
