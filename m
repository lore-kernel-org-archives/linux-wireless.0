Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33120 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967376AbaLLM0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:26:43 -0500
Message-ID: <1418387190.2470.28.camel@sipsolutions.net> (sfid-20141212_132648_208805_50CBF520)
Subject: Re: [PATCHv2] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de,
	adrian@freebsd.org, haim.dreyfuss@intel.com
Date: Fri, 12 Dec 2014 13:26:30 +0100
In-Reply-To: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141201_113016_384087_BF544ED2)
References: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20141201_113016_384087_BF544ED2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 11:30 +0100, Lorenzo Bianconi wrote:
> Enable/disable per packet Transmit Power Control (TPC) in lower drivers
> according to TX power settings configured by the user. In particular TPC is
> enabled if value passed in enum nl80211_tx_power_setting is
> NL80211_TX_POWER_AUTOMATIC (no limit from userspace) or
> NL80211_TX_POWER_LIMITED (allow using less than specified from userspace),
> whereas TPC is disabled if nl80211_tx_power_setting is set to
> NL80211_TX_POWER_FIXED (use value configured from userspace)
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
>  include/net/mac80211.h     | 10 ++++++++++
>  net/mac80211/cfg.c         |  6 +++++-
>  net/mac80211/ieee80211_i.h |  1 +
>  net/mac80211/iface.c       |  8 +++++++-
>  net/mac80211/main.c        |  8 +++++++-
>  5 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index cff3a26..7dd2432 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -376,6 +376,8 @@ enum ieee80211_rssi_event {
>   * @ssid_len: Length of SSID given in @ssid.
>   * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
>   * @txpower: TX power in dBm
> + * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC) for the
> + *	current vif

Why not put the enum nl80211_tx_power_setting value here?

>  struct ieee80211_conf {
>  	u32 flags;
>  	int power_level, dynamic_ps_timeout;
> +	bool tpc_enabled;
>  	int max_sleep_period;

Do you need it here at all?
 
> +++ b/net/mac80211/ieee80211_i.h
> @@ -869,6 +869,7 @@ struct ieee80211_sub_if_data {
>  
>  	int user_power_level; /* in dBm */
>  	int ap_power_level; /* in dBm */
> +	enum nl80211_tx_power_setting tx_power_type;

if you put this into bss_conf you can of course get rid of it here.

johannes

