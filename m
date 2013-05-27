Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab3E0Iml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 04:42:41 -0400
Message-ID: <1369644158.8229.5.camel@jlt4.sipsolutions.net> (sfid-20130527_104244_607939_0703189C)
Subject: Re: [PATCH 2/3] mac80211: support active monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 10:42:38 +0200
In-Reply-To: <1369577107-87931-2-git-send-email-nbd@openwrt.org>
References: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
	 <1369577107-87931-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-05-26 at 16:05 +0200, Felix Fietkau wrote:
> Support them only if the driver advertises support for them via
> IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR. Unlike normal monitor interfaces,
> they are added to the driver, along with their MAC address.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h     |  5 +++++
>  net/mac80211/cfg.c         | 11 +++++++----
>  net/mac80211/driver-ops.h  |  3 ++-
>  net/mac80211/ieee80211_i.h |  2 +-
>  net/mac80211/iface.c       | 33 ++++++++++++++++++++++++++-------
>  net/mac80211/util.c        |  6 ++++++
>  6 files changed, 47 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 885898a..b80c5cd 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1455,6 +1455,10 @@ struct ieee80211_tx_control {
>   *
>   * @IEEE80211_HW_TIMING_BEACON_ONLY: Use sync timing from beacon frames
>   *	only, to allow getting TBTT of a DTIM beacon.
> + *
> + * @IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR: Device supports an active monitor
> + *	interface that responds to unicast packets directed at its MAC
> + *	address.

... basically moving this to nl80211

johannes

