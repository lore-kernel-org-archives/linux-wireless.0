Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:50613 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932281AbbKMQ30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:29:26 -0500
Date: Fri, 13 Nov 2015 11:29:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v4 8/8] mac80211: use Kconfig counters to determine
 feature optimisation
Message-ID: <20151113112922.3442aa1a@gandalf.local.home> (sfid-20151113_172929_359703_23BF8CB1)
In-Reply-To: <1447318073-22669-9-git-send-email-johannes@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	<1447318073-22669-9-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Nov 2015 09:47:53 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Drivers that would like to have feature flag optimisations are
> currently required to select _ON and _OFF symbols for each one,
> indicating whether they'd like to be optimised for being on or
> off respectively. This handles badly, if a new feature flag is
> added then all such drivers need to be updated.
> 
> Instead, use the new Kconfig counters to determine
>  (a) the number of times each feature flag was selected ON
>  (b) the number of mac80211 drivers built
> 
> if (a) > 0 then it was requested on by at least one driver
> if (a) < (b) then it was not requested by at least one driver
> 
> This allows determining whether or not optimisations should be
> made more easily, and importantly, adding new flags no longer
> requires editing the Kconfig for all drivers since they won't
> want the new flag - only the driver it's added for does.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/Kconfig |  21 ++-
>  net/mac80211/Kconfig         |   4 +
>  net/mac80211/Kconfig.hwflags | 297 +++++++++++++++----------------------------
>  net/mac80211/hwflags.h       |   6 +-
>  4 files changed, 122 insertions(+), 206 deletions(-)
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index f2a8fdca5ede..26ffa28a5677 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -246,17 +246,16 @@ source "drivers/net/wireless/realtek/rtl818x/Kconfig"
>  config MAC80211_HWSIM
>  	tristate "Simulated radio testing tool for mac80211"
>  	depends on MAC80211
> -	select MAC80211_HW_SUPPORT_FAST_XMIT_ON
> -	select MAC80211_HW_CHANCTX_STA_CSA_ON
> -	select MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON
> -	select MAC80211_HW_QUEUE_CONTROL_ON
> -	select MAC80211_HW_WANT_MONITOR_VIF_ON
> -	select MAC80211_HW_AMPDU_AGGREGATION_ON
> -	select MAC80211_HW_MFP_CAPABLE_ON
> -	select MAC80211_HW_SIGNAL_DBM_ON
> -	select MAC80211_HW_TDLS_WIDER_BW_ON

> -	select MAC80211_HW_HAS_RATE_CONTROL_OFF
> -	select MAC80211_HW_RX_INCLUDES_FCS_OFF

What happened to these two?

> +	count MAC80211_NUM_DRIVERS
> +	count MAC80211_HW_SUPPORT_FAST_XMIT
> +	count MAC80211_HW_CHANCTX_STA_CSA
> +	count MAC80211_HW_SUPPORTS_HT_CCK_RATES
> +	count MAC80211_HW_QUEUE_CONTROL
> +	count MAC80211_HW_WANT_MONITOR_VIF
> +	count MAC80211_HW_AMPDU_AGGREGATION
> +	count MAC80211_HW_MFP_CAPABLE
> +	count MAC80211_HW_SIGNAL_DBM
> +	count MAC80211_HW_TDLS_WIDER_BW
>  	---help---
>  	  This driver is a developer testing tool that can be used to test
>  	  IEEE 802.11 networking stack (mac80211) functionality. This is not
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 206b11598dd1..9eba9c5cea18 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -11,6 +11,10 @@ config MAC80211
>  	  This option enables the hardware independent IEEE 802.11
>  	  networking stack.
>  
> +config MAC80211_NUM_DRIVERS
> +	int
> +	depends on MAC80211

Why the depends? Does it make it 1 to start with?

-- Steve

> +
>  comment "CFG80211 needs to be enabled for MAC80211"
>  	depends on CFG80211=n
>  
