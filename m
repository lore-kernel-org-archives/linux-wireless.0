Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab2CAKYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:24:30 -0500
Subject: Re: [PATCH] mac80211: use 16 bit alignment for the if_ibss bssid
 field
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1330597417-74535-1-git-send-email-nbd@openwrt.org>
References: <1330597417-74535-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 11:24:27 +0100
Message-ID: <1330597467.3623.1.camel@jlt3.sipsolutions.net> (sfid-20120301_112436_208167_D8F6A8B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 11:23 +0100, Felix Fietkau wrote:
> Several MAC address comparison functions assume 16 bit alignment for pointers
> passed to them. Since the addition of the control_port field, alignment
> for the IBSS bssid was off by one, causing a severe performance hit on
> architectures without efficient unaligned access (e.g. MIPS).
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_i.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index cee0c74..c413058 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -480,7 +480,7 @@ struct ieee80211_if_ibss {
>  
>  	bool control_port;
>  
> -	u8 bssid[ETH_ALEN];
> +	u8 bssid[ETH_ALEN] __aligned(2);
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
>  	u8 ssid_len, ie_len;
>  	u8 *ie;


