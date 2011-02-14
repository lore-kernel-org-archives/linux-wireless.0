Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1BNKGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:06:16 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a field for the bitrate of the last
 rx data packet from a station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1297351797-35031-1-git-send-email-nbd@openwrt.org>
References: <1297351797-35031-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:06:14 +0100
Message-ID: <1297677974.3785.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 16:29 +0100, Felix Fietkau wrote:
> Also fix a typo in the STATION_INFO_TX_BITRATE description
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/linux/nl80211.h |    3 ++
>  include/net/cfg80211.h  |    5 +++-
>  net/wireless/nl80211.c  |   56 +++++++++++++++++++++++++++++++----------------
>  3 files changed, 44 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 821ffb9..35bfec2 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1243,6 +1243,8 @@ enum nl80211_rate_info {
>   * @NL80211_STA_INFO_LLID: the station's mesh LLID
>   * @NL80211_STA_INFO_PLID: the station's mesh PLID
>   * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
> + * @NL80211_STA_INFO_RX_BITRATE: last unicast rx rate, nested attribute
> + * 	containing info as possible, see &enum nl80211_sta_info_txrate.

I think it would make sense to restrict this to data frames, as mgmt
frames will often be sent with a low rate.

johannes

