Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36236 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcCXSaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 14:30:24 -0400
Received: by mail-pf0-f175.google.com with SMTP id u190so64604429pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2016 11:30:24 -0700 (PDT)
Subject: Re: [PATCH v2] cfg80211: add start / stop NAN commands
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	johannes@sipsolutions.net
References: <1458832375-25546-1-git-send-email-emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Franky Lin <franky.lin@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56F43236.7010704@broadcom.com> (sfid-20160324_193028_940424_420BEFA5)
Date: Thu, 24 Mar 2016 19:30:14 +0100
MIME-Version: 1.0
In-Reply-To: <1458832375-25546-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-3-2016 16:12, Emmanuel Grumbach wrote:
> This allows user space to start/stop NAN interface.
> A NAN interface is like P2P device in a few aspects: it
> doesn't have a netdev associated to it.
> Add the new interface type and prevent operations that
> can't be executed on NAN interface like scan.
> Define several attributes that may be configured by user space
> when starting NAN functionality (master preference and dual
> band operation)
> 
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> v2: allow master preference 1 and 255 as required by the certification
> ---
>  include/net/cfg80211.h       | 21 +++++++++-
>  include/uapi/linux/nl80211.h | 44 ++++++++++++++++++++
>  net/mac80211/cfg.c           |  2 +
>  net/mac80211/chan.c          |  3 ++
>  net/mac80211/iface.c         |  4 ++
>  net/mac80211/offchannel.c    |  1 +
>  net/mac80211/rx.c            |  3 ++
>  net/mac80211/util.c          |  1 +
>  net/wireless/chan.c          |  2 +
>  net/wireless/core.c          | 34 ++++++++++++++++
>  net/wireless/core.h          |  3 ++
>  net/wireless/mlme.c          |  1 +
>  net/wireless/nl80211.c       | 96 ++++++++++++++++++++++++++++++++++++++++++--
>  net/wireless/rdev-ops.h      | 20 +++++++++
>  net/wireless/trace.h         | 27 +++++++++++++
>  net/wireless/util.c          |  6 ++-
>  16 files changed, 261 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9e1b24c..cb5ab88 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2228,6 +2228,19 @@ struct cfg80211_qos_map {
>  };
>  
>  /**
> + * struct cfg80211_nan_conf - nan configuration
> + *
> + * This struct defines nan configuration parameters
> + *
> + * @master_pref: master preference (2 -254)

This seems to contradict the change log above...

> + * @dual: dual band operation mode
> + */
> +struct cfg80211_nan_conf {
> +	u8 master_pref;
> +	enum nl80211_nan_dual_band_conf dual;
> +};
> +
> +/**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
>   * This struct is registered by fullmac card drivers and/or wireless stacks
> @@ -2500,6 +2513,8 @@ struct cfg80211_qos_map {
>   *	and returning to the base channel for communication with the AP.
>   * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
>   *	peers must be on the base channel when the call completes.
> + * @start_nan: Start the NAN interface.
> + * @stop_nan: Stop the NAN interface.
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -2765,6 +2780,9 @@ struct cfg80211_ops {
>  	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
>  					      struct net_device *dev,
>  					      const u8 *addr);
> +	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
> +			     struct cfg80211_nan_conf *conf);
> +	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
>  };
>  
>  /*
> @@ -3486,6 +3504,7 @@ struct cfg80211_cached_keys;
>   *	beacons, 0 when not valid
>   * @address: The address for this device, valid only if @netdev is %NULL
>   * @p2p_started: true if this is a P2P Device that has been started
> + * @nan_started: true if this is a NAN interface that has been started
>   * @cac_started: true if DFS channel availability check has been started
>   * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
>   * @cac_time_ms: CAC time in ms
> @@ -3517,7 +3536,7 @@ struct wireless_dev {
>  
>  	struct mutex mtx;
>  
> -	bool use_4addr, p2p_started;
> +	bool use_4addr, p2p_started, nan_started;
>  
>  	u8 address[ETH_ALEN] __aligned(sizeof(u16));
>  
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 5a30a75..e5a7cfb 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -824,6 +824,16 @@
>   *	not running. The driver indicates the status of the scan through
>   *	cfg80211_scan_done().
>   *
> + * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
> + *	%NL80211_ATTR_WDEV interface. This interface must have been previously
> + *	created with %NL80211_CMD_NEW_INTERFACE. After it has been started, the
> + *	NAN interface will create or join a cluster. This command must have a
> + *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
> + *	%NL80211_ATTR_NAN_DUAL attributes.
> + *	After this command NAN functions can be added.
> + * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
> + *	its %NL80211_ATTR_WDEV interface.
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -1012,6 +1022,9 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_ABORT_SCAN,
>  
> +	NL80211_CMD_START_NAN,
> +	NL80211_CMD_STOP_NAN,
> +
>  	/* add new commands above here */
>  
>  	/* used to define NL80211_CMD_MAX below */
> @@ -1796,6 +1809,12 @@ enum nl80211_commands {
>   *	connecting to a PCP, and in %NL80211_CMD_START_AP to start
>   *	a PCP instead of AP. Relevant for DMG networks only.
>   *
> + * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used by
> + *	&NL80211_CMD_START_NAN. Its type is u8 and it can't be 0, 1 or 255.

... and this as well.

Regards,
Arend
