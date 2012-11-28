Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2K1MdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:33:13 -0500
Message-ID: <1354106016.9345.4.camel@jlt4.sipsolutions.net> (sfid-20121128_133316_924532_DF2FC514)
Subject: Re: [RFC] mac80211: add debugfs file for last ack signal
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 13:33:36 +0100
In-Reply-To: <50B5CA15.2080407@posedge.com>
References: <50B5CA15.2080407@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 13:53 +0530, Saravana wrote:
> Add a debugfs file showing the signal strength
> of the ack frame that is received for the
> currently sent tx packet
> 
> Signed-off-by: Saravana <saravanad@posedge.com>
> ---
>  net/mac80211/debugfs_sta.c |    2 ++
>  net/mac80211/sta_info.h    |    2 ++
>  net/mac80211/status.c      |    2 ++
>  3 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 89281d2..1566941 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -53,6 +53,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
>  STA_FILE(aid, sta.aid, D);
>  STA_FILE(dev, sdata->name, S);
>  STA_FILE(last_signal, last_signal, D);
> +STA_FILE(last_ack_signal, last_ack_signal, D);
>  
>  static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
>  			      size_t count, loff_t *ppos)
> @@ -369,6 +370,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
>  	DEBUGFS_ADD(dev);
>  	DEBUGFS_ADD(last_signal);
>  	DEBUGFS_ADD(ht_capa);
> +	DEBUGFS_ADD(last_ack_signal);
>  
>  	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
>  	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 6835cea..dce7693 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -250,6 +250,7 @@ struct sta_ampdu_mlme {
>   * @rx_dropped: number of dropped MPDUs from this STA
>   * @last_signal: signal of last received frame from this STA
>   * @avg_signal: moving average of signal of received frames from this STA
> + * @last_ack_signal: signal of last received Ack frame from this STA
>   * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
>   * @tx_filtered_count: number of frames the hardware filtered for this STA
>   * @tx_retry_failed: number of frames that failed retry
> @@ -329,6 +330,7 @@ struct sta_info {
>  	unsigned long rx_dropped;
>  	int last_signal;
>  	struct ewma avg_signal;
> +	int last_ack_signal;
>  	/* Plus 1 for non-QoS frames */
>  	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];
>  
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 2d931ad..64dda41 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -539,6 +539,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  				sta->lost_packets = 0;
>  			}
>  		}
> +		if (acked)
> +			sta->last_ack_signal = info->status.ack_signal;

I'd prefer a blank line before the if

This patch was sent in a way that I could apply it. :-)

johannes

