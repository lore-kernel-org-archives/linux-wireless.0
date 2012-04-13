Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2DMOsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 10:48:31 -0400
Date: Fri, 13 Apr 2012 09:48:23 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/9] brcm80211: smac: do not use US as fallback
 regulatory hint
Message-ID: <20120413144823.GC3336@thinkpad-t410> (sfid-20120413_164834_571436_0A5A685D)
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
 <1334137971-3972-8-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334137971-3972-8-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 11:52:49AM +0200, Arend van Spriel wrote:
> The brcmsmac driver provides the country code from sprom as a regulatory
> hint to cfg80211. When brcmsmac does not find a country code entry in
> the sprom it passes 'US' as regulatory hint. Better approach is to rely
> on the world regulatory domain in cfg80211/crda.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 569ab8a..aa15558 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -1069,11 +1069,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
>  		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
>  			  "%d\n", __func__, err);
>  
> -	if (wl->pub->srom_ccode[0])
> -		err = brcms_set_hint(wl, wl->pub->srom_ccode);
> -	else
> -		err = brcms_set_hint(wl, "US");
> -	if (err)
> +	if (wl->pub->srom_ccode[0] && brcms_set_hint(wl, wl->pub->srom_ccode))
>  		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
>  			  __func__, err);

err no longer holds the return value from brcms_set_hint(), so it
doesn't make sense to print it in the error message. The value will
always be 0.

Seth

