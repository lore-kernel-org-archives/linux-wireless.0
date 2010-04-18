Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0DRPxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 11:53:33 -0400
Subject: Re: [PATCH 7/9] mac80211: add flags for STBC (Space-Time Block
 Coding)
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
In-Reply-To: <1271602602-8538-7-git-send-email-nbd@openwrt.org>
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-2-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-3-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-4-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-5-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-6-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-7-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Apr 2010 17:53:29 +0200
Message-ID: <1271606009.3873.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-04-18 at 16:56 +0200, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/linux/ieee80211.h |    1 +
>  include/net/mac80211.h    |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 1252ba1..97b2eae 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -876,6 +876,7 @@ struct ieee80211_ht_cap {
>  #define IEEE80211_HT_CAP_SGI_40			0x0040
>  #define IEEE80211_HT_CAP_TX_STBC		0x0080
>  #define IEEE80211_HT_CAP_RX_STBC		0x0300
> +#define		IEEE80211_HT_CAP_RX_STBC_SHIFT	8
>  #define IEEE80211_HT_CAP_DELAY_BA		0x0400
>  #define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
>  #define IEEE80211_HT_CAP_DSSSCCK40		0x1000
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 75056dd..eadf794 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -275,6 +275,8 @@ struct ieee80211_bss_conf {
>   *	MLME command (internal to mac80211 to figure out whether to send TX
>   *	status to user space)
>   * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
> + * @IEEE80211_TX_CTL_STBC: tells the driver to use Space-Time Block Coding
> + *  (STBC) for this frame.
>   */
>  enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
> @@ -299,6 +301,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
>  	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
>  	IEEE80211_TX_CTL_LDPC			= BIT(22),
> +	IEEE80211_TX_CTL_STBC			= BIT(23),

What if the # of streams is different? That doesn't look sufficient.

johannes

