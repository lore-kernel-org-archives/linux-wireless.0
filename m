Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1ILHmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 03:42:37 -0400
Subject: Re: [PATCH v2] nl80211/cfg80211/mac80211: fix wme docs
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315723615-28170-1-git-send-email-eliad@wizery.com> (sfid-20110911_084511_669290_04DAE3AD)
References: <1315723615-28170-1-git-send-email-eliad@wizery.com>
	 (sfid-20110911_084511_669290_04DAE3AD)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 09:42:34 +0200
Message-ID: <1315813354.3963.0.camel@jlt3.sipsolutions.net> (sfid-20110912_094240_253163_A23D6318)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-11 at 09:46 +0300, Eliad Peller wrote:
> Add/fix some missing docs.

Thanks!

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: add format description
> 
>  include/linux/nl80211.h |    6 ++++--
>  include/net/cfg80211.h  |    4 ++++
>  include/net/mac80211.h  |    3 +++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a3f352f..e71c9f0 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -2493,8 +2493,10 @@ enum nl80211_hidden_ssid {
>  /**
>   * enum nl80211_sta_wme_attr - station WME attributes
>   * @__NL80211_STA_WME_INVALID: invalid number for nested attribute
> - * @NL80211_STA_WME_QUEUES: bitmap of uapsd queues.
> - * @NL80211_STA_WME_MAX_SP: max service period.
> + * @NL80211_STA_WME_UAPSD_QUEUES: bitmap of uapsd queues. the format
> + *	is the same as the AC bitmap in the QoS info field.
> + * @NL80211_STA_WME_MAX_SP: max service period. the format is the same
> + *	as the MAX_SP field in the QoS info field (but already shifted down).
>   * @__NL80211_STA_WME_AFTER_LAST: internal
>   * @NL80211_STA_WME_MAX: highest station WME attribute
>   */
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5390a89..248c377 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -441,6 +441,10 @@ enum plink_actions {
>   * @plink_action: plink action to take
>   * @plink_state: set the peer link state for a station
>   * @ht_capa: HT capabilities of station
> + * @uapsd_queues: bitmap of queues configured for uapsd. same format
> + *	as the AC bitmap in the QoS info field
> + * @max_sp: max Service Period. same format as the MAX_SP in the
> + *	QoS info field (but already shifted down)
>   */
>  struct station_parameters {
>  	u8 *supported_rates;
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2e752df..df1b53f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -947,6 +947,9 @@ enum set_key_cmd {
>   * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
>   * @drv_priv: data area for driver use, will always be aligned to
>   *	sizeof(void *), size is determined in hw information.
> + * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
> + *	if wme is supported.
> + * @max_sp: max Service Period. Only valid if wme is supported.
>   */
>  struct ieee80211_sta {
>  	u32 supp_rates[IEEE80211_NUM_BANDS];


