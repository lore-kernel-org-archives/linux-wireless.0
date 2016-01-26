Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39827 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965766AbcAZOCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 09:02:38 -0500
Message-ID: <1453816956.2759.73.camel@sipsolutions.net> (sfid-20160126_150255_073944_FA8E5766)
Subject: Re: [RFC V4 2/2] brcmfmac: add support for nl80211 BSS_SELECT
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jan 2016 15:02:36 +0100
In-Reply-To: <1453813592-5266-3-git-send-email-arend@broadcom.com>
References: <1453813592-5266-1-git-send-email-arend@broadcom.com>
	 <1453813592-5266-3-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 14:06 +0100, Arend van Spriel wrote:
> 
> +static u8 nl80211_band_to_fwil(enum nl80211_band band)
> +{
> +	switch (band) {
> +	case NL80211_BAND_2GHZ:
> +		return WLC_BAND_2G;
> +	case NL80211_BAND_5GHZ:
> +		return WLC_BAND_5G;
> +	default:
> +		WARN_ON(1);
> 
This, btw, is trivially triggerable - you need to check in nl80211 that
the specified band is actually supported by the driver, otherwise even
non-sense like "17" can be specified.

johannes
