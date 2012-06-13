Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2957 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2FMJ3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:29:03 -0400
Message-ID: <4FD85D47.8070609@broadcom.com> (sfid-20120613_112908_853159_8F00E125)
Date: Wed, 13 Jun 2012 11:28:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 6/9] brcm80211: smac: enable/disable radio on
 regulatory updates
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-7-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1338906849-26135-7-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 04:34 PM, Seth Forshee wrote:
> Currently the radio disable state is only updated during initialization,
> and it's only checked against the internal world domain. This is
> unnecessary, as there are always valid channels against this domain.
> Instead, check whether any channels are enabled in the regulatory
> notifier and update the radio state accordingly.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c |   67 ++++++++-------------
>  1 file changed, 26 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index 65ef60b..7182b58 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> @@ -1235,12 +1194,38 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
> +
> +	if (likely(ch_found)) {
> +		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> +	} else {
> +		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> +		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\"\n",
> +			  wlc->pub->unit, __func__, request->alpha2);
> +	}
> +

When we were having fun in staging GregKH indicated that use of likely()
should be justified with profiling data. Probably not really needed here.

Gr. AvS

