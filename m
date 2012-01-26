Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45393 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2AZNKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 08:10:16 -0500
Message-ID: <4F2150B2.3030004@openwrt.org> (sfid-20120126_141021_548662_79B0D6F2)
Date: Thu, 26 Jan 2012 14:10:10 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, mcgrof@frijolero.org,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org
Subject: Re: [RFC 4/7] hostapd: add dfs support into interface init flow
References: <1327581689-22090-1-git-send-email-victorg@ti.com> <1327581689-22090-5-git-send-email-victorg@ti.com>
In-Reply-To: <1327581689-22090-5-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-26 1:41 PM, Victor Goldenshtein wrote:
> Implement Channel Availability Check (CAC) during initialization
> phase. According to DFS requirements the AP should monitor 'radar
> channels' for potential radar interference for a minimum CAC time
> prior enabling the transmissions.
> 
> Add dfs support into hw features, allow the usage of the radar
> channels if ieee80211h is enabled in the hostapd.conf and the
> driver supports radar detection.
> 
> Parse and handle driver's DFS capabilities, userspace applications
> must be fully synchronized with device capabilities to detect radar
> patterns in the air which may influence userspace behavior.
> 
> Signed-off-by: Boris Presman <boris.presman@ti.com>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  src/ap/hostapd.c             |   17 +++++++++++------
>  src/ap/hw_features.c         |   30 ++++++++++++++++++++----------
>  src/ap/hw_features.h         |    9 +++++++++
>  src/drivers/driver.h         |    5 +++++
>  src/drivers/driver_nl80211.c |    7 +++++++
>  src/utils/eloop.c            |    4 ++++
>  src/utils/eloop.h            |    7 +++++++
>  7 files changed, 63 insertions(+), 16 deletions(-)
> 
> diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
> index ce37922..411b681 100644
> --- a/src/ap/hostapd.c
> +++ b/src/ap/hostapd.c
> @@ -733,14 +739,13 @@ int hostapd_setup_interface_complete(struct hostapd_iface *iface, int err)
>  			   hostapd_hw_mode_txt(hapd->iconf->hw_mode),
>  			   hapd->iconf->channel, iface->freq);
>  
> -		if (hostapd_set_freq(hapd, hapd->iconf->hw_mode, iface->freq,
> -				     hapd->iconf->channel,
> -				     hapd->iconf->ieee80211n,
> -				     hapd->iconf->secondary_channel)) {
> -			wpa_printf(MSG_ERROR, "Could not set channel for "
> -				   "kernel driver");
> +		if (hostapd_check_set_freq(hapd)) {
> +			wpa_printf(MSG_ERROR, "Couldn't check/set freq");
>  			return -1;
>  		}
> +
> +		eloop_enable();
> +		wpa_printf(MSG_DEBUG, "Continuing with init flow");
>  	}
>  
>  	if (iface->current_mode) {
This seems like a bit of a hack to me. Wouldn't it be better to prevent
eloop_terminate() from being called instead of adding another function
to override the eloop termination?

- Felix
