Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1IEJCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 05:02:23 -0400
Subject: Re: [PATCH v2] mac80211: add ssid config to bss information in
 AP-mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1315123892-5031-1-git-send-email-arik@wizery.com> (sfid-20110904_101207_398268_A1892296)
References: <1315123892-5031-1-git-send-email-arik@wizery.com>
	 (sfid-20110904_101207_398268_A1892296)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 11:02:14 +0200
Message-ID: <1315213334.4075.4.camel@jlt3.sipsolutions.net> (sfid-20110905_110227_206549_130667AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-04 at 11:11 +0300, Arik Nemtsov wrote:
> Set SSID information from nl80211 beacon parameters. Advertise changes
> in SSID to low level drivers.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v1->2: fixed a bug introduced to ieee80211_reconfig (thanks Eliad)
> 
> include/net/mac80211.h |    8 ++++++++
>  net/mac80211/cfg.c     |   19 ++++++++++++++++++-
>  net/mac80211/util.c    |    2 ++
>  3 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2f01d84..137d67d 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -164,6 +164,7 @@ struct ieee80211_low_level_stats {
>   * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
>   *	that it is only ever disabled for station mode.
>   * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
> + * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
>   */
>  enum ieee80211_bss_change {
>  	BSS_CHANGED_ASSOC		= 1<<0,
> @@ -181,6 +182,7 @@ enum ieee80211_bss_change {
>  	BSS_CHANGED_ARP_FILTER		= 1<<12,
>  	BSS_CHANGED_QOS			= 1<<13,
>  	BSS_CHANGED_IDLE		= 1<<14,
> +	BSS_CHANGED_SSID		= 1<<15,
>  
>  	/* when adding here, make sure to change ieee80211_reconfig */
>  };
> @@ -254,6 +256,9 @@ enum ieee80211_rssi_event {
>   * @idle: This interface is idle. There's also a global idle flag in the
>   *	hardware config which may be more appropriate depending on what
>   *	your driver/device needs to do.
> + * @ssid: The SSID of the current vif. Only valid in AP-mode.
> + * @ssid_len: Length of SSID given in @ssid.
> + * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
>   */
>  struct ieee80211_bss_conf {
>  	const u8 *bssid;
> @@ -280,6 +285,9 @@ struct ieee80211_bss_conf {
>  	bool arp_filter_enabled;
>  	bool qos;
>  	bool idle;
> +	u8 ssid[IEEE80211_MAX_SSID_LEN];
> +	size_t ssid_len;
> +	bool hidden_ssid;

I guess the reason you don't use the nl80211 enum here is that the
device doesn't care since the beacon is built by hostapd/mac80211 and
entirely transparent to the device?

> +static void ieee80211_config_ap_ssid(struct ieee80211_sub_if_data
> *sdata,
> +                                    struct beacon_parameters *params)

Any particular reason for not just inlining the few code lines?


However, what's this used for? Didn't we discuss this before and decide
that there's no clear way to implement probe response offloading given
the possibility that WPS, P2P and similar protocols that use probe
request/response handshaking could be in use?

johannes

