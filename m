Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab2FYQxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 12:53:53 -0400
Date: Mon, 25 Jun 2012 11:53:45 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: fix NULL pointer crash in brcms_c_regd_init()
Message-ID: <20120625165345.GB4495@thinkpad-t410> (sfid-20120625_185356_826786_8E724523)
References: <1340286553-12053-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340286553-12053-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Sorry for my slow response. I was on vacation last week.

On Thu, Jun 21, 2012 at 03:49:13PM +0200, Arend van Spriel wrote:
> In the function brcms_c_regd_init() the channels are validated
> against the device capabilities. This is done for both 2.4G and
> 5G band, but there are devices that are 2.4G only, ie. BCM4313.
> For that device this leads to a NULL dereference. This patch adds
> a check in brcms_c_regd_init() to fix this.
> 
> Issue introduced in wireless-next tree by following commit:
> cf03c5d brcm80211: smac: inform mac80211 of the X2 regulatory domain
> 
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Noticed that one of smoketest machines actually was not sending results
> ever since I staged regulatory fixes for it. This particular system has
> a 2.4G card fitted so the root cause was quickly found.
> 
> Gr. AvS
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index d3c7260..2d365d3 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> @@ -768,6 +768,11 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
>  			band = wlc->bandstate[BAND_2G_INDEX];
>  		else
>  			band = wlc->bandstate[BAND_5G_INDEX];
> +
> +		/* skip if band not initialized */
> +		if (band->pi == NULL)
> +			continue;
> +

Yeah, I definitely messed that up.

This looks fine, but it strikes me that it might simplify things a bit
to change the loop to iterate over over wlc->pub->_nbands instead. The
difference is pretty minor though, and since John has already applied
this patch there's probably no reason to change it.

Thanks,
Seth

