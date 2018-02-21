Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:40621 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbeBUIoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 03:44:09 -0500
Received: by mail-qt0-f169.google.com with SMTP id c19so979428qtm.7
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 00:44:09 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: reject too long PSK
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180219123045.8818-1-johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8D3157.7080208@broadcom.com> (sfid-20180221_094413_737222_3C0C7F7A)
Date: Wed, 21 Feb 2018 09:44:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180219123045.8818-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/19/2018 1:30 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> nl80211 already allows specifying 48 bytes, but brcmfmac
> only supports 32. Reject keys that are too long.

Hah. Recent discussion about the key length made you look ;-) Thanks!

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 15fa00d79fc6..74a83020c073 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5124,6 +5124,9 @@ static int brcmf_cfg80211_set_pmk(struct wiphy *wiphy, struct net_device *dev,
>   	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
>   		return -EINVAL;
>
> +	if (conf->pmk_len > BRCMF_WSEC_MAX_PSK_LEN)
> +		return -ERANGE;
> +
>   	return brcmf_set_pmk(ifp, conf->pmk, conf->pmk_len);
>   }
>
>
