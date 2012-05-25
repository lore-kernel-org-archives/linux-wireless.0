Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3213 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYWdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:33:23 -0400
Message-ID: <4FC008A1.9060005@broadcom.com> (sfid-20120526_003325_476696_7CC02BE3)
Date: Sat, 26 May 2012 00:33:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 3/8] brcm80211: smac: clean up channel.c
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-4-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-4-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> Much of the code is either unsed or never put to any useful purpose.
> Remove this code in advance of reworking the driver's regulatory
> support.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c |  254 +--------------------
>  1 file changed, 5 insertions(+), 249 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index 71fce2c..1998c86 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
>
> @@ -1450,45 +1245,6 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
>  			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
>  						       channel);
>  	}
> -#ifdef SUPPORT_40MHZ
> -	/*
> -	 * We know we are now checking a 40MHZ channel, so we should
> -	 * only be here for NPHYS
> -	 */
> -	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
> -		u8 upper_sideband = 0, idx;
> -		u8 num_ch20_entries =
> -		    sizeof(chan20_info) / sizeof(struct chan20_info);
> -
> -		if (!VALID_40CHANSPEC_IN_BAND(wlc, chspec_bandunit(chspec)))
> -			return false;
> -
> -		if (dualband) {
> -			if (!brcms_c_valid_channel20_db(wlc->cmi,
> -							lower_20_sb(channel)) ||
> -			    !brcms_c_valid_channel20_db(wlc->cmi,
> -							upper_20_sb(channel)))
> -				return false;
> -		} else {
> -			if (!brcms_c_valid_channel20(wlc->cmi,
> -						     lower_20_sb(channel)) ||
> -			    !brcms_c_valid_channel20(wlc->cmi,
> -						     upper_20_sb(channel)))
> -				return false;
> -		}
> -
> -		/* find the lower sideband info in the sideband array */
> -		for (idx = 0; idx < num_ch20_entries; idx++) {
> -			if (chan20_info[idx].sb == lower_20_sb(channel))
> -				upper_sideband = chan20_info[idx].adj_sbs;
> -		}
> -		/* check that the lower sideband allows an upper sideband */
> -		if ((upper_sideband & (CH_UPPER_SB | CH_EWA_VALID)) ==
> -		    (CH_UPPER_SB | CH_EWA_VALID))
> -			return true;
> -		return false;
> -	}
> -#endif				/* 40 MHZ */
>  
>  	return false;
>  }

We are not supporting 40MHz right now, but it is on our roadmap. I would
prefer to keep it, but git can recover it for me when that roadmap item
is due.

Gr. AvS

