Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab0JFJfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:35:03 -0400
Subject: Re: [PATCH] nl80211/mac80211: Add retry and failed transmission
 count to station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101006093412.8830.30085.stgit@tt-desk>
References: <20101006093412.8830.30085.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 11:35:00 +0200
Message-ID: <1286357700.3655.46.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 18:34 +0900, Bruno Randolf wrote:
> This information is already available in mac80211, we just need to export it
> via cfg80211 and nl80211.

Looks sane enough to me:

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  include/linux/nl80211.h |    4 ++++
>  include/net/cfg80211.h  |    8 ++++++++
>  net/mac80211/cfg.c      |    4 ++++
>  net/wireless/nl80211.c  |    6 ++++++
>  4 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 3a491d5..d0d9c8e 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1129,6 +1129,8 @@ enum nl80211_rate_info {
>   * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
>   * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
>   *	station)
> + * @NL80211_STA_INFO_TX_RETRIES: total retries (u32, to this station)
> + * @NL80211_STA_INFO_TX_FAILED: total failed packets (u32, to this station)
>   */
>  enum nl80211_sta_info {
>  	__NL80211_STA_INFO_INVALID,
> @@ -1142,6 +1144,8 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_TX_BITRATE,
>  	NL80211_STA_INFO_RX_PACKETS,
>  	NL80211_STA_INFO_TX_PACKETS,
> +	NL80211_STA_INFO_TX_RETRIES,
> +	NL80211_STA_INFO_TX_FAILED,
>  
>  	/* keep last */
>  	__NL80211_STA_INFO_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e86c890..432bf59 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -405,6 +405,8 @@ struct station_parameters {
>   *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
>   * @STATION_INFO_RX_PACKETS: @rx_packets filled
>   * @STATION_INFO_TX_PACKETS: @tx_packets filled
> + * @STATION_INFO_TX_RETRIES: @tx_retries filled
> + * @STATION_INFO_TX_FAILED: @tx_failed filled
>   */
>  enum station_info_flags {
>  	STATION_INFO_INACTIVE_TIME	= 1<<0,
> @@ -417,6 +419,8 @@ enum station_info_flags {
>  	STATION_INFO_TX_BITRATE		= 1<<7,
>  	STATION_INFO_RX_PACKETS		= 1<<8,
>  	STATION_INFO_TX_PACKETS		= 1<<9,
> +	STATION_INFO_TX_RETRIES		= 1<<10,
> +	STATION_INFO_TX_FAILED		= 1<<11,
>  };
>  
>  /**
> @@ -466,6 +470,8 @@ struct rate_info {
>   * @txrate: current unicast bitrate to this station
>   * @rx_packets: packets received from this station
>   * @tx_packets: packets transmitted to this station
> + * @tx_retries: cumulative retry counts
> + * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
>   * @generation: generation number for nl80211 dumps.
>   *	This number should increase every time the list of stations
>   *	changes, i.e. when a station is added or removed, so that
> @@ -483,6 +489,8 @@ struct station_info {
>  	struct rate_info txrate;
>  	u32 rx_packets;
>  	u32 tx_packets;
> +	u32 tx_retries;
> +	u32 tx_failed;
>  
>  	int generation;
>  };
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c981604..d5a06e5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -285,6 +285,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>  			STATION_INFO_TX_BYTES |
>  			STATION_INFO_RX_PACKETS |
>  			STATION_INFO_TX_PACKETS |
> +			STATION_INFO_TX_RETRIES |
> +			STATION_INFO_TX_FAILED |
>  			STATION_INFO_TX_BITRATE;
>  
>  	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
> @@ -292,6 +294,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>  	sinfo->tx_bytes = sta->tx_bytes;
>  	sinfo->rx_packets = sta->rx_packets;
>  	sinfo->tx_packets = sta->tx_packets;
> +	sinfo->tx_retries = sta->tx_retry_count;
> +	sinfo->tx_failed = sta->tx_retry_failed;
>  
>  	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
>  	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 26062e1..af30a03 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1923,6 +1923,12 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
>  	if (sinfo->filled & STATION_INFO_TX_PACKETS)
>  		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_PACKETS,
>  			    sinfo->tx_packets);
> +	if (sinfo->filled & STATION_INFO_TX_RETRIES)
> +		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_RETRIES,
> +			    sinfo->tx_retries);
> +	if (sinfo->filled & STATION_INFO_TX_FAILED)
> +		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_FAILED,
> +			    sinfo->tx_failed);
>  	nla_nest_end(msg, sinfoattr);
>  
>  	return genlmsg_end(msg, hdr);
> 
> 


