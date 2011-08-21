Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46379 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1HUP6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Aug 2011 11:58:17 -0400
Message-ID: <4E512B0D.1040109@qca.qualcomm.com> (sfid-20110821_175821_833088_EB1217B2)
Date: Sun, 21 Aug 2011 21:28:05 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>
Subject: Re: [RFC] mac80211: Add a debug entry to track last beacon
References: <1313941417-5446-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1313941417-5446-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 August 2011 09:13 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> when we obtain time_since_last_beacon_ms parameter from the mac80211
> debugfs it should be always less than 100, otherwise we are missing
> beacons.

made a mistake in the commit-log
'time_since_last_beacon_ms' should be always less than the configured 
beacon interval in the AP, otherwise we are missing beacons

>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   net/mac80211/debugfs_netdev.c |   14 ++++++++++++++
>   net/mac80211/ieee80211_i.h    |    3 +++
>   net/mac80211/mlme.c           |    2 ++
>   3 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 9ea7c0d..18e1bfc 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -157,6 +157,19 @@ IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
>   IEEE80211_IF_FILE(last_beacon, u.mgd.last_beacon_signal, DEC);
>   IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
>
> +static ssize_t ieee80211_if_fmt_time_since_last_beacon_ms(
> +	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
> +{
> +	const struct ieee80211_if_managed *ifmgd =&sdata->u.mgd;
> +	unsigned long time_since_last_beacon;
> +
> +	time_since_last_beacon = jiffies_to_msecs(jiffies -
> +						  ifmgd->last_beacon_timestamp);
> +	return scnprintf(buf, buflen, "%lu\n",
> +			 time_since_last_beacon);
> +}
> +__IEEE80211_IF_FILE(time_since_last_beacon_ms, NULL);
> +
>   static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
>   			      enum ieee80211_smps_mode smps_mode)
>   {
> @@ -394,6 +407,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
>
>   	DEBUGFS_ADD(bssid);
>   	DEBUGFS_ADD(aid);
> +	DEBUGFS_ADD(time_since_last_beacon_ms);
>   	DEBUGFS_ADD(last_beacon);
>   	DEBUGFS_ADD(ave_beacon);
>   	DEBUGFS_ADD_MODE(smps, 0600);
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ea74190..ec532a5 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -410,6 +410,9 @@ struct ieee80211_if_managed {
>
>   	u8 use_4addr;
>
> +	/* timestamp of the last Beacon frame in the current BSS. */
> +	unsigned long last_beacon_timestamp;
> +
>   	/* Signal strength from the last Beacon frame in the current BSS. */
>   	int last_beacon_signal;
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d6470c7..13ee1b6 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1758,6 +1758,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>   	if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
>   		return;
>
> +	ifmgd->last_beacon_timestamp = jiffies;
> +
>   	/* Track average RSSI from the Beacon frames of the current AP */
>   	ifmgd->last_beacon_signal = rx_status->signal;
>   	if (ifmgd->flags&  IEEE80211_STA_RESET_SIGNAL_AVE) {

