Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35409 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507AbYFXKmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:42:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Date: Tue, 24 Jun 2008 12:42:11 +0200
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com> <1214303881-31525-4-git-send-email-tomas.winkler@intel.com> <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806241242.11727.mb@bu3sch.de> (sfid-20080624_124243_975089_C706DB4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 June 2008 12:38:01 Tomas Winkler wrote:
> This patch add phy information to giwname. Currently
> 802.11b is not treated.
> 
> Quoting:
> It's not useless, it's supposed to tell you about the protocol
> capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"

Well, I think it _is_ pretty useless.
However...

> @@ -135,7 +135,24 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
>  				   struct iw_request_info *info,
>  				   char *name, char *extra)
>  {
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_supported_band *sband;
> +	u8 is_ht = 0;
> +
>  	strcpy(name, "IEEE 802.11");
> +	sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
> +
> +	if (sband) {
> +		strcat(name, "a");
> +		is_ht |= sband->ht_info.ht_supported;
> +	}
> +	sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
> +	if (sband) {
> +		strcat(name, "g");
> +		is_ht |= sband->ht_info.ht_supported;

What about b-only devices?

> +	}
> +	if (is_ht)
> +		strcat(name, "n");
>  
>  	return 0;
>  }



-- 
Greetings Michael.
