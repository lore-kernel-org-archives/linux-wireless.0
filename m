Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54675 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab1EJMCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 08:02:54 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 05:02:25 -0700
Date: Tue, 10 May 2011 17:32:43 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 1/2] ath6kl: iw dev wlan0 link implementation
Message-ID: <20110510120243.GA2017@senthil-lnx.users.atheros.com> (sfid-20110510_140303_340041_203E83A5)
References: <20110510044023.29589.38450.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110510044023.29589.38450.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 10:10:23AM +0530, Kalle Valo wrote:
> From: Naveen Singh <nsingh@atheros.com>
> 
> implementing the cfg ops that gets called when iw dev wlan0
> link is issued by user. The ops that needs to be implemented
> is get_station.
> 
> kvalo: check the mac address and fix style issues
> 
> Signed-off-by: Naveen Singh <nsingh@atheros.com>
> Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
> ---
>  drivers/staging/ath6kl/os/linux/cfg80211.c |  130 ++++++++++++++++++++++++++++
>  1 files changed, 130 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
> index efd4ae5..cb3187e 100644
> --- a/drivers/staging/ath6kl/os/linux/cfg80211.c
> +++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
> @@ -1460,6 +1460,135 @@ u32 cipher_suites[] = {
>      WLAN_CIPHER_SUITE_CCMP,
>  };
>  
> +bool is_rate_legacy(s32 rate)
> +{
> +	static const s32 legacy[] = { 1000, 2000, 5500, 11000,
> +				      6000, 9000, 12000, 18000, 24000,
> +				      36000, 48000, 54000 };
> +	u8 i;
> +
> +	for (i = 0; i < 12; i++) {
> +		if (rate == legacy[i])
> +			return true;
> +	}
> +
> +	return false;
> +}
[...]
> +
> +bool is_rate_ht20(s32 rate, u8 *mcs)
> +{
> +	static const s32 ht20[] = { 6500, 13000, 19500, 26000, 39000,
> +				     52000, 58500, 65000, 72200 };
> +	u8 i;
> +
> +	for (i = 0; i < 9; i++) {
> +		if (rate == ht20[i]) {
> +			*mcs = i;
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +bool is_rate_ht40(s32 rate, u8 *mcs)
> +{
> +	static const s32 ht40[] = { 13500, 27000, 40500, 54000,
> +					  81000, 108000, 121500, 135000 };
> +	u8 i;
> +
> +	for (i = 0; i < 9; i++) {
> +		if (rate == ht40[i]) {
> +			*mcs = i;
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
[...]
> +
> +int ar6k_get_station(struct wiphy *wiphy, struct net_device *dev,
> +		     u8 *mac, struct station_info *sinfo)
> +{
> +	struct ar6_softc *ar = ar6k_priv(dev);
> +	u8 mcs, ret, timeout = false;
> +
> +	if (compare_ether_addr(mac, ar->arBssid))
this may result in unaligned memeory access on some platforms as mac
may not be 2 byte aligned. This is the case with the caller as per
cfg80211_wext_giwrate() and cfg80211_wireless_stats().

> +		return -ENOENT;
> +
> +	if (down_interruptible(&ar->arSem))
> +		return -EBUSY;
> +
> +	ar->statsUpdatePending = true;
> +
> +	ret = wmi_get_stats_cmd(ar->arWmi);
> +
> +	if (ret != 0) {
> +		up(&ar->arSem);
> +		return -EIO;
> +	}
> +
> +	wait_event_interruptible_timeout(arEvent,
> +					 ar->statsUpdatePending == false,
> +					 wmitimeout * HZ);
> +
> +	if (signal_pending(current)) {
wait_event_interruptible_tiemout() itself checks for signal_pending and so this is
not necessary. You can check for the return status of
wait_event_interruptible_timeout() to know whether the task was interrupted by a
signal.
> +		timeout = true;
> +		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
> +				("ar6000 : WMI get stats timeout\n"));
> +	}
> +
> +	up(&ar->arSem);
I believe we can release the semaphore early on. I don't see any reason..

> +
> +	if (timeout)
Not required as mentioned earlier.. You can check the return value..
> +		return -ETIMEDOUT;
> +
> +	if (ar->arTargetStats.rx_bytes) {
> +		sinfo->rx_bytes = ar->arTargetStats.rx_bytes;
> +		sinfo->filled |= STATION_INFO_RX_BYTES;
> +		sinfo->rx_packets = ar->arTargetStats.rx_packets;
> +		sinfo->filled |= STATION_INFO_RX_PACKETS;
> +	}
> +
> +	if (ar->arTargetStats.tx_bytes) {
> +		sinfo->tx_bytes = ar->arTargetStats.tx_bytes;
> +		sinfo->filled |= STATION_INFO_TX_BYTES;
> +		sinfo->tx_packets = ar->arTargetStats.tx_packets;
> +		sinfo->filled |= STATION_INFO_TX_PACKETS;
> +	}
> +
> +	sinfo->signal = ar->arTargetStats.cs_rssi;
> +	sinfo->filled |= STATION_INFO_SIGNAL;
> +
> +	if (is_rate_legacy(ar->arTargetStats.tx_unicast_rate)) {
> +		sinfo->txrate.legacy = ar->arTargetStats.tx_unicast_rate / 100;
> +	} else if (is_rate_ht20(ar->arTargetStats.tx_unicast_rate, &mcs)) {
> +		if (mcs == 0x08) {
> +			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
> +			sinfo->txrate.mcs = mcs - 1;
> +		} else {
> +			sinfo->txrate.mcs = mcs;
> +		}
> +
> +		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
> +	} else if (is_rate_ht40(ar->arTargetStats.tx_unicast_rate, &mcs)) {
> +		if (mcs == 0x08) {
> +			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
> +			sinfo->txrate.mcs = mcs - 1;
> +		} else {
> +			sinfo->txrate.mcs = mcs;
> +		}
> +
> +		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
> +		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
> +	} else {
> +		WARN(1, "invalid rate: %d", ar->arTargetStats.tx_unicast_rate);
> +	}
> +
> +	sinfo->filled |= STATION_INFO_TX_BITRATE;
> +
> +	return 0;
> +}
> +
>  static struct
>  cfg80211_ops ar6k_cfg80211_ops = {
>      .change_virtual_intf = ar6k_cfg80211_change_iface,
> @@ -1480,6 +1609,7 @@ cfg80211_ops ar6k_cfg80211_ops = {
>      .set_power_mgmt = ar6k_cfg80211_set_power_mgmt,
>      .join_ibss = ar6k_cfg80211_join_ibss,
>      .leave_ibss = ar6k_cfg80211_leave_ibss,
> +    .get_station = ar6k_get_station,
>  };
>  
>  struct wireless_dev *
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
