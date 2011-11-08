Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab1KHPbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:31:34 -0500
Subject: Re: [PATCH v3 1/3] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320762928-6782-1-git-send-email-arik@wizery.com> (sfid-20111108_153605_442273_D3FBD533)
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
	 (sfid-20111108_153605_442273_D3FBD533)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:31:31 +0100
Message-ID: <1320766291.24797.4.camel@jlt3.sipsolutions.net> (sfid-20111108_163138_130276_DFFC7B4F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
> Notify user-space about probe-response offloading support in the driver.
> 
> A wiphy flag is used to indicate support and a bitmap of protocols
> determines which protocols are supported.

> + * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates support for probe
> + *	response offloading by the driver/firmware.
> + *	In addition this attribute holds a bitmap of the supported protocols
> + *	for offloading using &enum nl80211_probe_resp_offload_support_attr.

I wonder if this should make it more clear that probe requests will be
replied to, and this is not optional?

> +++ b/include/net/cfg80211.h
> @@ -1693,6 +1693,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_AP_UAPSD			= BIT(14),
>  	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
>  	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
> +	WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD	= BIT(17),

Ditto here, maybe WIPHY_FLAG_HAS_PROBE_RESP_OFFLOAD?

As we discussed, ath6kl & similar full-mac drivers with AP SME in the
device should set this to advertise the probe protocol feature set they
support (by passing up), and even for wl12xx it's not optional.

johannes

