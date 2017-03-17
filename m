Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:49843 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbdCQNm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 09:42:27 -0400
Subject: Re: [PATCH 1/3] ath9k: Support channels in licensed bands
To: Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com
References: <20170316151337.24163-1-sw@simonwunderlich.de>
 <20170316151337.24163-2-sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <096bcee2-a991-eac1-8f4f-d7cf7c34730d@neratec.com> (sfid-20170317_144236_296416_89A0AB54)
Date: Fri, 17 Mar 2017 14:40:50 +0100
MIME-Version: 1.0
In-Reply-To: <20170316151337.24163-2-sw@simonwunderlich.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2017 04:13 PM, Simon Wunderlich wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Many chips support channels in licensed bands. Add support for those,
> along with a corresponding kernel config option to disable them by
> default. Note that these channels are not selectable even if the
> option has been compiled unless the user modifies the regulatory
> database to explicitly enable the corresponding channels.
> 
> NOTE:  These channels must not be used in most regulatory
> domains unless you have a license from the FCC or similar!
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> [Hide this support behind a Kconfig option]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> [only use the 20 mhz channels, add 5 ghz, change to 4.9ghz to licensed bands]
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig       | 20 ++++++++++++++++
>  drivers/net/wireless/ath/ath9k/ath9k.h       |  2 +-
>  drivers/net/wireless/ath/ath9k/common-init.c | 35 +++++++++++++++++++++-------
>  drivers/net/wireless/ath/ath9k/hw.h          |  4 ++--
>  4 files changed, 50 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 783a38f1a626..23b8abf4449a 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -116,6 +116,26 @@ config ATH9K_DFS_CERTIFIED
>  	  developed. At this point enabling this option won't do anything
>  	  except increase code size.
>  
> +config ATH9K_LICENSED_CHAN
> +	bool "Support channels in licensed bands"
> +	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
> +	default n
> +	---help---
> +	  This option enables support for licensed channels on such as
> +          4.9 GHz (public safety).
> +
> +	  These are PUBLIC SAFETY CHANNELS and MUST NOT BE USED in most
> +	  regulatory domains UNLESS YOU HAVE A FULL LICENSE for their use from
> +	  your local radio regulator, e.g. the FCC or equivalent. Using these
> +	  channels without proper authorisation may result in serious legal
> +	  consequences.
> +
> +	  You will also have to build a regulatory database with these channels
> +	  enabled to actually use them.
> +
> +	  If you are a distro kernel builder or have any doubt whatsoever about
> +	  your legal ability to use these channels, say N.
> +
>  config ATH9K_DYNACK
>  	bool "Atheros ath9k ACK timeout estimation algorithm (EXPERIMENTAL)"
>  	depends on ATH9K
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index cf076719c27e..d215c3f968d4 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -996,7 +996,7 @@ struct ath_softc {
>  	struct device *dev;
>  
>  	struct survey_info *cur_survey;
> -	struct survey_info survey[ATH9K_NUM_CHANNELS];
> +	struct survey_info survey[ATH9K_MAX_NUM_CHANNELS];
>  
>  	spinlock_t intr_lock;
>  	struct tasklet_struct intr_tq;
> diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
> index 8b4f7fdabf58..0d632c22bc16 100644
> --- a/drivers/net/wireless/ath/ath9k/common-init.c
> +++ b/drivers/net/wireless/ath/ath9k/common-init.c
> @@ -86,6 +86,22 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
>  	CHAN5G(5785, 35), /* Channel 157 */
>  	CHAN5G(5805, 36), /* Channel 161 */
>  	CHAN5G(5825, 37), /* Channel 165 */
> +
> +#ifdef CONFIG_ATH9K_LICENSED_CHAN
> +	/* 4.9Ghz channels, public safety channels, license is required in US
> +	 * and most other regulatory domains!
> +	 */
> +	/* 802.11j 4.9 GHz (20 MHz) */
> +	CHAN5G(4920, 38), /* channel 184 */
> +	CHAN5G(4940, 39), /* channel 188 */
> +	CHAN5G(4960, 40), /* channel 192 */
> +	CHAN5G(4980, 41), /* channel 196 */
> +	/* 802.11j 5.030 - 5.080 GHz (20 MHz) */
> +	CHAN5G(5040, 42), /* channel 8 */
> +	CHAN5G(5060, 43), /* channel 12 */
> +	CHAN5G(5080, 44), /* channel 16 */
> +#endif
> +#define ATH9K_NUM_LICENSED_CHANNELS 7
>  };
>  
>  /* Atheros hardware rate code addition for short premble */
> @@ -126,10 +142,14 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
>  {
>  	struct ath_hw *ah = (struct ath_hw *)common->ah;
>  	void *channels;
> +	int num_5ghz_chan = ARRAY_SIZE(ath9k_5ghz_chantable);
> +
> +	if (!IS_ENABLED(CONFIG_ATH9K_LICENSED_CHAN))
> +		num_5ghz_chan -= ATH9K_NUM_LICENSED_CHANNELS;
These two lines seem wrong to me, since the extra channels are only added to the
list if CONFIG_ATH9K_LICENSED_CHAN is defined. If it is not, this cuts off the
last 7 regular channels, no?

Cheers,
Zefir
