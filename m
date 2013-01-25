Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYLpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 06:45:16 -0500
Message-ID: <1359114330.4655.0.camel@jlt4.sipsolutions.net> (sfid-20130125_124523_938702_1C43C3F8)
Subject: Re: [PATCH] mwl8k: Announcing AP_VLAN suport
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Fri, 25 Jan 2013 12:45:30 +0100
In-Reply-To: <20130125105121.GA9541@markyou.marvell.com> (sfid-20130125_115935_719740_CF04E836)
References: <20130125105121.GA9541@markyou.marvell.com>
	 (sfid-20130125_115935_719740_CF04E836)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-25 at 16:21 +0530, Yogesh Ashok Powar wrote:
> AP_VLAN support is needed in order to support
> wds_sta in the hostapd. This will allow us
> adding support for 4-address for AP and client
> mode
> 
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index ee5c7ea..8788157 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -5920,6 +5920,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
>  
>  	if (priv->ap_macids_supported || priv->device_info->fw_image_ap) {
>  		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
> +		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
>  		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);

Hmm, why is this needed? mac80211 should add it:

        /* if low-level driver supports AP, we also support VLAN */
        if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
                hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
                hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
        }

Is this run too late, i.e. after registering hw? If so, that's a bug.

johannes

