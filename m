Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3043 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3FFMIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 08:08:44 -0400
Message-ID: <51B07B23.1090205@broadcom.com> (sfid-20130606_140847_833296_AC93542F)
Date: Thu, 6 Jun 2013 14:05:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 03/15] brcmsmac: remove brcms_bss_cfg->BSS
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
 <1364085963-25940-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1364085963-25940-4-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2013 01:45 AM, Hauke Mehrtens wrote:
> This was a read only member. The checks using BSS are replaced by
> better fitting checks of the new type member.
>
> The change in brcms_c_tbtt() was based on code from b43, in
> brcms_c_ps_allowed() the same happens with BSS being true or false,
> beaconing and probe responses are just needed in ap mode.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c |   23 +++++++++--------------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
>   2 files changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 4e420ea..90e6c0d 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -1069,7 +1069,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
>
>   static void brcms_c_tbtt(struct brcms_c_info *wlc)
>   {
> -	if (!wlc->bsscfg->BSS)
> +	if (wlc->bsscfg->type == BRCMS_TYPE_ADHOC)
>   		/*
>   		 * DirFrmQ is now valid...defer setting until end
>   		 * of ATIM window

Hi Hauke,

Sorry for such a late comment. It seem that the above change is 
incosistent with the changes below. You probably need to change it.

Gr. AvS

> @@ -7386,7 +7379,8 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
>   {
>   	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
>
> -	if (bsscfg->up && !bsscfg->BSS)
> +	if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
> +			   bsscfg->type == BRCMS_TYPE_ADHOC))
>   		/* Clear the soft intmask */
>   		wlc->defmacintmask &= ~MI_BCNTPL;
>   }
> @@ -7461,7 +7455,8 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
>   	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
>
>   	/* update AP or IBSS probe responses */
> -	if (bsscfg->up && !bsscfg->BSS)
> +	if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
> +			   bsscfg->type == BRCMS_TYPE_ADHOC))
>   		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
>   }
>


