Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14112 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1DHNGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 09:06:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 06:05:51 -0700
Message-ID: <4D9F0841.3050104@atheros.com>
Date: Fri, 8 Apr 2011 18:36:09 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] {mac|nl}80211: Add station connected time
References: <1302265470-20565-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1302265470-20565-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 April 2011 05:54 PM, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> Add station connected time in debugfs and also display it via few
> 'iw' commands. This will be helpful to get a measure of stability of the
> connection and for debugging purpose while stress testing.
>
> Cc: Senthilkumar Balasubramanian<Senthilkumar.Balasubramanian@Atheros.com>
> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> ---
>   include/linux/nl80211.h    |    2 ++
>   include/net/cfg80211.h     |    4 ++++
>   net/mac80211/cfg.c         |    7 ++++++-
>   net/mac80211/debugfs_sta.c |   26 ++++++++++++++++++++++++++
>   net/mac80211/sta_info.c    |    3 +++
>   net/mac80211/sta_info.h    |    2 ++
>   net/wireless/nl80211.c     |    3 +++
>   7 files changed, 46 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 16eea72..ad7fc6b 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1277,6 +1277,7 @@ enum nl80211_sta_bss_param {
>    *	attribute, like NL80211_STA_INFO_TX_BITRATE.
>    * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
>    *     containing info as possible, see&enum nl80211_sta_bss_param
> + * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
>    * @__NL80211_STA_INFO_AFTER_LAST: internal
>    * @NL80211_STA_INFO_MAX: highest possible station info attribute
>    */
> @@ -1297,6 +1298,7 @@ enum nl80211_sta_info {
>   	NL80211_STA_INFO_SIGNAL_AVG,
>   	NL80211_STA_INFO_RX_BITRATE,
>   	NL80211_STA_INFO_BSS_PARAM,
> +	NL80211_STA_INFO_CONNECTED_TIME,
>
>   	/* keep last */
>   	__NL80211_STA_INFO_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ba7384a..0253d50 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -423,6 +423,7 @@ struct station_parameters {
>    * @STATION_INFO_SIGNAL_AVG: @signal_avg filled
>    * @STATION_INFO_RX_BITRATE: @rxrate fields are filled
>    * @STATION_INFO_BSS_PARAM: @bss_param filled
> + * @STATION_INFO_CONNECTED_TIME: @connected_time filled
>    */
>   enum station_info_flags {
>   	STATION_INFO_INACTIVE_TIME	= 1<<0,
> @@ -441,6 +442,7 @@ enum station_info_flags {
>   	STATION_INFO_SIGNAL_AVG		= 1<<13,
>   	STATION_INFO_RX_BITRATE		= 1<<14,
>   	STATION_INFO_BSS_PARAM          = 1<<15,
> +	STATION_INFO_CONNECTED_TIME	= 1<<16
>   };
>
>   /**
> @@ -511,6 +513,7 @@ struct sta_bss_parameters {
>    * Station information filled by driver for get_station() and dump_station.
>    *
>    * @filled: bitflag of flags from&enum station_info_flags
> + * @connected_time: time(in secs) since a station is last connected
>    * @inactive_time: time since last station activity (tx/rx) in milliseconds
>    * @rx_bytes: bytes received from this station
>    * @tx_bytes: bytes transmitted to this station
> @@ -533,6 +536,7 @@ struct sta_bss_parameters {
>    */
>   struct station_info {
>   	u32 filled;
> +	u32 connected_time;
>   	u32 inactive_time;
>   	u32 rx_bytes;
>   	u32 tx_bytes;
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index bf5d28d..de2d626 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -330,6 +330,7 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
>   static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>   {
>   	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct timespec uptime;
>
>   	sinfo->generation = sdata->local->sta_generation;
>
> @@ -343,7 +344,11 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>   			STATION_INFO_TX_BITRATE |
>   			STATION_INFO_RX_BITRATE |
>   			STATION_INFO_RX_DROP_MISC |
> -			STATION_INFO_BSS_PARAM;
> +			STATION_INFO_BSS_PARAM |
> +			STATION_INFO_CONNECTED_TIME;
> +
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
>
>   	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
>   	sinfo->rx_bytes = sta->rx_bytes;
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index c04a139..a15f58d 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -92,6 +92,31 @@ static ssize_t sta_inactive_ms_read(struct file *file, char __user *userbuf,
>   }
>   STA_OPS(inactive_ms);
>
> +
> +static ssize_t sta_connected_time_read(struct file *file, char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct sta_info *sta = file->private_data;
> +	struct timespec uptime;
> +	struct tm result;
> +	long connected_time_secs;
> +	char buf[100];
> +	int res;
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	connected_time_secs = uptime.tv_sec - sta->last_connected;
> +	time_to_tm(connected_time_secs, 0,&result);
> +	result.tm_year -= 70;
> +	result.tm_mday -= 1;
> +	res = scnprintf(buf, sizeof(buf),
> +		"years - %d\nmonths - %d\ndays  - %d\nclock - %d:%d:%d\n\n",
> +			result.tm_year, result.tm_mon, result.tm_mday,
> +			result.tm_hour, result.tm_min, result.tm_sec);
> +	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
> +}
> +STA_OPS(connected_time);
> +
> +
> +
>   static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
>   				      size_t count, loff_t *ppos)
>   {
> @@ -324,6 +349,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
>   	DEBUGFS_ADD(flags);
>   	DEBUGFS_ADD(num_ps_buf_frames);
>   	DEBUGFS_ADD(inactive_ms);
> +	DEBUGFS_ADD(connected_time);
>   	DEBUGFS_ADD(last_seq_ctrl);
>   	DEBUGFS_ADD(agg_status);
>   	DEBUGFS_ADD(dev);
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 999f8fb..f3be38b 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -228,6 +228,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>   {
>   	struct ieee80211_local *local = sdata->local;
>   	struct sta_info *sta;
> +	struct timespec uptime;
>   	int i;
>
>   	sta = kzalloc(sizeof(*sta) + local->hw.sta_data_size, gfp);
> @@ -245,6 +246,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>   	sta->sdata = sdata;
>   	sta->last_rx = jiffies;
>
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	stat->last_connected = uptime.tv_sec;
>   	ewma_init(&sta->avg_signal, 1024, 8);
>
>   	if (sta_prepare_rate_control(local, sta, gfp)) {
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 43238e9..424bd02 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -226,6 +226,7 @@ enum plink_state {
>    * @rx_bytes: Number of bytes received from this STA
>    * @wep_weak_iv_count: number of weak WEP IVs received from this station
>    * @last_rx: time (in jiffies) when last frame was received from this STA
> + * @last_connected: time (in seconds) when a station get connected
>    * @num_duplicates: number of duplicate frames received from this STA
>    * @rx_fragments: number of received MPDUs
>    * @rx_dropped: number of dropped MPDUs from this STA
> @@ -295,6 +296,7 @@ struct sta_info {
>   	unsigned long rx_packets, rx_bytes;
>   	unsigned long wep_weak_iv_count;
>   	unsigned long last_rx;
> +	long last_connected;
>   	unsigned long num_duplicates;
>   	unsigned long rx_fragments;
>   	unsigned long rx_dropped;
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 297d7ce..bf0ab93 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2016,6 +2016,9 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
>   	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);
>   	if (!sinfoattr)
>   		goto nla_put_failure;
> +	if (sinfo->filled&  STATION_INFO_CONNECTED_TIME)
> +		NLA_PUT_U32(msg, NL80211_STA_INFO_CONNECTED_TIME,
> +			    sinfo->connected_time);
>   	if (sinfo->filled&  STATION_INFO_INACTIVE_TIME)
>   		NLA_PUT_U32(msg, NL80211_STA_INFO_INACTIVE_TIME,
>   			    sinfo->inactive_time);
>    
As there were few compilation issues, will resend this RFC patch in a 
proper way for the review.
thanks,
shafi
